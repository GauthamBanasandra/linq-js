using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Diagnostics;
using System.IO;

namespace transpiler_test
{
    [TestClass]
    public class TranspilerTests
    {
        private const string transpilerExecPath = @"C:\Users\Gautham\Projects\Github\linq-js\website\Bin\src";
        private const string testDataPath = @"C:\Users\Gautham\Projects\Github\linq-js\tests\transpiler_test\test_data";
        private string format_temp_file = Directory.GetCurrentDirectory() + @"\format_temp.txt";        

        private string FormatJs(string js_code)
        {
            File.WriteAllText(format_temp_file, js_code);
            string formatted_code = RunProcess(@"C:\Users\Gautham\AppData\Roaming\npm\js-beautify.cmd", format_temp_file);

            return formatted_code;
        }

        private string RunProcess(string process, string input_file_path)
        {
            ProcessStartInfo process_info = new ProcessStartInfo()
            {
                CreateNoWindow = false,
                UseShellExecute = false,
                FileName = process,
                Arguments = input_file_path,
                WindowStyle = ProcessWindowStyle.Hidden,
                RedirectStandardOutput = true,
                RedirectStandardInput = true
            };

            string process_output = string.Empty;

            try
            {
                Process transpilerProcess = Process.Start(process_info);
                process_output = transpilerProcess.StandardOutput.ReadToEnd();
                transpilerProcess.WaitForExit();
                transpilerProcess.Close();
            }
            catch (Exception e)
            {
                Debug.WriteLine("Error:\t" + e.Message);
            }

            return process_output;
        }

        [TestMethod]
        public void TrivialSelect()
        {
            Directory.SetCurrentDirectory(transpilerExecPath);
            string input_path = testDataPath + @"\inputs\input.txt";
            string expected_output_path = testDataPath + @"\expected_output\expected_input.txt";

            string output = RunProcess("a.exe", input_path);
            string expected_output = File.ReadAllText(expected_output_path);

            Assert.AreEqual(FormatJs(output), FormatJs(expected_output));
        }

        [TestMethod]
        public void RecursiveSelect()
        {
            Directory.SetCurrentDirectory(transpilerExecPath);
            string input_path = testDataPath + @"\inputs\input_recursive.txt";
            string expected_output_path = testDataPath + @"\expected_output\expected_recursive.txt";

            string output = RunProcess("a.exe", input_path);
            string expected_output = File.ReadAllText(expected_output_path);

            Assert.AreEqual(FormatJs(output), FormatJs(expected_output));
        }

        [TestMethod]
        public void MultipleSelect()
        {
            Directory.SetCurrentDirectory(transpilerExecPath);
            string input_path = testDataPath + @"\inputs\input_select_multiple.txt";
            string expected_output_path = testDataPath + @"\expected_output\expected_select_multiple.txt";

            string output = RunProcess("a.exe", input_path);
            string expected_output = File.ReadAllText(expected_output_path);

            Assert.AreEqual(FormatJs(output), FormatJs(expected_output));
        }

        [TestMethod]
        public void TrivialGroupby()
        {
            Directory.SetCurrentDirectory(transpilerExecPath);
            string input_path = testDataPath + @"\inputs\input_groupby.txt";
            string expected_output_path = testDataPath + @"\expected_output\expected_groupby.txt";

            string output = RunProcess("a.exe", input_path);
            string expected_output = File.ReadAllText(expected_output_path);

            Assert.AreEqual(FormatJs(output), FormatJs(expected_output));
        }

        [TestMethod]
        public void RecursiveGroupby()
        {
            Directory.SetCurrentDirectory(transpilerExecPath);
            string input_path = testDataPath + @"\inputs\input_groupby_recursive.txt";
            string expected_output_path = testDataPath + @"\expected_output\expected_groupby_recursive.txt";

            string output = RunProcess("a.exe", input_path);
            string expected_output = File.ReadAllText(expected_output_path);

            Assert.AreEqual(FormatJs(output), FormatJs(expected_output));
        }

        [TestMethod]
        public void TrivialJoin()
        {
            Directory.SetCurrentDirectory(transpilerExecPath);
            string input_path = testDataPath + @"\inputs\input_join.txt";
            string expected_output_path = testDataPath + @"\expected_output\expected_join.txt";

            string output = RunProcess("a.exe", input_path);
            string expected_output = File.ReadAllText(expected_output_path);

            Assert.AreEqual(FormatJs(output), FormatJs(expected_output));
        }

        [TestMethod]
        public void TrivialOrderby()
        {
            Directory.SetCurrentDirectory(transpilerExecPath);
            string input_path = testDataPath + @"\inputs\input_orderby.txt";
            string expected_output_path = testDataPath + @"\expected_output\expected_orderby.txt";

            string output = RunProcess("a.exe", input_path);
            string expected_output = File.ReadAllText(expected_output_path);

            Assert.AreEqual(FormatJs(output), FormatJs(expected_output));
        }

        [TestMethod]
        public void RecursiveOrderby()
        {
            Directory.SetCurrentDirectory(transpilerExecPath);
            string input_path = testDataPath + @"\inputs\input_orderby_recursive.txt";
            string expected_output_path = testDataPath + @"\expected_output\expected_orderby_recursive.txt";

            string output = RunProcess("a.exe", input_path);
            string expected_output = File.ReadAllText(expected_output_path);

            Assert.AreEqual(FormatJs(output), FormatJs(expected_output));
        }
    }
}
