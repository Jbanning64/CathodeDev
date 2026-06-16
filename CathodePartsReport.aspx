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

        <asp:Button ID="btnRun" runat="server" Text="Run Report" OnClick="btnRun_Click" CssClass="noprint" />

         &nbsp;&nbsp;

        <!-- NEW quick filter buttons -->
        <asp:Button ID="btnThisMonth" runat="server" Text="This Month" OnClick="btnThisMonth_Click" CssClass="noprint" />
        <asp:Button ID="btnLastMonth" runat="server" Text="Last Month" OnClick="btnLastMonth_Click" CssClass="noprint" />

        &nbsp;&nbsp;

        <!-- NEW Print button -->
        <asp:Button ID="btnPrint" runat="server" Text="Print" OnClientClick="window.print(); return false;" CssClass="noprint" OnClick="btnPrint_Click" />


    </div>

    <asp:GridView ID="gvParts" runat="server" AutoGenerateColumns="false" CssClass="table">
        <Columns>
            <asp:BoundField DataField="CathodeParts" HeaderText="Cathode Parts" />
            <asp:BoundField DataField="PartTotals" HeaderText="Total" />
        </Columns>
    </asp:GridView>

    <style>
        @media print {
            .noprint {
                display:none;
            }
        }
    </style>


</asp:Content>