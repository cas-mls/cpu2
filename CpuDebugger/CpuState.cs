using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;

namespace CpuDebugger
{

    enum Statuses { notconnected, stopped, running };
    enum CmdStatusAddr { Status = 0, ProgCounter, Instruction, Cycles };
    enum Cmd { Commands = 0, Registers, Memory };

    internal class CpuState
    
    {
        Statuses status;
        uint[] priorRegs = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

        public CpuState() { }
        internal Statuses ExecutationState { get; set; }
        internal uint ProgramCounter { get; set; }
        internal uint InstructionCode { get; set; }
        internal uint Cycles { get; set; }
        internal uint[] Registers { get; set; }
        internal bool[] RegisterChanges { get; set; }
        internal byte Opcode 
        {
            get
            {
                uint Op = InstructionCode & 0xf8000000;
                Op >>= 27;
                return (byte)Op;
            }
        }
        internal byte Flag
        {
            get
            {
                uint OpFlag = InstructionCode & 0x04000000;
                OpFlag >>= 26;
                return (byte)OpFlag;
            }
        }
        internal byte MemoryAccess
        {
            get
            {
                uint OpAccess = InstructionCode & 0x03000000;
                OpAccess >>= 24;
                return (byte)OpAccess;
            }
        }
        internal byte Register1
        {
            get
            {
                uint OpReg1 = InstructionCode & 0x00f00000;
                OpReg1 >>= 20;
                return (byte)OpReg1;
            }
        }
        internal byte Register2
        {
            get
            {
                uint OpReg2 = InstructionCode & 0x000f0000;
                OpReg2 >>= 16;
                return (byte)OpReg2;
            }
        }
        internal byte Immediate
        {
            get
            {
                uint OpImm = InstructionCode & 0x0000ffff;
                return (byte)OpImm;
            }
        }
    }
}
