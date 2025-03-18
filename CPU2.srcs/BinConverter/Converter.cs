namespace BinConverter
{
    internal class Converter
    {
        static void Main(string[] args)
        {
            string fileName = args[0];
            if (!File.Exists(fileName))
            {
                Console.WriteLine("File does not exists.");
            }
            else
            {
                byte[] bytes = File.ReadAllBytes(fileName);
                UInt32[] words = new UInt32[bytes.Length / 4];
                for (int i = 0; i < bytes.Length; i++)
                {
                    int pos = (3 - (i % 4)) * 8;
                    UInt32 word = ((UInt32)bytes[i]) << pos;
                    words[i / 4] = words[i / 4] | word;
                }

                string? file = Path.GetFileName(Path.GetDirectoryName(fileName));
                string coeFilename = Path.ChangeExtension(fileName, ".coe");
                string mifFilename = Path.ChangeExtension(fileName, ".mif");
                string wpFilename = Path.ChangeExtension(fileName, ".wp");
                Console.WriteLine("file = {0}", file);
                Console.WriteLine("coeFilename = {0}", coeFilename);
                Console.WriteLine("mifFilename = {0}", mifFilename);
                Console.WriteLine("wpFilename = {0}", wpFilename);
                File.WriteAllText(coeFilename, CoeFormatter.Formatter(words));
                File.WriteAllText(mifFilename, MifFormatter.Formatter(words));
                File.WriteAllText(wpFilename, WishboneFormatter.Formatter(words));
            }
        }
    }

}
