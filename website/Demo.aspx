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
        window.onload = function () {
            var input_code_editor = ace.edit("input_code");
            input_code_editor.setTheme("ace/theme/monokai");
            input_code_editor.getSession().setMode("ace/mode/javascript");
            input_code_editor.getSession().setUseWorker(false);

            var transpiled_code_editor = ace.edit("transpiled_code");
            transpiled_code_editor.setTheme("ace/theme/monokai");
            transpiled_code_editor.getSession().setMode("ace/mode/javascript");

            document.getElementById("button_transpile").addEventListener('click', function () {
                document.getElementById('ta_input_code').innerHTML = input_code_editor.getValue();
            });
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="row text-center">
                <h1>LINQ Js Demo</h1>
            </div>
            <div class="row">                
                <div class="col-sm-12 navbar_">
                    <ul class="nav nav-pills nav-justified">
                        <li><a href="Default.aspx">
                            <h3>Home</h3>
                        </a></li>
                        <li class="dropdown btn-lg">
                            <a class="dropdown-toggle btn-lg" data-toggle="dropdown">
                                <h3>Select</h3>
                                <span class="caret"></span></a>
                            <ul class="dropdown-menu btn-lg">
                                <li><a href="Demo.aspx?filename=input.txt">
                                    <h4>Trivial</h4>
                                </a></li>
                                <li><a href="Demo.aspx?filename=input_recursive.txt">
                                    <h4>Recursive</h4>
                                </a></li>
                                <li><a href="Demo.aspx?filename=input_select_multiple.txt">
                                    <h4>Select Multiple</h4>
                                </a></li>
                            </ul>
                        </li>
                        <li class="dropdown btn-lg">
                            <a class="dropdown-toggle btn-lg" data-toggle="dropdown">
                                <h3>Group By</h3>
                                <span class="caret"></span></a>
                            <ul class="dropdown-menu btn-lg">
                                <li><a href="Demo.aspx?filename=input_groupby.txt">
                                    <h4>Trivial</h4>
                                </a></li>
                                <li><a href="Demo.aspx?filename=input_groupby_recursive.txt">
                                    <h4>Recursive</h4>
                                </a></li>
                            </ul>
                        </li>
                        <li class="dropdown btn-lg">
                            <a class="dropdown-toggle btn-lg" data-toggle="dropdown">
                                <h3>Order By</h3>
                                <span class="caret"></span></a>
                            <ul class="dropdown-menu btn-lg">
                                <li><a href="Demo.aspx?filename=input_orderby.txt">
                                    <h4>Trivial</h4>
                                </a></li>
                                <li><a href="Demo.aspx?filename=input_orderby_recursive.txt">
                                    <h4>Recursive</h4>
                                </a></li>
                            </ul>
                        </li>
                        <li><a href="Demo.aspx?filename=input_join.txt">
                            <h3>Join</h3>
                        </a></li>
                    </ul>
                </div>                
            </div>
            <br />
            <br />
            <div id="input" class="row">
                <div class="col-sm-4 col-sm-offset-1">
                    <div class="form-group">
                        <label for="input_code">Code:</label>
                        <div id="input_code" runat="server"></div>
                        <textarea style="display:none" id="ta_input_code" runat="server"></textarea>
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
