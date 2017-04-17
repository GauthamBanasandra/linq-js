using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Web.UI.HtmlControls;

public partial class Demo : System.Web.UI.Page
{
    private const string transpilerExecPath = @"C:\Users\Gautham\Projects\Github\linq-js\website\Bin\src";
    private const string webInputPath = transpilerExecPath + @"\web_inputs\web_input.txt";
    private const string webTranspiledCodePath = transpilerExecPath + @"\web_inputs\web_transpiled_code.txt";
    private const string examplesPath = @"C:\Users\Gautham\Projects\Github\linq-js\website\Bin\inputs";

    protected void Page_Load(object sender, EventArgs e)
    {
        Directory.SetCurrentDirectory(transpilerExecPath);

        if (IsPostBack)
        {
            input_code.InnerText = File.ReadAllText(webInputPath);
        }
        else
        {
            string exampleFileName = Request.QueryString["filename"];

            if (exampleFileName != null)
            {
                string exampleInput = File.ReadAllText(examplesPath + @"\" + exampleFileName);
                input_code.InnerText = exampleInput;
            }
        }        
    }

    protected void Button_Transpile_Click(object sender, EventArgs e)
    {
        Debug.WriteLine("Input code:" + ta_input_code.InnerText);

        if (ta_input_code.InnerText.Length > 0)
        {
            File.WriteAllText(webInputPath, ta_input_code.InnerText);

            string transpiledCode = RunTranspiler();
            transpiled_code.InnerText = transpiledCode;
        }
    }

    private string RunTranspiler()
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
        if (transpiled_code.InnerText.Length > 0)
        {
            File.WriteAllText(webTranspiledCodePath, transpiled_code.InnerText);

            string jsOutput = ExecJs();
            js_output.InnerText = jsOutput;
        }
    }

    private string ExecJs()
    {
        ProcessStartInfo nodeProcessInfo = new ProcessStartInfo()
        {
            CreateNoWindow = false,
            UseShellExecute = false,
            FileName = "node",
            Arguments = webTranspiledCodePath,
            WindowStyle = ProcessWindowStyle.Hidden,
            RedirectStandardOutput = true,
            RedirectStandardInput = true
        };

        string execJsOuput = string.Empty;

        try
        {
            Process nodeProcess = Process.Start(nodeProcessInfo);
            execJsOuput = nodeProcess.StandardOutput.ReadToEnd();
            nodeProcess.WaitForExit();
            nodeProcess.Close();
        }
        catch (Exception e)
        {
            Debug.WriteLine("Error:\t" + e.Message);
        }

        return execJsOuput;
    }
}