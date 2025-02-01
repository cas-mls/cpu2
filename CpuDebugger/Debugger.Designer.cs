namespace CpuDebugger
{
    partial class txtDebugger
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            grpCommands = new GroupBox();
            cbRegOper = new ComboBox();
            label15 = new Label();
            label14 = new Label();
            txtBWhenValue = new TextBox();
            txtBWhenReg = new TextBox();
            label12 = new Label();
            btnBreakWhen = new Button();
            txtBreakAt0 = new TextBox();
            btnBreakAt = new Button();
            btnContinue = new Button();
            btnStep = new Button();
            btnBreak = new Button();
            grpRegisters = new GroupBox();
            txtRegs0 = new TextBox();
            lblReg0 = new Label();
            grpInstruction = new GroupBox();
            label8 = new Label();
            label9 = new Label();
            lblStatusMask = new Label();
            lblStatusWord = new Label();
            lblInterMask = new Label();
            lblInterrupt = new Label();
            lblMemArg = new Label();
            label7 = new Label();
            label6 = new Label();
            label5 = new Label();
            label4 = new Label();
            lblInstSplit = new Label();
            lblAssemInst = new Label();
            txtCycles = new TextBox();
            txtInstCode = new TextBox();
            label3 = new Label();
            label2 = new Label();
            label1 = new Label();
            txtProgCount = new TextBox();
            btnCancel = new Button();
            label10 = new Label();
            txtStatus = new TextBox();
            ckbHex = new CheckBox();
            cboComPorts = new ComboBox();
            label11 = new Label();
            btnConnect = new Button();
            btnDisConnect = new Button();
            bgwDebugStatus = new System.ComponentModel.BackgroundWorker();
            grpCommands.SuspendLayout();
            grpRegisters.SuspendLayout();
            grpInstruction.SuspendLayout();
            SuspendLayout();
            // 
            // grpCommands
            // 
            grpCommands.Controls.Add(cbRegOper);
            grpCommands.Controls.Add(label15);
            grpCommands.Controls.Add(label14);
            grpCommands.Controls.Add(txtBWhenValue);
            grpCommands.Controls.Add(txtBWhenReg);
            grpCommands.Controls.Add(label12);
            grpCommands.Controls.Add(btnBreakWhen);
            grpCommands.Controls.Add(txtBreakAt0);
            grpCommands.Controls.Add(btnBreakAt);
            grpCommands.Controls.Add(btnContinue);
            grpCommands.Controls.Add(btnStep);
            grpCommands.Controls.Add(btnBreak);
            grpCommands.Location = new Point(146, 14);
            grpCommands.Margin = new Padding(3, 2, 3, 2);
            grpCommands.Name = "grpCommands";
            grpCommands.Padding = new Padding(3, 2, 3, 2);
            grpCommands.Size = new Size(213, 321);
            grpCommands.TabIndex = 0;
            grpCommands.TabStop = false;
            grpCommands.Text = "Commands";
            // 
            // cbRegOper
            // 
            cbRegOper.FormattingEnabled = true;
            cbRegOper.Location = new Point(53, 217);
            cbRegOper.Name = "cbRegOper";
            cbRegOper.Size = new Size(71, 23);
            cbRegOper.TabIndex = 15;
            // 
            // label15
            // 
            label15.AutoSize = true;
            label15.Location = new Point(142, 200);
            label15.Name = "label15";
            label15.Size = new Size(35, 15);
            label15.TabIndex = 14;
            label15.Text = "Value";
            // 
            // label14
            // 
            label14.AutoSize = true;
            label14.Location = new Point(80, 200);
            label14.Name = "label14";
            label14.Size = new Size(23, 15);
            label14.TabIndex = 13;
            label14.Text = "Op";
            // 
            // txtBWhenValue
            // 
            txtBWhenValue.Location = new Point(130, 217);
            txtBWhenValue.Margin = new Padding(3, 2, 3, 2);
            txtBWhenValue.Name = "txtBWhenValue";
            txtBWhenValue.Size = new Size(73, 23);
            txtBWhenValue.TabIndex = 12;
            // 
            // txtBWhenReg
            // 
            txtBWhenReg.Location = new Point(20, 217);
            txtBWhenReg.Margin = new Padding(3, 2, 3, 2);
            txtBWhenReg.Name = "txtBWhenReg";
            txtBWhenReg.Size = new Size(27, 23);
            txtBWhenReg.TabIndex = 10;
            // 
            // label12
            // 
            label12.AutoSize = true;
            label12.Location = new Point(20, 197);
            label12.Name = "label12";
            label12.Size = new Size(27, 15);
            label12.TabIndex = 9;
            label12.Text = "Reg";
            // 
            // btnBreakWhen
            // 
            btnBreakWhen.Location = new Point(19, 173);
            btnBreakWhen.Margin = new Padding(3, 2, 3, 2);
            btnBreakWhen.Name = "btnBreakWhen";
            btnBreakWhen.Size = new Size(82, 22);
            btnBreakWhen.TabIndex = 8;
            btnBreakWhen.Text = "Brk When";
            btnBreakWhen.UseVisualStyleBackColor = true;
            btnBreakWhen.Click += btnBreakWhen_Click;
            // 
            // txtBreakAt0
            // 
            txtBreakAt0.Location = new Point(20, 74);
            txtBreakAt0.Margin = new Padding(3, 2, 3, 2);
            txtBreakAt0.Name = "txtBreakAt0";
            txtBreakAt0.Size = new Size(83, 23);
            txtBreakAt0.TabIndex = 4;
            // 
            // btnBreakAt
            // 
            btnBreakAt.Location = new Point(20, 48);
            btnBreakAt.Margin = new Padding(3, 2, 3, 2);
            btnBreakAt.Name = "btnBreakAt";
            btnBreakAt.Size = new Size(82, 22);
            btnBreakAt.TabIndex = 3;
            btnBreakAt.Text = "Break At";
            btnBreakAt.UseVisualStyleBackColor = true;
            btnBreakAt.Click += btnBreakAt_Click;
            // 
            // btnContinue
            // 
            btnContinue.Location = new Point(107, 47);
            btnContinue.Margin = new Padding(3, 2, 3, 2);
            btnContinue.Name = "btnContinue";
            btnContinue.Size = new Size(82, 22);
            btnContinue.TabIndex = 2;
            btnContinue.Text = "Continue";
            btnContinue.UseVisualStyleBackColor = true;
            btnContinue.Click += btnContinue_Click;
            // 
            // btnStep
            // 
            btnStep.Location = new Point(107, 21);
            btnStep.Margin = new Padding(3, 2, 3, 2);
            btnStep.Name = "btnStep";
            btnStep.Size = new Size(82, 22);
            btnStep.TabIndex = 1;
            btnStep.Text = "Step";
            btnStep.UseVisualStyleBackColor = true;
            btnStep.Click += btnStep_Click;
            // 
            // btnBreak
            // 
            btnBreak.Location = new Point(19, 22);
            btnBreak.Margin = new Padding(3, 2, 3, 2);
            btnBreak.Name = "btnBreak";
            btnBreak.Size = new Size(82, 22);
            btnBreak.TabIndex = 0;
            btnBreak.Text = "Break";
            btnBreak.UseVisualStyleBackColor = true;
            btnBreak.Click += btnBreak_Click;
            // 
            // grpRegisters
            // 
            grpRegisters.Controls.Add(txtRegs0);
            grpRegisters.Controls.Add(lblReg0);
            grpRegisters.Location = new Point(623, 14);
            grpRegisters.Margin = new Padding(3, 2, 3, 2);
            grpRegisters.Name = "grpRegisters";
            grpRegisters.Padding = new Padding(3, 2, 3, 2);
            grpRegisters.Size = new Size(164, 328);
            grpRegisters.TabIndex = 1;
            grpRegisters.TabStop = false;
            grpRegisters.Text = "Registers";
            // 
            // txtRegs0
            // 
            txtRegs0.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            txtRegs0.BackColor = SystemColors.Window;
            txtRegs0.Enabled = false;
            txtRegs0.Font = new Font("Segoe UI", 9F, FontStyle.Bold);
            txtRegs0.ForeColor = SystemColors.InfoText;
            txtRegs0.Location = new Point(64, 14);
            txtRegs0.Margin = new Padding(3, 2, 3, 2);
            txtRegs0.Name = "txtRegs0";
            txtRegs0.ReadOnly = true;
            txtRegs0.Size = new Size(95, 23);
            txtRegs0.TabIndex = 1;
            // 
            // lblReg0
            // 
            lblReg0.AutoSize = true;
            lblReg0.Location = new Point(5, 16);
            lblReg0.Name = "lblReg0";
            lblReg0.Size = new Size(16, 15);
            lblReg0.TabIndex = 0;
            lblReg0.Text = "0:";
            // 
            // grpInstruction
            // 
            grpInstruction.Controls.Add(label8);
            grpInstruction.Controls.Add(label9);
            grpInstruction.Controls.Add(lblStatusMask);
            grpInstruction.Controls.Add(lblStatusWord);
            grpInstruction.Controls.Add(lblInterMask);
            grpInstruction.Controls.Add(lblInterrupt);
            grpInstruction.Controls.Add(lblMemArg);
            grpInstruction.Controls.Add(label7);
            grpInstruction.Controls.Add(label6);
            grpInstruction.Controls.Add(label5);
            grpInstruction.Controls.Add(label4);
            grpInstruction.Controls.Add(lblInstSplit);
            grpInstruction.Controls.Add(lblAssemInst);
            grpInstruction.Controls.Add(txtCycles);
            grpInstruction.Controls.Add(txtInstCode);
            grpInstruction.Controls.Add(label3);
            grpInstruction.Controls.Add(label2);
            grpInstruction.Controls.Add(label1);
            grpInstruction.Controls.Add(txtProgCount);
            grpInstruction.Location = new Point(449, 14);
            grpInstruction.Margin = new Padding(3, 2, 3, 2);
            grpInstruction.Name = "grpInstruction";
            grpInstruction.Padding = new Padding(3, 2, 3, 2);
            grpInstruction.Size = new Size(168, 328);
            grpInstruction.TabIndex = 2;
            grpInstruction.TabStop = false;
            grpInstruction.Text = "Instruction";
            // 
            // label8
            // 
            label8.AutoSize = true;
            label8.Location = new Point(6, 249);
            label8.Name = "label8";
            label8.Size = new Size(70, 15);
            label8.TabIndex = 34;
            label8.Text = "Status Mask";
            // 
            // label9
            // 
            label9.AutoSize = true;
            label9.Location = new Point(6, 226);
            label9.Name = "label9";
            label9.Size = new Size(60, 15);
            label9.TabIndex = 33;
            label9.Text = "Status Wd";
            // 
            // lblStatusMask
            // 
            lblStatusMask.BorderStyle = BorderStyle.FixedSingle;
            lblStatusMask.Font = new Font("Courier New", 9F);
            lblStatusMask.Location = new Point(86, 249);
            lblStatusMask.Name = "lblStatusMask";
            lblStatusMask.Size = new Size(71, 18);
            lblStatusMask.TabIndex = 32;
            // 
            // lblStatusWord
            // 
            lblStatusWord.BorderStyle = BorderStyle.FixedSingle;
            lblStatusWord.Font = new Font("Courier New", 9F);
            lblStatusWord.Location = new Point(86, 226);
            lblStatusWord.Name = "lblStatusWord";
            lblStatusWord.Size = new Size(71, 18);
            lblStatusWord.TabIndex = 31;
            // 
            // lblInterMask
            // 
            lblInterMask.BorderStyle = BorderStyle.FixedSingle;
            lblInterMask.Font = new Font("Courier New", 9F);
            lblInterMask.Location = new Point(86, 200);
            lblInterMask.Name = "lblInterMask";
            lblInterMask.Size = new Size(71, 18);
            lblInterMask.TabIndex = 30;
            // 
            // lblInterrupt
            // 
            lblInterrupt.BorderStyle = BorderStyle.FixedSingle;
            lblInterrupt.Font = new Font("Courier New", 9F);
            lblInterrupt.Location = new Point(86, 177);
            lblInterrupt.Name = "lblInterrupt";
            lblInterrupt.Size = new Size(71, 18);
            lblInterrupt.TabIndex = 29;
            // 
            // lblMemArg
            // 
            lblMemArg.BorderStyle = BorderStyle.FixedSingle;
            lblMemArg.Font = new Font("Courier New", 9F);
            lblMemArg.Location = new Point(86, 150);
            lblMemArg.Name = "lblMemArg";
            lblMemArg.Size = new Size(71, 18);
            lblMemArg.TabIndex = 28;
            // 
            // label7
            // 
            label7.AutoSize = true;
            label7.Location = new Point(6, 150);
            label7.Name = "label7";
            label7.Size = new Size(74, 15);
            label7.TabIndex = 27;
            label7.Text = "Memory Arg";
            // 
            // label6
            // 
            label6.AutoSize = true;
            label6.Location = new Point(6, 200);
            label6.Name = "label6";
            label6.Size = new Size(62, 15);
            label6.TabIndex = 26;
            label6.Text = "Inter Mask";
            // 
            // label5
            // 
            label5.AutoSize = true;
            label5.Location = new Point(6, 177);
            label5.Name = "label5";
            label5.Size = new Size(53, 15);
            label5.TabIndex = 25;
            label5.Text = "Interrupt";
            // 
            // label4
            // 
            label4.Font = new Font("Courier New", 9F);
            label4.Location = new Point(6, 86);
            label4.Name = "label4";
            label4.Size = new Size(146, 18);
            label4.TabIndex = 24;
            label4.Text = "OC F M R1 R2 IMM";
            // 
            // lblInstSplit
            // 
            lblInstSplit.BorderStyle = BorderStyle.FixedSingle;
            lblInstSplit.Font = new Font("Courier New", 9F);
            lblInstSplit.Location = new Point(6, 105);
            lblInstSplit.Name = "lblInstSplit";
            lblInstSplit.Size = new Size(146, 18);
            lblInstSplit.TabIndex = 23;
            // 
            // lblAssemInst
            // 
            lblAssemInst.BorderStyle = BorderStyle.FixedSingle;
            lblAssemInst.Font = new Font("Courier New", 9F);
            lblAssemInst.Location = new Point(6, 125);
            lblAssemInst.Name = "lblAssemInst";
            lblAssemInst.Size = new Size(146, 18);
            lblAssemInst.TabIndex = 22;
            // 
            // txtCycles
            // 
            txtCycles.Location = new Point(66, 303);
            txtCycles.Margin = new Padding(3, 2, 3, 2);
            txtCycles.Name = "txtCycles";
            txtCycles.Size = new Size(85, 23);
            txtCycles.TabIndex = 16;
            // 
            // txtInstCode
            // 
            txtInstCode.Location = new Point(9, 61);
            txtInstCode.Margin = new Padding(3, 2, 3, 2);
            txtInstCode.MaxLength = 8;
            txtInstCode.Name = "txtInstCode";
            txtInstCode.Size = new Size(86, 23);
            txtInstCode.TabIndex = 10;
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(5, 305);
            label3.Name = "label3";
            label3.Size = new Size(41, 15);
            label3.TabIndex = 3;
            label3.Text = "Cycles";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(9, 44);
            label2.Name = "label2";
            label2.Size = new Size(95, 15);
            label2.TabIndex = 2;
            label2.Text = "Instruction Code";
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(9, 22);
            label1.Name = "label1";
            label1.Size = new Size(49, 15);
            label1.TabIndex = 1;
            label1.Text = "Address";
            // 
            // txtProgCount
            // 
            txtProgCount.Location = new Point(66, 20);
            txtProgCount.Margin = new Padding(3, 2, 3, 2);
            txtProgCount.Name = "txtProgCount";
            txtProgCount.Size = new Size(78, 23);
            txtProgCount.TabIndex = 0;
            // 
            // btnCancel
            // 
            btnCancel.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;
            btnCancel.Location = new Point(704, 346);
            btnCancel.Margin = new Padding(3, 2, 3, 2);
            btnCancel.Name = "btnCancel";
            btnCancel.Size = new Size(82, 22);
            btnCancel.TabIndex = 3;
            btnCancel.Text = "Close";
            btnCancel.UseVisualStyleBackColor = true;
            btnCancel.Click += btnCancel_Click;
            // 
            // label10
            // 
            label10.AutoSize = true;
            label10.Location = new Point(20, 164);
            label10.Name = "label10";
            label10.Size = new Size(36, 15);
            label10.TabIndex = 4;
            label10.Text = "State:";
            // 
            // txtStatus
            // 
            txtStatus.Location = new Point(66, 161);
            txtStatus.Margin = new Padding(3, 2, 3, 2);
            txtStatus.Name = "txtStatus";
            txtStatus.Size = new Size(66, 23);
            txtStatus.TabIndex = 5;
            // 
            // ckbHex
            // 
            ckbHex.AutoSize = true;
            ckbHex.Checked = true;
            ckbHex.CheckState = CheckState.Checked;
            ckbHex.Location = new Point(26, 132);
            ckbHex.Margin = new Padding(3, 2, 3, 2);
            ckbHex.Name = "ckbHex";
            ckbHex.Size = new Size(46, 19);
            ckbHex.TabIndex = 6;
            ckbHex.Text = "Hex";
            ckbHex.UseVisualStyleBackColor = true;
            ckbHex.CheckedChanged += ckbHex_CheckedChanged;
            // 
            // cboComPorts
            // 
            cboComPorts.FormattingEnabled = true;
            cboComPorts.Location = new Point(37, 44);
            cboComPorts.Margin = new Padding(3, 2, 3, 2);
            cboComPorts.Name = "cboComPorts";
            cboComPorts.Size = new Size(83, 23);
            cboComPorts.TabIndex = 7;
            cboComPorts.DropDown += cboComPorts_DropDown;
            // 
            // label11
            // 
            label11.AutoSize = true;
            label11.Location = new Point(26, 27);
            label11.Name = "label11";
            label11.Size = new Size(65, 15);
            label11.TabIndex = 8;
            label11.Text = "COM Ports";
            // 
            // btnConnect
            // 
            btnConnect.Location = new Point(37, 70);
            btnConnect.Margin = new Padding(3, 2, 3, 2);
            btnConnect.Name = "btnConnect";
            btnConnect.Size = new Size(82, 22);
            btnConnect.TabIndex = 9;
            btnConnect.Text = "Connect";
            btnConnect.UseVisualStyleBackColor = true;
            btnConnect.Click += btnConnect_Click;
            // 
            // btnDisConnect
            // 
            btnDisConnect.Location = new Point(37, 96);
            btnDisConnect.Margin = new Padding(3, 2, 3, 2);
            btnDisConnect.Name = "btnDisConnect";
            btnDisConnect.Size = new Size(82, 22);
            btnDisConnect.TabIndex = 10;
            btnDisConnect.Text = "Disconnect";
            btnDisConnect.UseVisualStyleBackColor = true;
            btnDisConnect.Click += btnDisConnect_Click;
            // 
            // bgwDebugStatus
            // 
            bgwDebugStatus.WorkerReportsProgress = true;
            bgwDebugStatus.WorkerSupportsCancellation = true;
            bgwDebugStatus.DoWork += bgwDebugStatus_DoWork;
            bgwDebugStatus.ProgressChanged += bgwDebugStatus_ProgressChanged;
            // 
            // txtDebugger
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            CancelButton = btnCancel;
            ClientSize = new Size(797, 377);
            Controls.Add(btnDisConnect);
            Controls.Add(btnConnect);
            Controls.Add(label11);
            Controls.Add(cboComPorts);
            Controls.Add(ckbHex);
            Controls.Add(txtStatus);
            Controls.Add(label10);
            Controls.Add(btnCancel);
            Controls.Add(grpInstruction);
            Controls.Add(grpRegisters);
            Controls.Add(grpCommands);
            Margin = new Padding(3, 2, 3, 2);
            Name = "txtDebugger";
            Text = "Debugger";
            Load += txtDebugger_Load;
            grpCommands.ResumeLayout(false);
            grpCommands.PerformLayout();
            grpRegisters.ResumeLayout(false);
            grpRegisters.PerformLayout();
            grpInstruction.ResumeLayout(false);
            grpInstruction.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private GroupBox grpCommands;
        private GroupBox grpRegisters;
        private GroupBox grpInstruction;
        private Button btnCancel;
        private Label label3;
        private Label label2;
        private Label label1;
        private TextBox txtProgCount;
        private TextBox txtInstCode;
        private Button btnContinue;
        private Button btnStep;
        private Button btnBreak;
        private TextBox txtCycles;
        private Label label10;
        private TextBox txtStatus;
        private CheckBox ckbHex;
        private Label lblReg0;
        private TextBox txtRegs0;
        private ComboBox cboComPorts;
        private Label label11;
        private Button btnConnect;
        private Button btnDisConnect;
        private Button btnBreakAt;
        private TextBox txtBreakAt0;
        private Button btnBreakWhen;
        private Label label12;
        private TextBox txtBWhenValue;
        private TextBox txtBWhenReg;
        private System.ComponentModel.BackgroundWorker bgwDebugStatus;
        private Label lblAssemInst;
        private Label lblInstSplit;
        private Label label4;
        private Label label8;
        private Label label9;
        private Label lblStatusMask;
        private Label lblStatusWord;
        private Label lblInterMask;
        private Label lblInterrupt;
        private Label lblMemArg;
        private Label label7;
        private Label label6;
        private Label label5;
        private Label label14;
        private Label label15;
        private ComboBox cbRegOper;
    }
}
