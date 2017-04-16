<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Demo.aspx.cs" Inherits="Demo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>LINQ Js Demo</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="~/Content/bootstrap.css" rel="stylesheet" />
    <link href="~/Content/Demo.css" rel="stylesheet" />
    <script src="~/Scripts/jquery-1.10.2.min.js"></script>
    <script src="~/Scripts/bootstrap.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="row text-center">
                <h1>LINQ Js Demo</h1>
                <br />
                <br />
                <br />
                <br />
            </div>
            <div class="row">
                <div class="col-sm-5">
                    <div class="form-group">
                        <label for="input_code">Code:</label>
                        <textarea class="form-control" rows="15" id="input_code" runat="server"></textarea>
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
                    <label for="output_code">Transpiled code:</label>
                    <textarea class="form-control" rows="15" id="output_code" runat="server"></textarea>
                    <br />
                    <div class="text-center">
                        <asp:Button Text="Run" ID="button_run" class="btn btn-success btn-lg" OnClick="Button_Run_Click" runat="server" />
                    </div>
                    <br />                    
                    <div class="well well-lg">
                        <p class="lead">Output:</p>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
