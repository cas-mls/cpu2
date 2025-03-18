using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading.Tasks;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;
using Common;
using System.Diagnostics.Eventing.Reader;
using BinConverter;
using static System.Net.Mime.MediaTypeNames;
using System.Text.RegularExpressions;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace CpuDebugger
{

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

        internal void Upload(string fileName)
        {
            string[] lines = [];
            StringBuilder log = new StringBuilder();

            if (Path.GetExtension(fileName) == ".bin")
            {
                byte[] bytes = File.ReadAllBytes(fileName);
                UInt32[] words = new UInt32[bytes.Length / 4];
                for (int i = 0; i < bytes.Length; i++)
                {
                    int pos = (3 - (i % 4)) * 8;
                    UInt32 word = ((UInt32)bytes[i]) << pos;
                    words[i / 4] = words[i / 4] | word;
                }
                lines = Regex.Split(WishboneFormatter.Formatter(words), "\r\n|\r|\n");
            }
            else if (Path.GetExtension(fileName) == ".wp")
            {
                lines = File.ReadAllLines(fileName);
            }

            foreach (string line in lines)
            {
                string[] parts = line.Split(',');
                if (parts.Length == 4)
                {
                    if (Enum.TryParse(parts[0], out DebugCmd cmd))
                    {
                        if (parts[1] == "1")
                        {
                            SerialWishbone.write(
                                port,
                                (byte)cmd,
                                Convert.ToUInt16(parts[2], 16),
                                Convert.ToUInt32(parts[3], 16));
                            log.AppendFormat("{0},{1},{2:X4},{3:X8},{4:X2}",
                                parts[0], 1, parts[2], parts[3], SerialWishbone.ReturnCode);
                            log.AppendLine();
                        }
                        else
                        {
                            uint Data = SerialWishbone.read(
                                port,
                                (byte)cmd,
                                Convert.ToUInt16(parts[2], 16));
                            log.AppendFormat("{0},{1},{2:X4},{3:X8},{4:X2}",
                                parts[0], 0, parts[2], Data, SerialWishbone.ReturnCode);
                            log.AppendLine();
                        }
                    }
                }
            }
            File.WriteAllText(Path.ChangeExtension(fileName, ".log"), log.ToString());
        }
    }
}
