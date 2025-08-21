<%@ Page Language="C#"  MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddCathode.aspx.cs" Inherits="CathodeWeb.AddCathode" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
        <section class="row" aria-labelledby="pageTitle">
            <h1 id="pageTitle">Add Cathode Page</h1>
        </section>

       <table style="width: 80%">
            <tr>
                <td style="width: 102px">
                <asp:Label ID="Label1" runat="server" Text="Serial Number" Width="150px"></asp:Label>
                </td>
                <td></td>
                <td>
                <asp:TextBox ID="txtSerial" runat="server" Width="300px" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="width: 102px">
                </td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td style="width: 102px">
                <asp:Label ID="Label3" runat="server" Text="Furnace"></asp:Label>
                </td>
                <td></td>
                <td>
                <asp:TextBox ID="txtFurnace" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="width: 102px; padding:20px">
                </td>
                <td></td>
            </tr>
            <tr>
                 <td style="width: 102px">
                 <asp:Label ID="Label2" runat="server" Text="Badge Number"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:TextBox ID="txtBadge" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>
                 </td>
             </tr>
            <tr><td>
   
    </table>
    &nbsp;&nbsp;
    <br />
    <br />
    <asp:Button ID="btnAddCathode" runat="server" Text="Add Cathode" 
        onclick="btnAddCathode_Click" />
    <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="False"></asp:Label>
    <br />
    <br />

    </main>

</asp:Content>