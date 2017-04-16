using System;
using System.Diagnostics;
using System.IO;

public partial class Demo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void Button_Transpile_Click(object sender, EventArgs e)
    {
        const string transpilerExecPath = @"C:\Users\Gautham\Projects\Github\linq-js\website\Bin\src";
        Directory.SetCurrentDirectory(transpilerExecPath);

        string webInputPath = Directory.GetCurrentDirectory() + @"\web_inputs\web_input.txt";
        string webInput = input_code.InnerText;
        File.WriteAllText(webInputPath, webInput);

        string transpiledCode = RunTranspiler(webInputPath);
        output_code.InnerText = transpiledCode;
    }

    private string RunTranspiler(string webInputPath)
    {
        ProcessStartInfo transpilerProcessInfo = new ProcessStartInfo()
        {
            CreateNoWindow = false,
            UseShellExecute = false,
            FileName = "a.exe",
            Arguments = webInputPath,
            WindowStyle = ProcessWindowStyle.Hidden,
            RedirectStandardOutput = true,
            RedirectStandardInput = true
        };

        string transpilerOutput = string.Empty;

        try
        {
            Process transpilerProcess = Process.Start(transpilerProcessInfo);
            transpilerOutput = transpilerProcess.StandardOutput.ReadToEnd();
            transpilerProcess.WaitForExit();
            transpilerProcess.Close();
        }
        catch (Exception e)
        {
            Debug.WriteLine("Error:\t" + e.Message);
        }

        return transpilerOutput;
    }

    protected void Button_Run_Click(object sender, EventArgs e)
    {

    }
}