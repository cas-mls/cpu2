using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CpuDebugger
{
    internal class Memory
    {

        public Memory() 
        {
            Index = 0;
            Address = 0;
            Data = 0;
        }
        public Memory(int i)
        {
            Index = i;
            Address = 0;
            Data = 0;
        }
        public Memory(int i, ushort addr)
        {
            Index = i;
            Address = addr;
            Data = 0;
        }
        public Memory(int i, ushort addr, uint data)
        {
            Index = i;
            Address = addr;
            Data = data;
        }


        internal int Index { get; set; }
        internal ushort Address { get; set;  }
        internal uint Data { get; set; }

    }
}
