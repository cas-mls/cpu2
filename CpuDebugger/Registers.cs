using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CpuDebugger
{
    internal class Registers
    {
        uint[] regs = new uint[16];
        uint[] priorRegs = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        bool[] registerChanges = new bool[16];

        public Registers() { }
        internal uint this[int i]
        {
            get
            {
                return regs[i];
            }
            set
            {
                if (regs[i] != value)
                {
                    priorRegs[i] = regs[i];
                    regs[i] = value;
                    registerChanges[i] = true;
                }
                else
                {
                    registerChanges[i] = false;
                }
            }
        }

        internal bool RegisterChanged(int i)
        {
            return registerChanges[i];
        }


    }
}
