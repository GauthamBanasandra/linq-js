using System;
using System.Collections.Generic;
using System.Collections.Specialized;
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

        Response.Clear();
        string action = Request.QueryString["action"];
        switch (action)
        {
            case "get_file":
                string exampleFileName = Request.QueryString["filename"];
                string exampleInput = File.ReadAllText(examplesPath + @"\" + exampleFileName);
                Response.Write(exampleInput);
                break;
            case "transpile":
                string transpiler_input = Request.Form["transpilerInput"];
                if (transpiler_input.Length > 0)
                {
                    File.WriteAllText(webInputPath, transpiler_input);

                    string transpiledCode = RunTranspiler();
                    Response.Write(transpiledCode);
                }
                break;
            case "run":
                string js_input = Request.Form["jsInput"];
                if (js_input.Length > 0)
                {
                    File.WriteAllText(webTranspiledCodePath, js_input);

                    string jsOutput = ExecJs();
                    Response.Write(jsOutput);
                }
                break;
            default:
                break;
        }
        Response.End();
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