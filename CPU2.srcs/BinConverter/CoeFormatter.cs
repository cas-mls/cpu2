using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BinConverter
{
    internal class CoeFormatter
    {
        static internal string Formatter(UInt32[] words)
        {
            StringBuilder results = new StringBuilder();
            results.AppendLine("memory_initialization_radix=16;\nmemory_initialization_vector=\n");
            for (int i = 0; i < words.Length; i++)
            {
                results.AppendFormat("{0:X8} ", words[i]);
                if ((i + 1) % 8 == 0) { results.AppendLine(); }
            }
            results.AppendLine(";");

            return results.ToString();
        }
    }

}
