<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Demo.aspx.cs" Inherits="Demo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>LINQ Js Demo</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link href="Content/Demo.css" rel="stylesheet" />
    <script src="Scripts/jquery-3.2.1.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script src="Scripts/ace/ace.js"></script>
    <script>
window.onload = function(){
var input_code_editor = ace.edit("input_code");
input_code_editor.setTheme("ace/theme/monokai");
input_code_editor.getSession().setMode("ace/mode/javascript");
input_code_editor.getSession().setUseWorker(false);

var transpiled_code_editor = ace.edit("transpiled_code");
transpiled_code_editor.setTheme("ace/theme/monokai");
transpiled_code_editor.getSession().setMode("ace/mode/javascript");
}
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="row text-center">
                <h1>LINQ Js Demo</h1>
                <br />
                <br />
                <br />
                <br />
            </div>
            <div class="row">
                <div class="col-sm-4 col-sm-offset-1">
                    <div class="form-group">
                        <label for="input_code">Code:</label>
                        <div id="input_code" runat="server"></div>
                    </div>
                </div>
                <div class="col-sm-2 text-center">
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <asp:Button Text="Transpile" runat="server" ID="button_transpile" class="btn btn-primary btn-lg" OnClick="Button_Transpile_Click" />
                </div>
                <div class="col-sm-5">
                    <label for="transpiled_code">Transpiled code:</label>
                    <div id="transpiled_code" runat="server"></div>                    
                    <br />
                    <div class="text-center">
                        <asp:Button Text="Run" ID="button_run" class="btn btn-success btn-lg" OnClick="Button_Run_Click" runat="server" />
                    </div>
                    <br />
                    <div class="well well-lg output">
                        <p class="lead">Output:</p>
                        <p runat="server" id="js_output"></p>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
