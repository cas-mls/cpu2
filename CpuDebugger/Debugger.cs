using System.Reflection;
using System.IO.Ports;
using System.Text.RegularExpressions;
using System.ComponentModel;
using System;
using Common;


namespace CpuDebugger
{
    public partial class txtDebugger : Form
    {
        TextBox[] RegsData = new TextBox[16];
        TextBox[] txtBreakAt = new TextBox[4];
        TextBox[] MemAddr = new TextBox[15];
        TextBox[] MemData = new TextBox[15];

        System.Windows.Forms.Label[] RegsLabel = new System.Windows.Forms.Label[16];

        Dictionary<CmdStatusAddr, Control> DebugControls = new Dictionary<CmdStatusAddr, Control>();

        CpuState cpuState;
        CpuState priorCpuState;
        CpuState cpuStateUpdate;
        int[] regChanges = new int[0];
        CpuAccess WbAccess;
        BreakData breakData;
        bool changeToStopped;
        Statuses lastExecutionState = Statuses.running;


        public txtDebugger()
        {
            InitializeComponent();
            cpuState = new CpuState(true);
            priorCpuState = new CpuState(true);
            cpuStateUpdate = new CpuState(false);
            breakData = new BreakData();
            breakData.BreakWhen = new BreakData.BreakWhenStruct()
            {
                Operation = RegOperators.REG_NOTHING,
                Register = (byte)16,
                Value = 0
            };

            WbAccess = new CpuAccess(cpuState, cpuStateUpdate, breakData);
            changeToStopped = false;

            //DebugControls.Add(CmdStatusAddr.Status, txtStatus);
            DebugControls.Add(CmdStatusAddr.ProgCounter, txtProgCount);
            DebugControls.Add(CmdStatusAddr.Instruction, txtInstCode);
            DebugControls.Add(CmdStatusAddr.Cycles, lblCycles);
            DebugControls.Add(CmdStatusAddr.Interrupt, txtInterrupt);
            DebugControls.Add(CmdStatusAddr.InterruptMask, txtInterMask);
            DebugControls.Add(CmdStatusAddr.SwStatus, txtStatusWord);
            DebugControls.Add(CmdStatusAddr.StatusMask, txtStatusMask);
            DebugControls.Add(CmdStatusAddr.MemoryArg, lblMemArg);


            CreateRegisterControls();
            CreateBreakPointControls();
            CreateMemoryControls();

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
            RegsData[0].ReadOnly = false;
            RegsData[0].BackColor = SystemColors.Window;
            RegsData[0].TextChanged += TxtRegData_TextChanged;
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
                RegsData[i].ReadOnly = false;
                RegsData[i].TextChanged += TxtRegData_TextChanged;
            }
            RegsData[0].Visible = true;
            RegsLabel[0].Visible = true;
            this.Refresh();
        }


        private void CreateMemoryControls()
        {
            MemAddr[0] = txtMemAddr;
            MemAddr[0].Enabled = true;
            MemAddr[0].ReadOnly = false;
            MemAddr[0].BackColor = SystemColors.Window;
            MemAddr[0].Tag = 0;
            MemAddr[0].TextChanged += txtMemAddr_TextChanged;
            MemData[0] = txtMemData;
            MemData[0].Enabled = true;
            MemData[0].ReadOnly = false;
            MemData[0].BackColor = SystemColors.Window;
            MemData[0].Tag = 0;
            MemData[0].TextChanged += TxtMemData_TextChanged;
            for (int i = 1; i < MemAddr.Length; i++)
            {
                MemAddr[i] = MemAddr[0].Clone();
                MemAddr[i].Location = new Point(MemAddr[0].Location.X, MemAddr[0].Location.Y + 25 * i);
                MemAddr[i].Visible = true;
                MemAddr[i].Tag = i;
                MemAddr[i].TextChanged += txtMemAddr_TextChanged;
                MemData[i] = MemData[0].Clone();
                MemData[i].Location = new Point(MemData[0].Location.X, MemData[0].Location.Y + 25 * i);
                MemData[i].Visible = true;
                MemData[i].Tag = i;

            }
            this.Refresh();
        }

        private void TxtMemData_TextChanged(object? sender, EventArgs e)
        {
            if (sender == null || !(sender is TextBox))
                return;
            TextBox txt = sender as TextBox;
            txt.Text = Regex.Replace(txt.Text, "[^0-9A-F]", "", RegexOptions.IgnoreCase);
        }

