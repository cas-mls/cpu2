using System.Reflection;
using System.IO.Ports;
using System.Reflection.Emit;
using System.Text.RegularExpressions;
using System.Net.NetworkInformation;
using System.ComponentModel;
//using static System.Windows.Forms.VisualStyles.VisualStyleElement;


namespace CpuDebugger
{
    public partial class Debugger : Form
    {
        TextBox[] RegsData = new TextBox[16];
        System.Windows.Forms.Label[] RegsLabel = new System.Windows.Forms.Label[16];
        SerialPort port;
        CpuState cpuState;
        CpuAccess WbAccess;

        public Debugger()
        {
            InitializeComponent();
            cpuState = new CpuState();
            WbAccess = new CpuAccess(cpuState);

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
            comPorts.Items.AddRange(WbAccess.GetPorts());
        }

        private void btnConnect_Click(object sender, EventArgs e)
        {
            WbAccess.Open(cboComPorts.Text);
            SetDisplayData();
            if (!bgwDebugStatus.IsBusy) bgwDebugStatus.RunWorkerAsync();

        }

        private void btnDisConnect_Click(object sender, EventArgs e)
        {
            WbAccess.Close();
            txtStatus.Text = "";
            if (bgwDebugStatus.IsBusy) bgwDebugStatus.CancelAsync();
        }

        private void SetStatus()
        {
            WbAccess.GetExecutionState();
            txtStatus.Text = cpuState.ExecutationState.ToString();
        }

        private void SetDisplayData()
        {
            if (bgwDebugStatus.IsBusy) bgwDebugStatus.CancelAsync();
            WbAccess.GetCpuCurrentState();
            if (!bgwDebugStatus.IsBusy) bgwDebugStatus.RunWorkerAsync();

            txtOpcode.Text = cpuState.OpcodeDecode;
            txtFlag.Text = cpuState.Flag.ToString();
            txtAccess.Text = cpuState.MemoryAccessDecode;
            txtReg1.Text = cpuState.Register1.ToString();
            txtReg2.Text = cpuState.Register2.ToString();
            txtImmed.Text = ckbHex.Checked ? cpuState.Immediate.ToString("X4") : cpuState.Immediate.ToString("D");
            if (ckbHex.Checked)
            {
                txtProgCount.Text = cpuState.ProgramCounter.ToString("X3");
                txtInstCode.Text = cpuState.InstructionCode.ToString("X8");
                txtCycles.Text = cpuState.Cycles.ToString("X8");
            }
            else
            {
                txtProgCount.Text = cpuState.ProgramCounter.ToString("d4");
                txtInstCode.Text = cpuState.InstructionCode.ToString("D10");
                txtCycles.Text = cpuState.Cycles.ToString("D10");
            }
            for (int i = 0; i < 16; i++)
            {
                if (ckbHex.Checked)
                {
                    RegsData[i].Text = cpuState.CpuRegisters[i].ToString("X8");
                }
                else
                {
                    RegsData[i].Text = cpuState.CpuRegisters[i].ToString("D8");
                }
                if (cpuState.CpuRegisters.RegisterChanged(i))
                {
                    RegsData[i].BackColor = Color.Green;
                    RegsData[i].ForeColor = Color.White;
                }
                else
                {
                    RegsData[i].BackColor = SystemColors.Window;
                    RegsData[i].ForeColor = Color.Black;
                }
                if (cpuState.Register1 == i)
                    RegsLabel[i].Text = i.ToString() + ":(R1)";
                else if (cpuState.Register2 == i)
                    RegsLabel[i].Text = i.ToString() + ":(R2)";
                else
                    RegsLabel[i].Text = i.ToString() + ":";

            }
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnStep_Click(object sender, EventArgs e)
        {
            WbAccess.PerformStep();
            SetDisplayData();
        }

        private void ckbHex_CheckedChanged(object sender, EventArgs e)
        {
            SetDisplayData();
        }

        private void btnBreak_Click(object sender, EventArgs e)
        {
            WbAccess.PerformBreak();
            SetDisplayData();
        }

        private void btnContinue_Click(object sender, EventArgs e)
        {
            WbAccess.PerformContinue();
            SetStatus();
        }

        private void bgwDebugStatus_DoWork(object sender, System.ComponentModel.DoWorkEventArgs e)
        {
            BackgroundWorker worker = sender as BackgroundWorker;
            for (; ; )
            {
                WbAccess.GetExecutionState();
                worker.ReportProgress(0, cpuState);
                if (worker.CancellationPending) break;
                System.Threading.Thread.Sleep(1000);
            }
        }

        private void bgwDebugStatus_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            CpuState state = e.UserState as CpuState;
            txtStatus.Text = state.ExecutationState.ToString();
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
