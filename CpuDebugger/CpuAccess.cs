using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading.Tasks;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace CpuDebugger
{
    internal enum CmdStatusAddr { 
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

    internal enum DebugCmd { 
            Status          = 0,
            Step            = 1,
            Continue        = 2,
            Break           = 3,
            BreakAt         = 4,
            BreakWhen       = 5,
            Reset           = 6,
            RWRegisters     = 8,
            RWMemory        = 16 }



    internal class CpuAccess
    {
        SerialPort port;
        CpuState cpuState;
        CpuState cpuStateUpdate;
        BreakData breakData;
        bool StatusIsRunning;

        public CpuAccess(CpuState state, CpuState stateUpdate, BreakData breakD) 
        {
            breakData = breakD;
            cpuState = state;
            cpuStateUpdate = stateUpdate;
            port = new SerialPort();
            StatusIsRunning = false ;
        }


        internal void Open(string PortName)
        {
            if (!port.IsOpen) port = SerialWishbone.Open(PortName);
        }

        internal void Close()
        {
            SerialWishbone.Close(port);
        }

        internal bool IsConnected
        {
            get { return port.IsOpen; }
        }

        internal void GetCpuCurrentState()
        {
            if (IsConnected 
                && cpuState.ExecutationState == Statuses.stopped)
            {
                foreach (CmdStatusAddr addr in Enum.GetValues(typeof(CmdStatusAddr)))
                {
                    cpuState.setValue(addr, SerialWishbone.read(
                        port,
                        (byte)DebugCmd.Status,
                        (ushort)addr));
                }

                GetRegisters();
                GetMemory();
            }
        }
        internal void GetRegisters()
        {
            if (IsConnected
                && cpuState.ExecutationState == Statuses.stopped)
            {
                for (int i = 0; i < 16; i++)
                {
                    cpuState.setRegisterValue(i, (uint)SerialWishbone.read(
                        port,
                        (byte)DebugCmd.RWRegisters,
                        (ushort)i));
                }
            }
        }

        internal void UpdateRegisters()
        {
            if (IsConnected
                && cpuState.ExecutationState == Statuses.stopped)
            {
                foreach (int regNum in cpuStateUpdate.getAllRegNum())
                {
                    SerialWishbone.write(
                        port,
                        (byte)DebugCmd.RWRegisters,
                        (ushort)regNum,
                        (uint)cpuStateUpdate.getRegisterValue(regNum));
                }
            }
        }

        internal void UpdateStatuses()
        {
            if (IsConnected
                && cpuState.ExecutationState == Statuses.stopped)
            {
                foreach (CmdStatusAddr regNum in cpuStateUpdate.getAllStatuses())
                {
                    SerialWishbone.write(
                        port,
                        (byte)DebugCmd.Status,
                        (ushort)regNum,
                        (uint)cpuStateUpdate.getValue(regNum));
                }
            }
        }

        internal void GetMemory()
        {
            if (IsConnected
                && cpuState.ExecutationState == Statuses.stopped)
            {
                foreach ( Memory mem in cpuState.GetAllMemory() )
                {
                    mem.Data = (uint)SerialWishbone.read(
                        port,
                        (byte)DebugCmd.RWMemory,
                        (ushort)mem.Address);
                }
            }
        }
        internal void UpdateMemory()
        {
            if (IsConnected
                && cpuState.ExecutationState == Statuses.stopped)
            {
                foreach (Memory mem in cpuStateUpdate.GetAllMemory())
                {
                    SerialWishbone.write(
                        port,
                        (byte)DebugCmd.RWMemory,
                        (ushort)mem.Address,
                        (uint)mem.Data);
                }
            }
        }

        internal void GetExecutionState()
        {
            if (IsConnected)
            {
                cpuState.setValue(CmdStatusAddr.Status,
                    SerialWishbone.read(
                        port,
                        (byte)DebugCmd.Status,
                        (ushort)CmdStatusAddr.Status) == (uint)0 ? (uint)2 : (uint)1 );
            }
        }
        internal string[] GetPorts()
        {
            return SerialWishbone.GetPorts();
        }
        internal void PerformStep()
        {
            if (IsConnected
                && cpuState.ExecutationState == Statuses.stopped)
            {
                SerialWishbone.write(
                    port,
                    (byte)DebugCmd.Step,
                    (ushort)0,
                    (uint)0);
            }
        }
        internal void PerformBreak()
        {
            if (IsConnected
                && cpuState.ExecutationState == Statuses.running)
            {
                SerialWishbone.write(
                    port,
                    (byte)DebugCmd.Break,
                    (ushort)0,
                    (uint)0);
            }
        }
        internal void PerformContinue()
        {
            if (IsConnected
                && cpuState.ExecutationState == Statuses.stopped)
            {
                SerialWishbone.write(
                    port,
                    (byte)DebugCmd.Continue,
                    (ushort)0,
                    (uint)0);
            }
        }

        internal void BreakAt()
        {
            if (IsConnected
                && cpuState.ExecutationState == Statuses.stopped)
            {
                for (int i = 0; i < breakData.BreakAt.Length; i++)
                {
                    if (breakData.BreakAt[i].Valid)
                    {
                        SerialWishbone.write(
                            port,
                            (byte)DebugCmd.BreakAt,
                            (ushort)i,
                            (uint)breakData.BreakAt[i].Location);
                    }
                    else
                    {
                        SerialWishbone.write(
                            port,
                            (byte)DebugCmd.BreakAt,
                            (ushort)i,
                            (uint)0);
                    }
                }
            }
        }

        internal void BreakWhen()
        {
            if (IsConnected
                && cpuState.ExecutationState == Statuses.stopped)
            {
                SerialWishbone.write(
                    port,
                    (byte)DebugCmd.BreakWhen,
                    (ushort)((ushort)breakData.BreakWhen.Operation << 5 | (ushort)breakData.BreakWhen.Register),
                    (uint)breakData.BreakWhen.Value);
            }
        }
        internal void Reset()
        {
            if (IsConnected
                && cpuState.ExecutationState == Statuses.stopped)
            {
                SerialWishbone.write(
                    port,
                    (byte)DebugCmd.Reset,
                    (ushort)0,
                    (uint)0);
            }
        }
    }
}
