using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common;

namespace BinConverter
{

    internal class WishboneFormatter
    {
        internal static string Formatter(UInt32[] words)
        {
            StringBuilder results = new StringBuilder();
            int writeEnable = 1;
            // Break
            results.AppendFormat("{0},{1},{2:X4},{3:X8}", DebugCmd.Break, writeEnable, 0, 0);
            results.AppendLine();
            // Program
            for (int i = 0; i < words.Length; i++)
            {
                results.AppendFormat("{0},{1},{2:X4},{3:X8}",DebugCmd.RWMemory, writeEnable, i, words[i]);
                results.AppendLine();
            }
            // Reset
            results.AppendFormat("{0},{1},{2:X4},{3:X8}", DebugCmd.Reset, writeEnable, 0, 0);
            return results.ToString();
        }
    }
}
