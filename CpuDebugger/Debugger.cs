using System.Reflection;
using System.IO.Ports;


namespace CpuDebugger
{
    public partial class Debugger : Form
    {
        TextBox[] RegsData = new TextBox[16];
        Label[] RegsLabel = new Label[16];
        public Debugger()
        {
            InitializeComponent();
            RegsData[0] = txtRegs0;
            RegsData[0].Enabled = false;
            RegsLabel[0] = lblReg0;
            for (int i = 1; i < RegsData.Length; i++)
            {
                RegsLabel[i] = RegsLabel[0].Clone();
                RegsLabel[i].Text = "Reg#" + i.ToString();
                RegsLabel[i].Location = new Point(RegsLabel[0].Location.X, RegsLabel[0].Location.Y + 25 * i);
                RegsLabel[i].Visible = true;
                RegsData[i] = RegsData[0].Clone();
                RegsData[i].Location = new Point(RegsData[0].Location.X, RegsData[0].Location.Y + 25 * i);
                RegsData[i].Visible = true;
            }
            RegsData[0].Visible = true;
            RegsLabel[0].Visible = true;
            this.Refresh();

        }

        private void cboComPorts_DropDown(object sender, EventArgs e)
        {
            ComboBox comPorts = sender as ComboBox;
            comPorts.Items.Clear();
            comPorts.Items.AddRange(SerialWishbone.GetPorts());
        }

        private void btnConnect_Click(object sender, EventArgs e)
        {
            SerialPort port = SerialWishbone.Open(cboComPorts.Text);
            uint status = SerialWishbone.read(port, 0, 0);
            SerialWishbone.Close(port);
        }
    }

    public static class ControlExtensions
    {
        public static T Clone<T>(this T controlToClone)
            where T : Control
        {
            PropertyInfo[] controlProperties = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);

            T instance = Activator.CreateInstance<T>();

            foreach (PropertyInfo propInfo in controlProperties)
            {
                if (propInfo.CanWrite)
                {
                    if (propInfo.Name != "WindowTarget")
                        propInfo.SetValue(instance, propInfo.GetValue(controlToClone, null), null);
                }
            }

            return instance;
        }
    }

}