        private void TxtRegData_TextChanged(object? sender, EventArgs e)
        {
            if (sender == null || !(sender is TextBox))
                return;
            TextBox txt = sender as TextBox;
            txt.Text = Regex.Replace(txt.Text, "[^0-9A-F]", "", RegexOptions.IgnoreCase);
        }

        private void txtMemAddr_TextChanged(object? sender, EventArgs e)
        {
            if (sender == null || !(sender is TextBox))
                return;
            TextBox txt = sender as TextBox;
            txt.Text = Regex.Replace(txt.Text, "[^0-9A-F]", "", RegexOptions.IgnoreCase);
            int i = (int)txt.Tag;
            if (!string.IsNullOrEmpty(txt.Text))
            {
                cpuState.AddMemory(i, Convert.ToUInt16(txt.Text, 16));
            }
            else
            {
                cpuState.RemoveMemory(i);
                MemData[i].Text = "";
            }

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
            lastExecutionState = cpuState.ExecutationState;
        }

        private void SetDisplayData()
        {
            if (bgwDebugStatus.IsBusy) bgwDebugStatus.CancelAsync();
            while (bgwDebugStatus.IsBusy) Application.DoEvents();
            WbAccess.GetCpuCurrentState();
            if (!bgwDebugStatus.IsBusy) bgwDebugStatus.RunWorkerAsync();

            lblInstSplit.Text = cpuState.InstructionSplit;
            lblAssemInst.Text = cpuState.AssemblyInstruction(ckbHex.Checked);

            foreach (CmdStatusAddr addr in Enum.GetValues(typeof(CmdStatusAddr)))
            {
                if (DebugControls.ContainsKey(addr))
                {
                    if (ckbHex.Checked)
                    {
                        if (addr == CmdStatusAddr.ProgCounter)
                            DebugControls[addr].Text = cpuState.getValue(addr).ToString("x3");
                        else if (addr == CmdStatusAddr.Interrupt)
                            DebugControls[addr].Text = cpuState.getValue(addr).ToString("x2");
                        else
                            DebugControls[addr].Text = cpuState.getValue(addr).ToString("x8");
                    }
                    else
                    {
                        DebugControls[addr].Text = cpuState.getValue(addr).ToString("D10");
                    }
                }
            }

            for (int i = 0; i < 16; i++)
            {
                if (ckbHex.Checked)
                {
                    RegsData[i].Text = cpuState.getRegisterValue(i).ToString("X8");
                }
                else
                {
                    RegsData[i].Text = cpuState.getRegisterValue(i).ToString("D8");
                }

                if (cpuState.Register1 == i)
                    RegsLabel[i].Text = i.ToString() + ":(R1)";
                else if (cpuState.Register2 == i)
                    if (cpuState.ValidRegZero)
                        RegsLabel[i].Text = i.ToString() + ":(R2)";
                    else
                        RegsLabel[i].Text = i.ToString() + ":";
                else
                    RegsLabel[i].Text = i.ToString() + ":";

            }
            // Turn the old changes off.
            foreach (int reg in regChanges)
            {
                RegsData[reg].BackColor = SystemColors.Window;
                RegsData[reg].ForeColor = Color.Black;
            }
            // Turn on the new changes.
            regChanges = priorCpuState.Changes(cpuState);
            foreach (int reg in regChanges)
            {
                RegsData[reg].BackColor = Color.Green;
                RegsData[reg].ForeColor = Color.White;
            }

            foreach (Memory mem in cpuState.GetAllMemory())
            {
                if (ckbHex.Checked)
                {
                    MemAddr[mem.Index].Text = mem.Address.ToString("x3");
                    MemData[mem.Index].Text = mem.Data.ToString("x8");
                }
                else
                {
                    MemAddr[mem.Index].Text = mem.Address.ToString("d4");
                    MemData[mem.Index].Text = mem.Data.ToString("D10");
                }
            }
            priorCpuState.copy(cpuState);
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
            cbRegOper.Items.AddRange(BreakData.Operations);
        }

        private void btnReset_Click(object sender, EventArgs e)
        {
            if (bgwDebugStatus.IsBusy) bgwDebugStatus.CancelAsync();
            while (bgwDebugStatus.IsBusy) Application.DoEvents();
            WbAccess.Reset();
            if (!bgwDebugStatus.IsBusy) bgwDebugStatus.RunWorkerAsync();
        }

