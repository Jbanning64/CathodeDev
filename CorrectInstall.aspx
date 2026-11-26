<%@ Page Title="Correct Cathode Install" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CorrectInstall.aspx.cs" Inherits="CathodeDev.CorrectInstall" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>
    <p>Use this page only to remove a cathode that was installed in the wrong gun or with the wrong cathode number.
       After the uninstall, repeat the normal install process with the correct cathode.</p>

    <table>
        <tr>
            <td style="padding:4px 12px 4px 0;"><asp:Label ID="lblFurnace" runat="server" AssociatedControlID="ddlFurnace" Text="Select EB Furnace:" /></td>
            <td>
                <asp:DropDownList ID="ddlFurnace" runat="server" AutoPostBack="true"
                    AppendDataBoundItems="true" OnSelectedIndexChanged="ddlFurnace_SelectedIndexChanged">
                    <asp:ListItem Text="-- Select --" Value="" />
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td style="padding:4px 12px 4px 0;"><asp:Label ID="lblGun" runat="server" AssociatedControlID="ddlGun" Text="Select Gun:" /></td>
            <td>
                <asp:DropDownList ID="ddlGun" runat="server" AppendDataBoundItems="true">
                    <asp:ListItem Text="-- Select --" Value="" />
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td style="padding:4px 12px 4px 0;"><asp:Label ID="lblBadge" runat="server" AssociatedControlID="txtBadge" Text="Your Employee ID:" /></td>
            <td><asp:TextBox ID="txtBadge" runat="server" MaxLength="10" /></td>
        </tr>
        <tr>
            <td></td>
            <td style="padding-top:8px;">
                <asp:Button ID="btnUninstall" runat="server" Text="Uninstall Current Cathode" OnClick="btnUninstall_Click" />
            </td>
        </tr>
    </table>

    <p><asp:Label ID="lblMessage" runat="server" EnableViewState="false" /></p>
</asp:Content>

