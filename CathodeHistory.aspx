
<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CathodeHistory.aspx.cs" Inherits="CathodeWeb.CathodeHistory" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <section class="row" aria-labelledby="pageTitle">
            <h1 id="pageTitle">Cathode History</h1>

            <!-- Furnace Dropdown Source -->
            <asp:SqlDataSource ID="SqlCathodeFurnace" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>"
                SelectCommand="SELECT serialnumber AS Cathode
                               FROM cathode
                               WHERE Furnace = @furnaceid
                               ORDER BY serialnumber">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlFurnace" DefaultValue="1"
                        Name="furnaceid" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>

            <!-- Cathode History Data Source -->
            <asp:SqlDataSource ID="SqlCathodeHistory" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>"
            SelectCommand="
                SELECT h.cathode_number,
       'Gun #' + CAST(e.number AS varchar(1)) AS GunNumber,
       i.installtime,
       i.volttimer AS HVTimer_Install,
       r.removaltime,
       r.hvtimer AS HVTimer_Remove,
       r.totalhours,
       LTRIM(RTRIM(
            COALESCE(ri.description, '') +
            CASE WHEN ri2.description IS NOT NULL THEN ', ' + ri2.description ELSE '' END +
            CASE WHEN ri3.description IS NOT NULL THEN ', ' + ri3.description ELSE '' END +
            CASE WHEN 7 IN (r.removalinfo_id, r.removalinfo_id2, r.removalinfo_id3)
                 THEN CASE WHEN
                        (COALESCE(ri.description,'')
                        + COALESCE(', ' + ri2.description,'')
                        + COALESCE(', ' + ri3.description,'')) = ''
                       THEN r.otherinfo
                       ELSE ', ' + r.otherinfo
                  END
                 ELSE ''
            END
        )) AS description,
       u.username AS InstalledBy,
       u2.username AS RemovedBy
FROM history h
INNER JOIN installdata i ON i.history_id = h.id
LEFT OUTER JOIN removaldata1 r ON
       r.history_id = (SELECT TOP 1 ID
                       FROM history
                       WHERE id > h.id AND cathode_number = h.cathode_number
                       ORDER BY id ASC)
INNER JOIN ebguns e ON e.id = h.gun_id
LEFT OUTER JOIN users u ON u.badge = i.badge_id
LEFT OUTER JOIN users u2 ON u2.badge = r.badge_id
LEFT OUTER JOIN removalinfo ri  ON ri.id  = r.removalinfo_id
LEFT OUTER JOIN removalinfo ri2 ON ri2.id = r.removalinfo_id2
LEFT OUTER JOIN removalinfo ri3 ON ri3.id = r.removalinfo_id3
WHERE h.cathode_number = @cathode
AND (e.furnace <> 1 OR h.created_at > '2026-06-14 00:00')
ORDER BY cathode_number, h.id DESC">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlCathode" DefaultValue="1269"
                        Name="cathode" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>

        </section>

        <div class="row">
        <!-- Furnace Selection -->
        <table style="width: 80%">
            <tr>
                <td style="width: 150px" >
                    <asp:Label ID="Label1" runat="server" Text="EB Furnace"></asp:Label>
                </td>
                <td></td>
                <td>
                    <asp:DropDownList ID="ddlFurnace" runat="server" Width="150px"
                        AutoPostBack="True" OnSelectedIndexChanged="ddlFurnace_SelectedIndexChanged" >
                        <asp:ListItem Value="1">EB1</asp:ListItem>
                        <asp:ListItem Value="2">EB2</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <!-- This adds space -->
            <tr><td colspan="3" style="height:20px;"></td></tr>

            <tr>
                <td style="width: 150px">
                    <asp:Label ID="Label2" runat="server" Text="Select Cathode"></asp:Label>
                </td>
                <td></td>
                <td>
                    <asp:DropDownList ID="ddlCathode" runat="server" Width="150px"
                        DataSourceID="SqlCathodeFurnace"
                        DataTextField="Cathode"
                        DataValueField="Cathode"
                        AutoPostBack="True"
                        OnSelectedIndexChanged="ddlCathode_SelectedIndexChanged">
                    </asp:DropDownList>
                </td>
            </tr>
             <!-- This adds space -->
             <tr><td colspan="3" style="height:20px;"></td></tr>
        </table>

        <!-- Cathode History Section -->
                        
                <section class="col-md-12">
                <asp:GridView ID="grdCathodeHistory" runat="server"
                    DataSourceID="SqlCathodeHistory" AutoGenerateColumns="False"
                    CellPadding="10" CellSpacing="5" AllowPaging="true" PageSize="15" Width="120%" >
                    <Columns>
                        <asp:BoundField DataField="cathode_number" HeaderText="Cathode" />
                        <asp:BoundField DataField="GunNumber" HeaderText="Gun" ReadOnly="True" />
                        <asp:BoundField DataField="installtime" HeaderText="Installed"
                                        DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                        <asp:BoundField DataField="HVTimer_Install" HeaderText="HV at Install" />
                        <asp:BoundField DataField="InstalledBy" HeaderText="Installer" ReadOnly="True" />
                        <asp:BoundField DataField="removaltime" HeaderText="Removed"
                                        DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                        <asp:BoundField DataField="HVTimer_Remove" HeaderText="HV at Remove" />
                        <asp:BoundField DataField="totalhours" HeaderText="Total HV" />
                        <asp:BoundField DataField="description" HeaderText="Removal Reason" />
                        <asp:BoundField DataField="RemovedBy" HeaderText="Remover" ReadOnly="True" />
                    </Columns>

                    <headerstyle backcolor="Turquoise" forecolor="Black" />
                </asp:GridView>
            </section>
            </div>
    </main>
</asp:Content>

