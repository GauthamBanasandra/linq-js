<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Demo.aspx.cs" Inherits="Demo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>LINQ Js Demo</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="~/Content/bootstrap.css" rel="stylesheet" />
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
                <div class="col-lg-8">
                    <div class="form-group">
                        <label for="input_code">Code:</label>
                        <textarea class="form-control" rows="15" id="input_code" runat="server"></textarea>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="row">
                        <br />
                        <br />
                        <br />
                        <br />
                        <div class="col-lg-6 col-lg-offset-6">
                            <asp:Button Text="Run" runat="server" ID="button_run" class="btn btn-primary btn-lg" OnClick="Button_Run_Click" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12 text-center">
                    <label for="output_code">Transpiled code and output:</label>
                    <textarea class="form-control" rows="15" id="output_code" runat="server"></textarea>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
