using System.Reflection;
using System.IO.Ports;
using System.Reflection.Emit;
using System.Text.RegularExpressions;
//using static System.Windows.Forms.VisualStyles.VisualStyleElement;


namespace CpuDebugger
{
    public partial class Debugger : Form
    {
        TextBox[] RegsData = new TextBox[16];
        System.Windows.Forms.Label[] RegsLabel = new System.Windows.Forms.Label[16];
        SerialPort port;

        Statuses status;
        uint[] priorRegs = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

        enum DebugCmdAddr { DebugMode = 0, DebugBreak = 1, DebugStep = 2, DebugContinue = 3 }

        Dictionary<byte, string> AccessMap = new Dictionary<byte, string>()
            {   {0, "REGREG" },
                {1, "IMMED" },
                {2, "ABSOLUTE" },
                {3, "INDEX" } };


        public Debugger()
        {
            InitializeComponent();
            RegsData[0] = txtRegs0;
            RegsData[0].Enabled = true;
            RegsData[0].ReadOnly = true;
            RegsLabel[0] = lblReg0;
            for (int i = 1; i < RegsData.Length; i++)
            {
                RegsLabel[i] = RegsLabel[0].Clone();
                RegsLabel[i].Text = i.ToString() + ":";
                RegsLabel[i].Location = new Point(RegsLabel[0].Location.X, RegsLabel[0].Location.Y + 25 * i);
                RegsLabel[i].Visible = true;
                RegsData[i] = RegsData[0].Clone();
                RegsData[i].Location = new Point(RegsData[0].Location.X, RegsData[0].Location.Y + 25 * i);
                RegsData[i].Visible = true;
                RegsData[i].Enabled = true;
                RegsData[i].ReadOnly = true;
            }
            RegsData[0].Visible = true;
            RegsLabel[0].Visible = true;
            this.Refresh();

        }

        private void cboComPorts_DropDown(object sender, EventArgs e)
        {
            ComboBox comPorts = sender as ComboBox;
            comPorts.Items.Clear();
            comPorts.Items.AddRange(SerialWishbone.GetPorts());
        }

        private void btnConnect_Click(object sender, EventArgs e)
        {
            port = SerialWishbone.Open(cboComPorts.Text);
            SetStatus();
        }

        private void btnDisConnect_Click(object sender, EventArgs e)
        {
            SerialWishbone.Close(port);
            status = Statuses.notconnected;
            txtStatus.Text = "";
        }

        private void SetStatus()
        {
            status = SerialWishbone.read(port, (byte)Cmd.Commands, (ushort)CmdStatusAddr.Status) == 0 ? Statuses.running : Statuses.stopped;
            txtStatus.Text = status.ToString();
            if (status == Statuses.stopped)
            {
                SetDisplayData();
            }
        }

