<%@ Page Language="C#"  MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddCathode.aspx.cs" Inherits="CathodeWeb.AddCathode" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
        <section class="row" aria-labelledby="pageTitle">
            <h1 id="pageTitle"><asp:Literal ID="litTitle" runat="server" Text="Add Cathode Page" /></h1>
        </section>

        <p>
            <asp:CheckBox ID="chkRetire" runat="server" Text="&nbsp;Retire a cathode instead"
                AutoPostBack="true" OnCheckedChanged="chkRetire_CheckedChanged" />
        </p>

        <%-- Add Cathode controls (default view) --%>
        <asp:Panel ID="pnlAdd" runat="server">
            <table style="width: 80%">
                <tr>
                    <td style="width: 150px; padding: 4px 0;">
                        <asp:Label ID="Label1" runat="server" Text="Serial Number" Width="150px"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtSerial" runat="server" Width="300px" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px; padding: 4px 0;">
                        <asp:Label ID="Label3" runat="server" Text="Furnace"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtFurnace" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
            </table>
        </asp:Panel>

        <%-- Retire Cathode controls --%>
        <asp:Panel ID="pnlRetire" runat="server" Visible="false">
            <p>Only cathodes that are not currently installed in a gun are listed.</p>
            <table style="width: 80%">
                <tr>
                    <td style="width: 150px; padding: 4px 0;">
                        <asp:Label ID="lblRetireFurnace" runat="server" AssociatedControlID="ddlRetireFurnace" Text="Furnace"></asp:Label>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlRetireFurnace" runat="server" AutoPostBack="true"
                            OnSelectedIndexChanged="ddlRetireFurnace_SelectedIndexChanged">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px; padding: 4px 0;">
                        <asp:Label ID="lblRetireCathode" runat="server" AssociatedControlID="ddlRetireCathode" Text="Cathode Number"></asp:Label>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlRetireCathode" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
        </asp:Panel>

        <%-- Shared --%>
        <table style="width: 80%">
            <tr>
                <td style="width: 150px; padding: 4px 0;">
                    <asp:Label ID="Label2" runat="server" Text="Employee Number"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtBadge" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
        </table>

        <br />
        <asp:Button ID="btnAddCathode" runat="server" Text="Add Cathode"
            OnClick="btnAddCathode_Click" />
        <asp:Button ID="btnRetireCathode" runat="server" Text="Retire Cathode" Visible="false"
            OnClick="btnRetireCathode_Click"
            OnClientClick="return confirmRetire();" />
        &nbsp;
        <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="False"></asp:Label>
        <br />
        <br />

    </main>

    <script type="text/javascript">
        function confirmRetire() {
            var ddl = document.getElementById('<%= ddlRetireCathode.ClientID %>');
            if (!ddl || ddl.value === '') { return true; } // let the server-side check show the message
            return confirm('Retire cathode ' + ddl.value + '?\n\nIt will no longer appear in any cathode lists.');
        }
    </script>

</asp:Content>
