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
    enum DebugCmdAddr { DebugMode = 0, DebugBreak = 1, DebugStep = 2, DebugContinue = 3 }

    internal class CpuAccess
    {
        SerialPort port;
        CpuState cpuState;

        public CpuAccess(CpuState state) 
        {
            cpuState = state;
            port = new SerialPort();
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
            GetExecutionState();
            if (IsConnected && cpuState.ExecutationState == Statuses.stopped)
            {
                cpuState.ProgramCounter = SerialWishbone.read(
                    port,
                    (byte)Cmd.Commands,
                    (ushort)CmdStatusAddr.ProgCounter);
                cpuState.InstructionCode = SerialWishbone.read(
                    port,
                    (byte)Cmd.Commands,
                    (ushort)CmdStatusAddr.Instruction);
                cpuState.Cycles = SerialWishbone.read(
                    port,
                    (byte)Cmd.Commands,
                    (ushort)CmdStatusAddr.Cycles);
                GetRegisters();
            }
        }
        internal void GetRegisters()
        {
            for (int i = 0; i < 16; i++)
            {
                cpuState.CpuRegisters[i] = (uint)SerialWishbone.read(
                    port,
                    (byte)Cmd.Registers,
                    (ushort)i);
            }
        }
        internal void GetExecutionState()
        {
            if (IsConnected)
            {
                cpuState.ExecutationState = 
                    SerialWishbone.read(port, (byte)Cmd.Commands, (ushort)CmdStatusAddr.Status) 
                        == 0 ? Statuses.running : Statuses.stopped;
            }
        }
        internal string[] GetPorts()
        {
            return SerialWishbone.GetPorts();
        }
        internal void PerformStep()
        {
            SerialWishbone.write(port, (byte)Cmd.Commands, (ushort)DebugCmdAddr.DebugStep, (uint)0);
        }
        internal void PerformBreak()
        {
            SerialWishbone.write(port, (byte)Cmd.Commands, (ushort)DebugCmdAddr.DebugBreak, (uint)0);
        }
        internal void PerformContinue()
        {
            SerialWishbone.write(port, (byte)Cmd.Commands, (ushort)DebugCmdAddr.DebugContinue, (uint)0);
        }

    }
}
