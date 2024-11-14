using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CpuDebugger
{
    internal class BreakData
    {

        internal struct BreakWhenStruct {
            internal bool Valid;
            internal byte Register;
            internal uint Value;
            //internal bool onChange;
        };
        internal struct BreakAtStruct
        {
            internal bool Valid;
            internal uint Location;
        };
        public BreakData() { }

        internal BreakAtStruct[] BreakAt { get; set; } = new BreakAtStruct[4];

        internal BreakWhenStruct BreakWhen { get; set; }

    }
}