        private void SetDisplayData()
        {
            ushort pc = (ushort)SerialWishbone.read(
                port,
                (byte)Cmd.Commands,
                (ushort)CmdStatusAddr.ProgCounter);
            uint inst = (uint)SerialWishbone.read(
                port,
                (byte)Cmd.Commands,
                (ushort)CmdStatusAddr.Instruction);
            //  10987654321098765432109876543210
            uint OpCode = inst & 0xf8000000; OpCode >>= 27;
            //uint OpCode = inst & 0B11111000000000000000000000000000; OpCode >>= 27;
            //txtOpcode.Text = OpCodeMap[(byte)OpCode];
            uint flag = inst & 0x04000000; flag >>= 26;
            //uint flag = inst & 0B00000100000000000000000000000000; flag >>= 26;
            txtFlag.Text = flag.ToString();
            uint access = inst & 0x03000000; access >>= 24;
            //uint access = inst & 0B00000011000000000000000000000000; access >>= 24;
            txtAccess.Text = AccessMap[(byte)access];
            uint reg1 = inst & 0x00f00000; reg1 >>= 20;
            //uint reg1 = inst & 0B00000000111100000000000000000000; reg1 >>= 20;
            txtReg1.Text = reg1.ToString();
            uint reg2 = inst & 0x000f0000; reg2 >>= 16;
            //uint reg2 = inst & 0B00000000000011110000000000000000; reg2 >>= 16;
            txtReg2.Text = reg2.ToString();
            uint imm = inst & 0x0000ffff;
            //uint imm = inst & 0B00000000000000001111111111111111;
            txtImmed.Text = ckbHex.Checked ? imm.ToString("X4") : imm.ToString("D");
            txtOpcode.Text = DecodeOpcode(OpCode, flag, reg2);
            uint cycles = (ushort)SerialWishbone.read(
                port,
                (byte)Cmd.Commands,
                (ushort)CmdStatusAddr.Cycles);
            if (ckbHex.Checked)
            {
                txtProgCount.Text = pc.ToString("X3");
                txtInstCode.Text = inst.ToString("X8");
                txtCycles.Text = cycles.ToString("X8");
            }
            else
            {
                txtProgCount.Text = pc.ToString("d4");
                txtInstCode.Text = inst.ToString("D10");
                txtCycles.Text = cycles.ToString("D10");
            }
            for (int i = 0; i < 16; i++)
            {
                uint reg = (uint)SerialWishbone.read(
                    port,
                    (byte)Cmd.Registers,
                    (ushort)i);
                if (ckbHex.Checked)
                {
                    RegsData[i].Text = reg.ToString("X8");
                }
                else
                {
                    RegsData[i].Text = reg.ToString("D8");
                }
                if (reg != priorRegs[i])
                {
                    RegsData[i].BackColor = Color.Green;
                    RegsData[i].ForeColor = Color.White;
                }
                else
                {
                    RegsData[i].BackColor = SystemColors.Window;
                    RegsData[i].ForeColor = Color.Black;
                }
                if (reg1 == i)
                    RegsLabel[i].Text = i.ToString() + ":(R1)";
                else if (reg2 == i)
                    RegsLabel[i].Text = i.ToString() + ":(R2)";
                else
                    RegsLabel[i].Text = i.ToString() + ":";

                priorRegs[i] = reg;
            }
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnStep_Click(object sender, EventArgs e)
        {
            SerialWishbone.write(port, (byte)Cmd.Commands, (ushort)DebugCmdAddr.DebugStep, (uint)0);
            SetStatus();
        }

        private void ckbHex_CheckedChanged(object sender, EventArgs e)
        {
            SetDisplayData();
        }

        private void btnBreak_Click(object sender, EventArgs e)
        {
            SerialWishbone.write(port, (byte)Cmd.Commands, (ushort)DebugCmdAddr.DebugBreak, (uint)0);
            SetStatus();
        }

        private void btnContinue_Click(object sender, EventArgs e)
        {
            SerialWishbone.write(port, (byte)Cmd.Commands, (ushort)DebugCmdAddr.DebugContinue, (uint)0);
            SetStatus();
        }

        private string DecodeOpcode(uint Opcode, uint Flag, uint reg2)
        {
            string results = "";
            switch (Opcode)
            {
                case 0x02:
                    results = (Flag == 0 ? "ldl" : "ldh");
                    break;
                case 0x04:
                    results = "st";
                    break;
                case 0x06:
                    results = "jmp";
                    break;
                case 0x08:
                    results = "jsr";
                    break;
                case 0x0A:
                    results = "rtn";
                    break;
                case 0x0C:
                    if (reg2 != 0)
                        results = Flag == 0 ? "be" : "bne";
                    else
                        results = Flag == 0 ? "bz" : "bnz";
                    break;
                case 0x0E:
                    if (reg2 != 0)
                        results = Flag == 0 ? "bl" : "bge";
                    else
                        results = Flag == 0 ? "bn" : "bnn";
                    break;
                case 0x10:
                    if (reg2 != 0)
                        results = Flag == 0 ? "bg" : "ble";
                    else
                        results = Flag == 0 ? "bp" : "bnp";
                    break;
                case 0x12:
                    results = Flag == 0 ? "push" : "pop";
                    break;
                case 0x14:
                    if (reg2 != 0)
                        results = Flag == 0 ? "timer" : "cancel";
                    else
                        results = Flag == 0 ? "wait" : "cancel";
                    break;
                case 0x16:
                    results = Flag == 0 ? "rio" : "wio";
                    break;
                case 0x18:
                    results = Flag == 0 ? "rsio" : "wsio";
                    break;
                case 0x1A:
                    results = "rti";
                    break;
                case 0x1C:
                    results = "swi";
                    break;
                case 0x1E:
                    results = "iena";
                    break;

                case 0x01:
                    results = "add";
                    break;
                case 0x03:
                    results = "sub";
                    break;
                case 0x05:
                    results = Flag == 0 ? "and" : "nand";
                    break;
                case 0x07:
                    results = Flag == 0 ? "aor" : "nor";
                    break;
                case 0x09:
                    results = "empty";
                    break;
                case 0x0B:
                    results = Flag == 0 ? "xor" : "xnor";
                    break;
                case 0x0D:
                    results = "sll";
                    break;
                case 0x0F:
                    results = "srl";
                    break;
                default:
                    results = "empty";
                    break;
            }
            return results;
        }
    }

    public static class ControlExtensions
    {
        public static T Clone<T>(this T controlToClone)
            where T : Control
        {
            PropertyInfo[] controlProperties = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);

            T instance = Activator.CreateInstance<T>();

            foreach (PropertyInfo propInfo in controlProperties)
            {
                if (propInfo.CanWrite)
                {
                    if (propInfo.Name != "WindowTarget")
                        propInfo.SetValue(instance, propInfo.GetValue(controlToClone, null), null);
                }
            }

            return instance;
        }
    }

}
