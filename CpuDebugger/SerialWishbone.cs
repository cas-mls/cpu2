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

        //def __init__(self, port= "COM4", baudrate= 115200):
        //    self.uart = serial.Serial(port, baudrate, timeout=2)
        //    print("The UART on " + self.uart.name + " is open.")
        //    print("The wishbone bus is ready.\n")

        //def read(self, addr):
        //    cmd = 0x0
        //    cmd = cmd.to_bytes(1,byteorder)
        //    self.uart.write(cmd)
        //    addr = addr.to_bytes(2, byteorder)
        //    self.uart.write(addr)
        //    rbytes = self.uart.read(1)
        //    rbytes=self.uart.read(4)
        //    drd=int.from_bytes(rbytes, byteorder)
        //    return drd
        internal static uint read(SerialPort WbPort, byte cmd, ushort addr)
        {
            byte[] outbuf = new byte[5];
            byte[] inbuf = new byte[3];

            //Task<byte[]> taskRead = Task<byte[]>.Factory.StartNew(() =>
            //{
            //    byte[] outbuf = new byte[5];
            //    WbPort.Read(outbuf, 0, 5);

            //    return outbuf;
            //});

            inbuf[0] = (byte)((int)(cmd) * 2); // first bit is read/write 0 = read
            WbPort.Write(inbuf, 0, 1);
            BitConverter.GetBytes(addr).CopyTo(inbuf, 1);
            WbPort.Write(inbuf, 1, 2);

            WbPort.Read(outbuf, 0, 1);
            WbPort.Read(outbuf, 1, 1);
            WbPort.Read(outbuf, 2, 1);
            WbPort.Read(outbuf, 3, 1);
            WbPort.Read(outbuf, 4, 1);
            //outbuf = taskRead.Result;

            return BitConverter.ToUInt32(outbuf, 1);
            //return BitConverter.ToUInt32(outbuf, 1);
        }

        //def write(self, addr, data) :
        //    cmd = 0x1
        //    cmd = cmd.to_bytes(1,byteorder)
        //    self.uart.write(cmd)
        //    addr = addr.to_bytes(2, byteorder)
        //    self.uart.write(addr)
        //    data = data.to_bytes(4, byteorder)
        //    self.uart.write(data)
        //    rbytes = self.uart.read(1)
        //    rr = int.from_bytes(rbytes, byteorder)
        //    # print("0x%02X" % rr)
        internal static void write(SerialPort WbPort, byte cmd, ushort addr, uint data)
        {
            byte[] inbuf = new byte[7];
            byte[] outbuf = new byte[5];
            inbuf[0] = (byte)((int)(cmd) * 2 + 1); // first bit is read/write 1 = Write
            //Array.Copy(BitConverter.GetBytes(addr).Reverse().ToArray(), 0, inbuf, 1, 2);
            //Array.Copy(BitConverter.GetBytes(data).Reverse().ToArray(), 0, inbuf, 3, 4);
            BitConverter
                .GetBytes(addr)
                .CopyTo(inbuf, 1);
            BitConverter
                .GetBytes(data)
                .CopyTo(inbuf, 3);
            WbPort.Write(inbuf, 0, 7);
            WbPort.Read(outbuf, 0, 1); // echo command.
        }

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
            // TestPort.BaudRate = 115200;
            // TestPort.DataBits = 8;
            // TestPort.StopBits = StopBits.One;
            // TestPort.Parity = Parity.None;
            // TestPort.Handshake = Handshake.None;
            // Echo True
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
