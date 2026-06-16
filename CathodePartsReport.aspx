<%@ Page Title="Cathode Parts Report" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CathodePartsReport.aspx.cs" Inherits="CathodeWeb.CathodePartsReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Cathode Parts Summary</h2>

    <div style="margin-bottom:20px;">
        <asp:Label runat="server" Text="Start Date:" AssociatedControlID="txtStart"></asp:Label>
        <asp:TextBox ID="txtStart" runat="server" TextMode="Date"></asp:TextBox>

        &nbsp;&nbsp;

        <asp:Label runat="server" Text="End Date:" AssociatedControlID="txtEnd"></asp:Label>
        <asp:TextBox ID="txtEnd" runat="server" TextMode="Date"></asp:TextBox>

        &nbsp;&nbsp;

        <asp:Button ID="btnRun" runat="server" Text="Run Report" OnClick="btnRun_Click" />
    </div>

    <asp:GridView ID="gvParts" runat="server" AutoGenerateColumns="false" CssClass="table">
        <Columns>
            <asp:BoundField DataField="CathodeParts" HeaderText="Cathode Parts" />
            <asp:BoundField DataField="PartTotals" HeaderText="Total" />
        </Columns>
    </asp:GridView>

</asp:Content>