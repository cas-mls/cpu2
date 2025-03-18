using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO.Ports;


namespace CpuDebugger
{
    internal class SerialWishbone
    {
        internal static uint read(SerialPort WbPort, byte cmd, ushort addr)
        {
            byte[] outbuf = new byte[5];
            byte[] inbuf = new byte[3];

            inbuf[0] = (byte)((int)(cmd) * 2); // first bit is read/write 0 = read
            WbPort.Write(inbuf, 0, 1);
            BitConverter.GetBytes(addr).CopyTo(inbuf, 1);
            WbPort.Write(inbuf, 1, 2);

            WbPort.Read(outbuf, 0, 1);
            WbPort.Read(outbuf, 1, 1);
            WbPort.Read(outbuf, 2, 1);
            WbPort.Read(outbuf, 3, 1);
            WbPort.Read(outbuf, 4, 1);
            ReturnCode = outbuf[0];
            //outbuf = taskRead.Result;

            return BitConverter.ToUInt32(outbuf, 1);
            //return BitConverter.ToUInt32(outbuf, 1);
        }

        internal static void write(SerialPort WbPort, byte cmd, ushort addr, uint data)
        {
            byte[] inbuf = new byte[7];
            byte[] outbuf = new byte[5];
            inbuf[0] = (byte)((int)(cmd) * 2 + 1); // first bit is read/write 1 = Write
            BitConverter
                .GetBytes(addr)
                .CopyTo(inbuf, 1);
            BitConverter
                .GetBytes(data)
                .CopyTo(inbuf, 3);
            WbPort.Write(inbuf, 0, 7);
            WbPort.Read(outbuf, 0, 1); // echo command.
            ReturnCode = outbuf[0];
        }

        internal static byte ReturnCode { get; private set; }

        internal static SerialPort Open(string portName)
        {
            SerialPort WbPort = new() { 
                PortName = portName, 
                BaudRate = 115200, 
                DataBits = 8, 
                StopBits = StopBits.One, 
                Parity = Parity.None, 
                Handshake = Handshake.None,
                ReadTimeout = 2000 };
            WbPort.ErrorReceived += Port_ErrorReceived;
            WbPort.Open();
            return WbPort;
        }

        internal static void Close(SerialPort WbPort)
        {
            WbPort.Close();
        }

        internal static string[] GetPorts()
        {
            return SerialPort.GetPortNames();
        }
        private static void Port_ErrorReceived(object sender, SerialErrorReceivedEventArgs e)
        {
            Console.WriteLine("Error = " + e.EventType.ToString());
        }

    }
}
