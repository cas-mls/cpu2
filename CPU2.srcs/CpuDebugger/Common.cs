using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common
{
    internal enum CmdStatusAddr
    {
        Status = 0,
        ProgCounter,
        Instruction,
        Cycles,
        Interrupt,
        InterruptMask,
        SwStatus,
        StatusMask,
        MemoryArg
    };

    internal enum DebugCmd
    {
        Status = 0,
        Step = 1,
        Continue = 2,
        Break = 3,
        BreakAt = 4,
        BreakWhen = 5,
        Reset = 6,
        RWRegisters = 8,
        RWMemory = 16
    }

    enum Statuses { 
        notconnected, 
        stopped, 
        running };


    class Common
    {
    }
}
