namespace CpuDebugger
{
    partial class Debugger
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
            btnContinue = new Button();
            btnStep = new Button();
            btnBreak = new Button();
            grpRegisters = new GroupBox();
            txtRegs0 = new TextBox();
            lblReg0 = new Label();
            grpInstruction = new GroupBox();
            txtCycles = new TextBox();
            txtImmed = new TextBox();
            txtReg2 = new TextBox();
            txtReg1 = new TextBox();
            txtFlag = new TextBox();
            txtOpcode = new TextBox();
            txtInstCode = new TextBox();
            label9 = new Label();
            label8 = new Label();
            label7 = new Label();
            label6 = new Label();
            label5 = new Label();
            label4 = new Label();
            label3 = new Label();
            label2 = new Label();
            label1 = new Label();
            txtAddress = new TextBox();
            btnCancel = new Button();
            label10 = new Label();
            textBox8 = new TextBox();
            ckbHex = new CheckBox();
            cboComPorts = new ComboBox();
            label11 = new Label();
            btnConnect = new Button();
            grpCommands.SuspendLayout();
            grpRegisters.SuspendLayout();
            grpInstruction.SuspendLayout();
            SuspendLayout();
            // 
            // grpCommands
            // 
            grpCommands.Controls.Add(btnContinue);
            grpCommands.Controls.Add(btnStep);
            grpCommands.Controls.Add(btnBreak);
            grpCommands.Location = new Point(8, 268);
            grpCommands.Name = "grpCommands";
            grpCommands.Size = new Size(153, 164);
            grpCommands.TabIndex = 0;
            grpCommands.TabStop = false;
            grpCommands.Text = "Commands";
            // 
            // btnContinue
            // 
            btnContinue.Location = new Point(22, 99);
            btnContinue.Name = "btnContinue";
            btnContinue.Size = new Size(94, 29);
            btnContinue.TabIndex = 2;
            btnContinue.Text = "Continue";
            btnContinue.UseVisualStyleBackColor = true;
            // 
            // btnStep
            // 
            btnStep.Location = new Point(22, 64);
            btnStep.Name = "btnStep";
            btnStep.Size = new Size(94, 29);
            btnStep.TabIndex = 1;
            btnStep.Text = "Step";
            btnStep.UseVisualStyleBackColor = true;
            // 
            // btnBreak
            // 
            btnBreak.Location = new Point(22, 29);
            btnBreak.Name = "btnBreak";
            btnBreak.Size = new Size(94, 29);
            btnBreak.TabIndex = 0;
            btnBreak.Text = "Break";
            btnBreak.UseVisualStyleBackColor = true;
            // 
            // grpRegisters
            // 
            grpRegisters.Controls.Add(txtRegs0);
            grpRegisters.Controls.Add(lblReg0);
            grpRegisters.Location = new Point(378, 19);
            grpRegisters.Name = "grpRegisters";
            grpRegisters.Size = new Size(187, 427);
            grpRegisters.TabIndex = 1;
            grpRegisters.TabStop = false;
            grpRegisters.Text = "Registers";
            // 
            // txtRegs0
            // 
            txtRegs0.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            txtRegs0.Location = new Point(73, 19);
            txtRegs0.Name = "txtRegs0";
            txtRegs0.Size = new Size(108, 27);
            txtRegs0.TabIndex = 1;
            // 
            // lblReg0
            // 
            lblReg0.AutoSize = true;
            lblReg0.Location = new Point(6, 22);
            lblReg0.Name = "lblReg0";
            lblReg0.Size = new Size(56, 20);
            lblReg0.TabIndex = 0;
            lblReg0.Text = "Reg #0";
            // 
            // grpInstruction
            // 
            grpInstruction.Controls.Add(txtCycles);
            grpInstruction.Controls.Add(txtImmed);
            grpInstruction.Controls.Add(txtReg2);
            grpInstruction.Controls.Add(txtReg1);
            grpInstruction.Controls.Add(txtFlag);
            grpInstruction.Controls.Add(txtOpcode);
            grpInstruction.Controls.Add(txtInstCode);
            grpInstruction.Controls.Add(label9);
            grpInstruction.Controls.Add(label8);
            grpInstruction.Controls.Add(label7);
            grpInstruction.Controls.Add(label6);
            grpInstruction.Controls.Add(label5);
            grpInstruction.Controls.Add(label4);
            grpInstruction.Controls.Add(label3);
            grpInstruction.Controls.Add(label2);
            grpInstruction.Controls.Add(label1);
            grpInstruction.Controls.Add(txtAddress);
            grpInstruction.Location = new Point(176, 19);
            grpInstruction.Name = "grpInstruction";
            grpInstruction.Size = new Size(179, 413);
            grpInstruction.TabIndex = 2;
            grpInstruction.TabStop = false;
            grpInstruction.Text = "Instruction";
            // 
            // txtCycles
            // 
            txtCycles.Location = new Point(72, 294);
            txtCycles.Name = "txtCycles";
            txtCycles.Size = new Size(101, 27);
            txtCycles.TabIndex = 16;
            txtCycles.Text = "12345678912";
            // 
            // txtImmed
            // 
            txtImmed.Location = new Point(103, 259);
            txtImmed.Name = "txtImmed";
            txtImmed.Size = new Size(56, 27);
            txtImmed.TabIndex = 15;
            txtImmed.Text = "12356";
            // 
            // txtReg2
            // 
            txtReg2.Location = new Point(122, 226);
            txtReg2.Name = "txtReg2";
            txtReg2.Size = new Size(30, 27);
            txtReg2.TabIndex = 14;
            txtReg2.Text = "16";
            // 
            // txtReg1
            // 
            txtReg1.Location = new Point(122, 192);
            txtReg1.Name = "txtReg1";
            txtReg1.Size = new Size(30, 27);
            txtReg1.TabIndex = 13;
            txtReg1.Text = "16";
            // 
            // txtFlag
            // 
            txtFlag.Location = new Point(103, 143);
            txtFlag.MaxLength = 5;
            txtFlag.Name = "txtFlag";
            txtFlag.Size = new Size(49, 27);
            txtFlag.TabIndex = 12;
            txtFlag.Text = "False";
            // 
            // txtOpcode
            // 
            txtOpcode.Location = new Point(102, 112);
            txtOpcode.MaxLength = 5;
            txtOpcode.Name = "txtOpcode";
            txtOpcode.Size = new Size(37, 27);
            txtOpcode.TabIndex = 11;
            txtOpcode.Text = "wait";
            // 
            // txtInstCode
            // 
            txtInstCode.Location = new Point(37, 79);
            txtInstCode.MaxLength = 8;
            txtInstCode.Name = "txtInstCode";
            txtInstCode.Size = new Size(81, 27);
            txtInstCode.TabIndex = 10;
            txtInstCode.Text = "88ABCDEF";
            // 
            // label9
            // 
            label9.AutoSize = true;
            label9.Location = new Point(37, 257);
            label9.Name = "label9";
            label9.Size = new Size(81, 20);
            label9.TabIndex = 9;
            label9.Text = "Immediate";
            // 
            // label8
            // 
            label8.AutoSize = true;
            label8.Location = new Point(37, 226);
            label8.Name = "label8";
            label8.Size = new Size(75, 20);
            label8.TabIndex = 8;
            label8.Text = "Register 2";
            // 
            // label7
            // 
            label7.AutoSize = true;
            label7.Location = new Point(37, 195);
            label7.Name = "label7";
            label7.Size = new Size(75, 20);
            label7.TabIndex = 7;
            label7.Text = "Register 1";
            // 
            // label6
            // 
            label6.AutoSize = true;
            label6.Location = new Point(25, 175);
            label6.Name = "label6";
            label6.Size = new Size(53, 20);
            label6.TabIndex = 6;
            label6.Text = "Access";
            // 
            // label5
            // 
            label5.AutoSize = true;
            label5.Location = new Point(37, 144);
            label5.Name = "label5";
            label5.Size = new Size(37, 20);
            label5.TabIndex = 5;
            label5.Text = "Flag";
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new Point(28, 119);
            label4.Name = "label4";
            label4.Size = new Size(68, 20);
            label4.TabIndex = 4;
            label4.Text = "Op Code";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(16, 297);
            label3.Name = "label3";
            label3.Size = new Size(50, 20);
            label3.TabIndex = 3;
            label3.Text = "Cycles";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(18, 56);
            label2.Name = "label2";
            label2.Size = new Size(117, 20);
            label2.TabIndex = 2;
            label2.Text = "Instruction Code";
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(16, 29);
            label1.Name = "label1";
            label1.Size = new Size(62, 20);
            label1.TabIndex = 1;
            label1.Text = "Address";
            // 
            // txtAddress
            // 
            txtAddress.Location = new Point(84, 26);
            txtAddress.Name = "txtAddress";
            txtAddress.Size = new Size(89, 27);
            txtAddress.TabIndex = 0;
            txtAddress.Text = "12345678";
            // 
            // btnCancel
            // 
            btnCancel.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;
            btnCancel.Location = new Point(805, 486);
            btnCancel.Name = "btnCancel";
            btnCancel.Size = new Size(94, 29);
            btnCancel.TabIndex = 3;
            btnCancel.Text = "Close";
            btnCancel.UseVisualStyleBackColor = true;
            // 
            // label10
            // 
            label10.AutoSize = true;
            label10.Location = new Point(23, 218);
            label10.Name = "label10";
            label10.Size = new Size(46, 20);
            label10.TabIndex = 4;
            label10.Text = "State:";
            // 
            // textBox8
            // 
            textBox8.Location = new Point(75, 215);
            textBox8.Name = "textBox8";
            textBox8.Size = new Size(75, 27);
            textBox8.TabIndex = 5;
            textBox8.Text = "Running";
            // 
            // ckbHex
            // 
            ckbHex.AutoSize = true;
            ckbHex.Location = new Point(23, 422);
            ckbHex.Name = "ckbHex";
            ckbHex.Size = new Size(57, 24);
            ckbHex.TabIndex = 6;
            ckbHex.Text = "Hex";
            ckbHex.UseVisualStyleBackColor = true;
            // 
            // cboComPorts
            // 
            cboComPorts.FormattingEnabled = true;
            cboComPorts.Location = new Point(30, 59);
            cboComPorts.Name = "cboComPorts";
            cboComPorts.Size = new Size(131, 28);
            cboComPorts.TabIndex = 7;
            cboComPorts.DropDown += cboComPorts_DropDown;
            // 
            // label11
            // 
            label11.AutoSize = true;
            label11.Location = new Point(30, 36);
            label11.Name = "label11";
            label11.Size = new Size(78, 20);
            label11.TabIndex = 8;
            label11.Text = "COM Ports";
            // 
            // btnConnect
            // 
            btnConnect.Location = new Point(42, 93);
            btnConnect.Name = "btnConnect";
            btnConnect.Size = new Size(94, 29);
            btnConnect.TabIndex = 9;
            btnConnect.Text = "Connect";
            btnConnect.UseVisualStyleBackColor = true;
            btnConnect.Click += btnConnect_Click;
            // 
            // Debugger
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            CancelButton = btnCancel;
            ClientSize = new Size(911, 527);
            Controls.Add(btnConnect);
            Controls.Add(label11);
            Controls.Add(cboComPorts);
            Controls.Add(ckbHex);
            Controls.Add(textBox8);
            Controls.Add(label10);
            Controls.Add(btnCancel);
            Controls.Add(grpInstruction);
            Controls.Add(grpRegisters);
            Controls.Add(grpCommands);
            Name = "Debugger";
            Text = "Form1";
            grpCommands.ResumeLayout(false);
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
        private TextBox txtAddress;
        private Label label8;
        private Label label7;
        private Label label6;
        private Label label5;
        private Label label4;
        private Label label9;
        private TextBox txtFlag;
        private TextBox txtOpcode;
        private TextBox txtInstCode;
        private TextBox txtReg2;
        private TextBox txtReg1;
        private TextBox txtImmed;
        private Button btnContinue;
        private Button btnStep;
        private Button btnBreak;
        private TextBox txtCycles;
        private Label label10;
        private TextBox textBox8;
        private CheckBox ckbHex;
        private Label lblReg0;
        private TextBox txtRegs0;
        private ComboBox cboComPorts;
        private Label label11;
        private Button btnConnect;
    }
}
