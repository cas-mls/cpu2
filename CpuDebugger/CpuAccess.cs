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
    enum CmdStatusAddr { 
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

    enum DebugCmd { 
            Status          = 0,
            Step            = 1,
            Continue        = 2,
            Break           = 3,
            BreakAt         = 4,
            BreakWhen       = 5,
            RWRegisters     = 8,
            RWMemory        = 16 }



    internal class CpuAccess
    {
        SerialPort port;
        CpuState cpuState;
        BreakData breakData;
        bool StatusIsRunning;

        public CpuAccess(CpuState state, BreakData breakD) 
        {
            breakData = breakD;
            cpuState = state;
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
                cpuState.ProgramCounter = SerialWishbone.read(
                    port,
                    (byte)DebugCmd.Status,
                    (ushort)CmdStatusAddr.ProgCounter);
                cpuState.InstructionCode = SerialWishbone.read(
                    port,
                    (byte)DebugCmd.Status,
                    (ushort)CmdStatusAddr.Instruction);
                cpuState.Cycles = SerialWishbone.read(
                    port,
                    (byte)DebugCmd.Status,
                    (ushort)CmdStatusAddr.Cycles);
                cpuState.MemoryArg = SerialWishbone.read(
                    port,
                    (byte)DebugCmd.Status,
                    (ushort)CmdStatusAddr.MemoryArg);
                cpuState.Interrupt = SerialWishbone.read(
                    port,
                    (byte)DebugCmd.Status,
                    (ushort)CmdStatusAddr.Interrupt);
                cpuState.InterruptMask = SerialWishbone.read(
                    port,
                    (byte)DebugCmd.Status,
                    (ushort)CmdStatusAddr.InterruptMask);
                cpuState.StatusRegister = SerialWishbone.read(
                    port,
                    (byte)DebugCmd.Status,
                    (ushort)CmdStatusAddr.SwStatus);
                cpuState.StatusMask = SerialWishbone.read(
                    port,
                    (byte)DebugCmd.Status,
                    (ushort)CmdStatusAddr.StatusMask);
                GetRegisters();
            }
        }
        internal void GetRegisters()
        {
            if (IsConnected
                && cpuState.ExecutationState == Statuses.stopped)
            {
                for (int i = 0; i < 16; i++)
                {
                    cpuState.CpuRegisters[i] = (uint)SerialWishbone.read(
                        port,
                        (byte)DebugCmd.RWRegisters,
                        (ushort)i);
                }
            }
        }

        internal void GetMemory(ushort address)
        {
            if (IsConnected
                && cpuState.ExecutationState == Statuses.stopped)
            {
                cpuState.Memory = (uint)SerialWishbone.read(
                    port,
                    (byte)DebugCmd.RWRegisters,
                    (ushort)address);
            }
        }

        internal void GetExecutionState()
        {
            if (IsConnected)
            {
                cpuState.ExecutationState = 
                    SerialWishbone.read(
                        port, 
                        (byte)DebugCmd.Status, 
                        (ushort)CmdStatusAddr.Status) 
                        == 0 ? Statuses.running : Statuses.stopped;
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
    }
}