        private void btnApply_Click(object sender, EventArgs e)
        {
            checkUserUpdatedMemory();
            checkUserUpdatedRegister();
            checkUserUpdatedStatuses();
            if (bgwDebugStatus.IsBusy) bgwDebugStatus.CancelAsync();
            while (bgwDebugStatus.IsBusy) Application.DoEvents();
            WbAccess.UpdateMemory();
            WbAccess.UpdateRegisters();
            WbAccess.UpdateStatuses();
            if (!bgwDebugStatus.IsBusy) bgwDebugStatus.RunWorkerAsync();
            SetDisplayData();
        }

        private void checkUserUpdatedMemory()
        {
            foreach (Memory mem in cpuState.GetAllMemory())
            {
                if (!string.IsNullOrEmpty(MemData[mem.Index].Text))
                {
                    uint data = Convert.ToUInt32(MemData[mem.Index].Text, 16);
                    if (mem.Data != data)
                    {
                        cpuStateUpdate.AddMemory(mem.Index, mem.Address, data);
                    }
                    else
                    {
                        cpuStateUpdate.RemoveMemory(mem.Index);
                    }
                }
                else
                {
                    cpuStateUpdate.RemoveMemory(mem.Index);
                }
            }
        }
        private void checkUserUpdatedRegister()
        {
            for (int regNum = 0; regNum < 16; regNum++)
            {
                if (!string.IsNullOrEmpty(RegsData[regNum].Text))
                {
                    uint data = Convert.ToUInt32(RegsData[regNum].Text, 16);
                    if (cpuState.getRegisterValue(regNum) != data)
                    {
                        cpuStateUpdate.AddRegister(regNum, data);
                    }
                    else
                    {
                        cpuStateUpdate.RemoveRegister(regNum);
                    }
                }
                else
                {
                    cpuStateUpdate.RemoveRegister(regNum);
                }
            }
        }

        private void checkUserUpdatedStatuses()
        {
            foreach (CmdStatusAddr addr in Enum.GetValues(typeof(CmdStatusAddr)))
            {
                if (DebugControls.ContainsKey(addr))
                {
                    if (!string.IsNullOrEmpty(DebugControls[addr].Text))
                    {
                        uint data = Convert.ToUInt32(DebugControls[addr].Text, 16);
                        if (cpuState.getValue(addr) != data)
                        {
                            cpuStateUpdate.AddStatus(addr, data);
                        }
                        else
                        {
                            cpuStateUpdate.RemoveStatus(addr);
                        }
                    }
                    else
                    {
                        cpuStateUpdate.RemoveStatus(addr);
                    }
                }
            }
        }

        private void txtInterrupt_TextChanged(object sender, EventArgs e)
        {
            if (sender == null || !(sender is TextBox))
                return;
            TextBox txt = sender as TextBox;
            txt.Text = Regex.Replace(txt.Text, "[^0-9A-F]", "", RegexOptions.IgnoreCase);
        }

        private void txtInterMask_TextChanged(object sender, EventArgs e)
        {
            if (sender == null || !(sender is TextBox))
                return;
            TextBox txt = sender as TextBox;
            txt.Text = Regex.Replace(txt.Text, "[^0-9A-F]", "", RegexOptions.IgnoreCase);
        }

        private void txtStatusWord_TextChanged(object sender, EventArgs e)
        {
            if (sender == null || !(sender is TextBox))
                return;
            TextBox txt = sender as TextBox;
            txt.Text = Regex.Replace(txt.Text, "[^0-9A-F]", "", RegexOptions.IgnoreCase);
        }

        private void txtStatusMask_TextChanged(object sender, EventArgs e)
        {
            if (sender == null || !(sender is TextBox))
                return;
            TextBox txt = sender as TextBox;
            txt.Text = Regex.Replace(txt.Text, "[^0-9A-F]", "", RegexOptions.IgnoreCase);
        }

        private void btnUpload_Click(object sender, EventArgs e)
        {
            FileDialog fd = new OpenFileDialog();
            fd.DefaultExt = ".wp";
            fd.Filter = "Wishbone Program Files (*.wp)|*.wp|Binary files (*.bin)|*.bin";
            if (fd.ShowDialog() == DialogResult.OK)
            {
                WbAccess.Upload(fd.FileName);
            }
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
