using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace CpuDebugger
{

    enum Statuses { notconnected, stopped, running };

    internal class CpuState
    
    {

        Dictionary<int, Memory> memory = new Dictionary<int, Memory>();

        Dictionary<CmdStatusAddr, uint> debugValues = new Dictionary<CmdStatusAddr, uint>();

        Dictionary<int, uint> regVaues = new Dictionary<int, uint>();

        Statuses status;

        Dictionary<byte, string> AccessMap = new Dictionary<byte, string>()
            {   {0, "REGREG" },
                {1, "IMMED" },
                {2, "ABSOLUTE" },
                {3, "INDEX" } };

        public CpuState(bool initValues)
        {
            if (initValues)
            {
                foreach (CmdStatusAddr addr in Enum.GetValues(typeof(CmdStatusAddr)))
                    debugValues[addr] = 0;
                for (int regNum = 0; regNum < 16; regNum++)
                    regVaues[regNum] = 0;
            }
        }

        public CpuState(CpuState cpuState)
        {
            foreach (CmdStatusAddr addr in cpuState.getAllStatuses())
                debugValues[addr] = cpuState.getValue(addr);
            foreach (int regNum in cpuState.getAllRegNum())
                regVaues[regNum] = cpuState.getRegisterValue(regNum);
            foreach (Memory mem in cpuState.GetAllMemory())
                memory[mem.Index] = mem;
         }

        internal void copy (CpuState cpuState)
        {
            foreach (CmdStatusAddr addr in cpuState.getAllStatuses())
                debugValues[addr] = cpuState.getValue(addr);
            foreach (int regNum in cpuState.getAllRegNum())
                regVaues[regNum] = cpuState.getRegisterValue(regNum);
            foreach (Memory mem in cpuState.GetAllMemory())
                memory[mem.Index] = mem;
        }

        internal void AddStatus(CmdStatusAddr status, uint value)
        {
            debugValues[status] = value;
        }

        internal void RemoveStatus(CmdStatusAddr status)
        {
            debugValues.Remove(status);
        }

        internal uint getValue(CmdStatusAddr status)
        {
            return debugValues[status];
        }
        internal void setValue(CmdStatusAddr status, uint value)
        {
            debugValues[status] = value;
        }

        internal CmdStatusAddr[] getAllStatuses()
        {
            return debugValues.Keys.ToArray();
        }

        internal Statuses ExecutationState 
        { 
            get { return (Statuses)debugValues[CmdStatusAddr.Status]; } 
        }

        internal int[] Changes(CpuState cpuState)
        {
            List<int> changes = new List<int>();
            foreach (int regNum in getAllRegNum())
            {
                if (getRegisterValue(regNum) != cpuState.getRegisterValue(regNum))
                    changes.Add(regNum);
            }
            return changes.ToArray();
        }

        internal byte Opcode 
        {
            get
            {
                uint Op = debugValues[CmdStatusAddr.Instruction] & 0xf8000000;
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
                        results = "mul";
                        break;
                    case 0x07:
                        results = "div";
                        break;
                    case 0x09:
                        results = Flag == 0 ? "and" : "nand";
                        break;
                    case 0x0b:
                        results = Flag == 0 ? "aor" : "nor";
                        break;
                    case 0x0d:
                        results = Flag == 0 ? "xor" : "xnor";
                        break;
                    case 0x0f:
                        results = Flag == 0 ? "sll" : "srl";
                        break;
                    default:
                        results = "empty";
                        break;
                }
                return results;
            }
        }

        internal bool ValidRegZero
        {
            get
            {
                if (Register2 == 0)
                    if (Opcode == 0x0C
                        | Opcode == 0x0E
                        | Opcode == 0x10
                        | Opcode == 0x14)
                        return false;
                    else if (MemoryAccessDecode == "IMMED")
                        if (Opcode == 0x01
                            | Opcode == 0x03
                            | Opcode == 0x05
                            | Opcode == 0x07)
                            return false;
                        else
                            return true;
                    else
                        return true;
                else
                    return true;
            }
        }
        internal byte Flag
        {
            get
            {
                uint OpFlag = debugValues[CmdStatusAddr.Instruction] & 0x04000000;
                OpFlag >>= 26;
                return (byte)OpFlag;
            }
        }
        internal byte MemoryAccess
        {
            get
            {
                uint OpAccess = debugValues[CmdStatusAddr.Instruction] & 0x03000000;
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
                uint OpReg1 = debugValues[CmdStatusAddr.Instruction] & 0x00f00000;
                OpReg1 >>= 20;
                return (byte)OpReg1;
            }
        }
        internal byte Register2
        {
            get
            {
                uint OpReg2 = debugValues[CmdStatusAddr.Instruction] & 0x000f0000;
                OpReg2 >>= 16;
                return (byte)OpReg2;
            }
        }
        internal ushort Immediate
        {
            get
            {
                uint OpImm = debugValues[CmdStatusAddr.Instruction] & 0x0000ffff;
                return (ushort)OpImm;
            }
        }

        internal void AddRegister(int regNum, uint value)
        {
            regVaues[regNum] = value;
        }

        internal void RemoveRegister(int regNum)
        {
            regVaues.Remove(regNum);
        }

        internal uint getRegisterValue(int regNum)
        {
            return regVaues[regNum];
        }

        internal void setRegisterValue(int regNum, uint value)
        {
            regVaues[regNum] = value;
        }

        internal int[] getAllRegNum()
        {
            return regVaues.Keys.ToArray();
        }
        internal void AddMemory ( int index, ushort Address)
        {
            memory[index] = new Memory(index, Address);
        }
        internal void AddMemory(int index, ushort Address, uint Data)
        {
            memory[index] = new Memory(index, Address, Data);
        }
        internal void RemoveMemory (int index)
        {
            memory.Remove(index);
        }

        internal Memory[] GetAllMemory()
        {
            return memory.Values.ToArray();
        }

        internal string AssemblyInstruction(bool hex)
        {
            string results = "";
            string ImmString = string.Format(hex ? "0x{0,4:x4}" : "{0}", Immediate);
            switch (MemoryAccessDecode)
            {
                case "REGREG":
                    results = OpcodeDecode + " R" + Register1.ToString() + ", R" + Register2.ToString();
                    break;
                case "IMMED":
                    results = OpcodeDecode 
                        + " R" + Register1.ToString() 
                        + (ValidRegZero ? ", R" + Register2.ToString() : "")
                        + ", #" + ImmString;
                    break;
                case "ABSOLUTE":
                    results = OpcodeDecode 
                        + " R" + Register1.ToString()
                        + (ValidRegZero ? ", R" + Register2.ToString() : "")
                        + ", [" + ImmString + "]";
                    break;
                case "INDEX":
                    results = OpcodeDecode + " R" + Register1.ToString()  + ", [" + ImmString + "+R" + Register2.ToString() + "]";
                    break;
            }
            return results;
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
