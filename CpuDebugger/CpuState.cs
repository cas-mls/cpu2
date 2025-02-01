using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;

namespace CpuDebugger
{

    enum Statuses { notconnected, stopped, running };

    internal class CpuState
    
    {
        Statuses status;
        Dictionary<byte, string> AccessMap = new Dictionary<byte, string>()
            {   {0, "REGREG" },
                {1, "IMMED" },
                {2, "ABSOLUTE" },
                {3, "INDEX" } };

        public CpuState() 
        {
        }
        internal Statuses ExecutationState { get; set; }
        internal uint ProgramCounter { get; set; }
        internal uint InstructionCode { get; set; }
        internal uint Cycles { get; set; }
        internal Registers CpuRegisters { get; } = new Registers();
        internal byte Opcode 
        {
            get
            {
                uint Op = InstructionCode & 0xf8000000;
                Op >>= 27;
                return (byte)Op;
            }
        }

        internal string OpcodeDecode
        {
            get
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
                        if (Register2 != 0)
                            results = Flag == 0 ? "be" : "bne";
                        else
                            results = Flag == 0 ? "bz" : "bnz";
                        break;
                    case 0x0E:
                        if (Register2 != 0)
                            results = Flag == 0 ? "bl" : "bge";
                        else
                            results = Flag == 0 ? "bn" : "bnn";
                        break;
                    case 0x10:
                        if (Register2 != 0)
                            results = Flag == 0 ? "bg" : "ble";
                        else
                            results = Flag == 0 ? "bp" : "bnp";
                        break;
                    case 0x12:
                        results = Flag == 0 ? "push" : "pop";
                        break;
                    case 0x14:
                        if (Register2 != 0)
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

        internal string MemoryAccessDecode
        {
            get
            {
                return AccessMap[(byte)MemoryAccess];
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
        internal ushort Immediate
        {
            get
            {
                uint OpImm = InstructionCode & 0x0000ffff;
                return (ushort)OpImm;
            }
        }
        internal uint Memory { get; set; }
        
        internal uint MemoryArg { get; set; }

        internal uint Interrupt { get; set; }

        internal uint InterruptMask { get; set; }

        internal uint StatusRegister { get; set; }

        internal uint StatusMask { get; set; }

        internal string AssemblyInstruction
        {
            get
            {
                string results = "";
                switch (MemoryAccessDecode)
                {
                    case "REGREG":
                        results = OpcodeDecode + " R" + Register1.ToString() + ", R" + Register2.ToString();
                        break;
                    case "IMMED":
                        results = OpcodeDecode + " R" + Register1.ToString() + ", #" + Immediate.ToString();
                        break;
                    case "ABSOLUTE":
                        results = OpcodeDecode + " R" + Register1.ToString() + ", [" + Immediate.ToString() + "]";
                        break;
                    case "INDEX":
                        results = OpcodeDecode + " R" + Register1.ToString()  + ", [" + Immediate.ToString() + "+R" + Register2.ToString() + "]";
                        break;
                }
                return results;
            }
        }

        internal string InstructionSplit
        {
            get
            {
                return Opcode.ToString("x2") + " " 
                    + Flag.ToString("x1") + " " 
                    + MemoryAccess.ToString("x1") + " "
                    + Register1.ToString("x2") + " "
                    + Register2.ToString("x2")+ " "
                    + Immediate.ToString("x4");
            }
        }

    }
}
