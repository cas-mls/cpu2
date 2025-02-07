using System.Reflection;
using System.IO.Ports;
using System.Reflection.Emit;
using System.Text.RegularExpressions;
using System.Net.NetworkInformation;
using System.ComponentModel;
//using static System.Windows.Forms.VisualStyles.VisualStyleElement;
using System.Text.RegularExpressions;
using System.Net;


namespace CpuDebugger
{
    public partial class txtDebugger : Form
    {
        TextBox[] RegsData = new TextBox[16];
        TextBox[] txtBreakAt = new TextBox[4];
        System.Windows.Forms.Label[] RegsLabel = new System.Windows.Forms.Label[16];
        SerialPort port;
        CpuState cpuState;
        CpuAccess WbAccess;
        BreakData breakData;
        bool changeToStopped;
        Statuses lastExecutionState = Statuses.running;

        public txtDebugger()
        {
            InitializeComponent();
            cpuState = new CpuState();
            breakData = new BreakData();
            breakData.BreakWhen = new BreakData.BreakWhenStruct()
            {
                Operation = RegOperators.REG_NOTHING,
                Register = (byte)16,
                Value = 0
            };

            WbAccess = new CpuAccess(cpuState, breakData);
            changeToStopped = false;

            CreateRegisterControls();
            CreateBreakPointControls();

        }

        private void CreateBreakPointControls()
        {
            txtBreakAt[0] = txtBreakAt0;
            txtBreakAt[0].BackColor = SystemColors.Window;
            for (int i = 1; i < txtBreakAt.Length; i++)
            {
                txtBreakAt[i] = txtBreakAt[0].Clone();
                txtBreakAt[i].Location = new Point(txtBreakAt[0].Location.X, txtBreakAt[0].Location.Y + 25 * i);
                txtBreakAt[i].Visible = true;
            }

        }

        private void CreateRegisterControls()
        {
            RegsData[0] = txtRegs0;
            RegsData[0].Enabled = true;
            RegsData[0].ReadOnly = true;
            RegsData[0].BackColor = SystemColors.Window;
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
            while (bgwDebugStatus.IsBusy) Application.DoEvents();
            WbAccess.GetCpuCurrentState();
            if (!bgwDebugStatus.IsBusy) bgwDebugStatus.RunWorkerAsync();

            lblInstSplit.Text = cpuState.InstructionSplit;
            lblAssemInst.Text = cpuState.AssemblyInstruction(ckbHex.Checked);
            lblMemArg.Text = cpuState.MemoryArg.ToString("x8");
            lblInterrupt.Text = cpuState.Interrupt.ToString("x8");
            lblInterMask.Text = cpuState.InterruptMask.ToString("x8");
            lblStatusWord.Text = cpuState.StatusRegister.ToString("x8");
            lblStatusMask.Text = cpuState.StatusMask.ToString("x8");

            if (ckbHex.Checked)
            {
                txtProgCount.Text = cpuState.ProgramCounter.ToString("x3");
                txtInstCode.Text = cpuState.InstructionCode.ToString("x8");
                txtCycles.Text = cpuState.Cycles.ToString("x8");
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
            ushort address = 0;
            if (cpuState.MemoryAccess == 2)
            {
                address = cpuState.Immediate;
            }
            else if (cpuState.MemoryAccess == 3)
            {
                address = (ushort)(cpuState.Immediate + cpuState.CpuRegisters[cpuState.Register2]);
            }

        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnStep_Click(object sender, EventArgs e)
        {
            if (bgwDebugStatus.IsBusy) bgwDebugStatus.CancelAsync();
            while (bgwDebugStatus.IsBusy) Application.DoEvents();
            WbAccess.PerformStep();
            if (!bgwDebugStatus.IsBusy) bgwDebugStatus.RunWorkerAsync();
            SetDisplayData();
        }

        private void ckbHex_CheckedChanged(object sender, EventArgs e)
        {
            SetDisplayData();
        }

        private void btnBreak_Click(object sender, EventArgs e)
        {
            if (bgwDebugStatus.IsBusy) bgwDebugStatus.CancelAsync();
            while (bgwDebugStatus.IsBusy) Application.DoEvents();
            WbAccess.PerformBreak();
            if (!bgwDebugStatus.IsBusy) bgwDebugStatus.RunWorkerAsync();
            SetDisplayData();
        }

        private void btnContinue_Click(object sender, EventArgs e)
        {
            if (bgwDebugStatus.IsBusy) bgwDebugStatus.CancelAsync();
            while (bgwDebugStatus.IsBusy) Application.DoEvents();
            WbAccess.PerformContinue();
            if (!bgwDebugStatus.IsBusy) bgwDebugStatus.RunWorkerAsync();
            SetStatus();
        }

        private void bgwDebugStatus_DoWork(object sender, System.ComponentModel.DoWorkEventArgs e)
        {
            if (!(sender is BackgroundWorker))
                return;
            BackgroundWorker worker = sender as BackgroundWorker;
            for (; ; )
            {
                if (worker.CancellationPending)
                {
                    e.Cancel = true;
                    return;
                }
                WbAccess.GetExecutionState();
                if (cpuState.ExecutationState == Statuses.stopped &
                    lastExecutionState == Statuses.running)
                {
                    changeToStopped = true;
                }
                else if (changeToStopped)
                {
                    changeToStopped = false;
                }
                lastExecutionState = cpuState.ExecutationState;

                worker.ReportProgress(0, cpuState);
                System.Threading.Thread.Sleep(500);
            }
        }

        private void bgwDebugStatus_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            CpuState state = e.UserState as CpuState;
            txtStatus.Text = state.ExecutationState.ToString();
            if (changeToStopped)
                SetDisplayData();
        }

        private void btnBreakAt_Click(object sender, EventArgs e)
        {
            for (int i = 0; i < txtBreakAt.Length; i++)
            {
                if (Regex.Match(txtBreakAt[i].Text, "^[0-9A-F]+$", RegexOptions.IgnoreCase) != Match.Empty)
                {
                    breakData.BreakAt[i].Location = Convert.ToUInt32(txtBreakAt[i].Text, 16);
                    breakData.BreakAt[i].Valid = true;
                }
                else
                {
                    breakData.BreakAt[i].Location = 0;
                    breakData.BreakAt[i].Valid = false;
                }
            }
            if (bgwDebugStatus.IsBusy) bgwDebugStatus.CancelAsync();
            WbAccess.BreakAt();
            if (!bgwDebugStatus.IsBusy) bgwDebugStatus.RunWorkerAsync();

        }

        private void btnBreakWhen_Click(object sender, EventArgs e)
        {
            int reg;
            if (int.TryParse(txtBWhenReg.Text, out reg)
                && (Regex.Match(txtBWhenValue.Text, "^[0-9A-F]+$", RegexOptions.IgnoreCase) != Match.Empty)
                && (reg >= 0 && reg < 16))
            {
                breakData.BreakWhen = new BreakData.BreakWhenStruct()
                {
                    Operation = BreakData.Operators[cbRegOper.Text],
                    Register = (byte)reg,
                    Value = Convert.ToUInt32(txtBWhenValue.Text, 16)
                };
            }
            else
                breakData.BreakWhen = new BreakData.BreakWhenStruct()
                {
                    Operation = RegOperators.REG_NOTHING,
                    Register = (byte)0,
                    Value = 0
                };

            WbAccess.BreakWhen();
        }

        private void txtDebugger_Load(object sender, EventArgs e)
        {
            cbRegOper.Items.AddRange( BreakData.Operations );
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
