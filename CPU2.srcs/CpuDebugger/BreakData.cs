using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CpuDebugger
{
    internal enum RegOperators
    {
        REG_NOTHING = 0,        // NOOP
        REG_EQUAL = 1,        // ==
        REG_LESS = 2,        // <
        REG_GREATER = 3,        // >
        REG_CHANGE = 4,        // Change
        REG_NOT_EQUAL = 5,        // !=
        REG_GREATER_EQUAL = 6,      // >=
        REG_LESS_EQUAL = 7         // <=
    };

    internal class BreakData
    {
        static internal Dictionary<string, RegOperators> Operators = new Dictionary<string, RegOperators>()
        {
            {"NOOP", RegOperators.REG_NOTHING },
            {"==", RegOperators.REG_EQUAL },
            {"<", RegOperators.REG_LESS },
            {">", RegOperators.REG_GREATER },
            {"Change", RegOperators.REG_CHANGE },
            {"!=", RegOperators.REG_NOT_EQUAL },
            {">=", RegOperators.REG_GREATER_EQUAL },
            {"<=", RegOperators.REG_LESS_EQUAL }
        };

        internal struct BreakWhenStruct {
            internal RegOperators Operation;
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

        internal static string[] Operations { get; } = Operators.Keys.ToArray();

        internal BreakAtStruct[] BreakAt { get; set; } = new BreakAtStruct[4];

        internal BreakWhenStruct BreakWhen { get; set; }



    }
}
