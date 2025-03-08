using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BinConverter
{
    internal class MifFormatter
    {
        internal static string Formatter(UInt32[] words)
        {
            StringBuilder results = new StringBuilder();

            for (int i = 0; i < words.Length; i++)
            {
                results.AppendLine(words[i].ToBinary());
            }
            return results.ToString();
        }
    }
    public static class BinaryExt
    {
        public static string ToBinary(this UInt32 number, int bitsLength = 32)
        {
            return NumberToBinary(number, bitsLength);
        }

        public static string ToBinary(this int number, int bitsLength = 32)
        {
            return NumberToBinary(number, bitsLength);
        }
        public static string NumberToBinary(UInt32 number, int bitsLength = 32)
        {
            string result = Convert.ToString(number, 2).PadLeft(bitsLength, '0');

            return result;
        }

        public static string NumberToBinary(int number, int bitsLength = 32)
        {
            string result = Convert.ToString(number, 2).PadLeft(bitsLength, '0');

            return result;
        }

        public static int FromBinaryToInt(this string binary)
        {
            return BinaryToInt(binary);
        }

        public static int BinaryToInt(string binary)
        {
            return Convert.ToInt32(binary, 2);
        }
    }
}
