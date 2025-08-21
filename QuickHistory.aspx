<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="QuickHistory.aspx.cs" Inherits="CathodeWeb.QuickHistory" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <section class="row" aria-labelledby="pageTitle">
            <h1 id="pageTitle">Cathode/Gun History</h1>
                <asp:SqlDataSource ID="SqlGuns" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT id, 'Gun #' + CAST(number as varchar(2)) as GunNumber
                            FROM ebguns
                            WHERE furnace = @furnaceid">
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlFurnace" DefaultValue="1" Name="furnaceid" PropertyName="SelectedValue" />
                </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlGunHistory" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT h.cathode_number, 'Gun #' + CAST(e.number as varchar(1)) as GunNumber, i.installtime, i.volttimer as HVTimer_Install, r.removaltime, r.hvtimer as HVTimer_Remove, r.totalhours, ri.description
                        FROM history h
                        INNER JOIN installdata i
                        ON i.history_id = h.id
                        LEFT OUTER JOIN removaldata1 r
                        ON r.history_id = (SELECT TOP 1 ID FROM history where id &gt; h.id AND gun_id = h.gun_id ORDER BY id asc)
                        INNER JOIN ebguns e
                        ON e.id = h.gun_id
                        LEFT OUTER JOIN removalinfo ri
                        ON ri.id = r.removalinfo_id
                        WHERE h.gun_id = @gunid
                        ORDER BY GunNumber, h.id">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="ddlGun" DefaultValue="1" Name="gunid" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
             <asp:SqlDataSource ID="SqlCathode" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT serialnumber as Cathode
                            FROM cathode
                            WHERE Furnace = @FurnaceID ORDER BY serialnumber">
                 <SelectParameters>
                     <asp:ControlParameter ControlID="ddlFurnace" DefaultValue="1" Name="furnaceid" PropertyName="SelectedValue" />
                 </SelectParameters>
                 </asp:SqlDataSource>
             <asp:SqlDataSource ID="SqlCathodeHistory" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT h.cathode_number, 'Gun #' + CAST(e.number as varchar(1)) as GunNumber, i.installtime, i.volttimer as HVTimer_Install, r.removaltime, r.hvtimer as HVTimer_Remove, r.totalhours, ri.description
FROM history h
INNER JOIN installdata i
ON i.history_id = h.id
LEFT OUTER JOIN removaldata1 r
ON r.history_id = (SELECT TOP 1 ID FROM history where id &gt; h.id AND cathode_number = h.cathode_number ORDER BY id asc)
INNER JOIN ebguns e
ON e.id = h.gun_id
LEFT OUTER JOIN removalinfo ri
ON ri.id = r.removalinfo_id
WHERE h.cathode_number = @cathode
ORDER BY cathode_number, h.id">
                 <SelectParameters>
                     <asp:ControlParameter ControlID="ddlCathode" DefaultValue="1000" Name="cathode" PropertyName="SelectedValue" />
                 </SelectParameters>
             </asp:SqlDataSource>
            
        </section>

         <table style="width: 80%">
              <tr>
                  <td style="width: 102px">
                  <asp:Label ID="Label1" runat="server" Text="EB Furnace" Width="150px"></asp:Label>
                  </td>
                  <td></td>
                  <td>
                  <asp:DropDownList ID="ddlFurnace" runat="server" Width="150px" AutoPostBack="True" OnSelectedIndexChanged="ddlFurnace_SelectedIndexChanged">
                      <asp:ListItem Value="1">EB1</asp:ListItem>
                      <asp:ListItem Value="2">EB2</asp:ListItem>
                      </asp:DropDownList>
                  </td>
              </tr>
              <tr>
                 <td style="width: 102px">
                 </td>
                 <td></td>
                 <td></td>
             </tr>

           </table>
        <div class="row">
            <section class="col-md-8" aria-labelledby="gettingStartedTitle">
                
                <br />
                <asp:Label ID="Label2" runat="server" Text="Select Gun" Width="150px"></asp:Label>
                <asp:DropDownList ID="ddlGun" runat="server" Width="150px" DataSourceID="SqlGuns" DataTextField="GunNumber" DataValueField="id" OnSelectedIndexChanged="ddlGun_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                <br />
                <br />
                <h3 id="grdTitle">EB Gun - Cathode History</h3>
                <asp:GridView ID="grdEBHistory" runat="server" DataSourceID="SqlGunHistory" AutoGenerateColumns="False" CellPadding="5" CellSpacing="5">
                    <Columns>
                        <asp:BoundField DataField="cathode_number" HeaderText="Cathode" SortExpression="cathode_number"><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="GunNumber" HeaderText="Gun" ReadOnly="True" SortExpression="GunNumber" > <ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="installtime" HeaderText="Installed" SortExpression="installtime" DataFormatString="{0:yyyy-MM-dd hh:mm}" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="HVTimer_Install" HeaderText="HV at Install" SortExpression="HVTimer_Install" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="removaltime" HeaderText="Removed" SortExpression="removaltime" DataFormatString="{0:yyyy-MM-dd hh:mm}" > <ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="HVTimer_Remove" HeaderText="HV at Remove" SortExpression="HVTimer_Remove" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="totalhours" HeaderText="Total HV" SortExpression="totalhours" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="description" HeaderText="Removal Reason" SortExpression="description" ><ItemStyle Wrap="False" /></asp:BoundField>
                    </Columns>
                    <headerstyle backcolor="LightGreen"
                            forecolor="Black"/>
            
                    <rowstyle backcolor="LightCyan"  
                           forecolor="Black"
                           font-italic="false"/>
            
                        <alternatingrowstyle backcolor="PaleTurquoise"  
                          forecolor="Black"
                          font-italic="false"/>
                </asp:GridView>
            
            </section>
            <br />
            <br />
            <section class="col-md-8" aria-labelledby="librariesTitle">
                
                <br />
                <br />
                 <asp:Label ID="Label3" runat="server" Text="Select Cathode" Width="150px"></asp:Label>
                <asp:DropDownList ID="ddlCathode" runat="server" Width="150px" DataSourceID="SqlCathode" DataTextField="Cathode" DataValueField="Cathode"  AutoPostBack="True" OnSelectedIndexChanged="ddlCathode_SelectedIndexChanged"></asp:DropDownList>
                <br />
                <br />
            <h3 id="grdTitle4">Cathode - EB Gun History</h3>
               <asp:GridView ID="grdCathodeHistory" runat="server" DataSourceID="SqlCathodeHistory" AutoGenerateColumns="False" CellPadding="5">
                   <Columns>
                       <asp:BoundField DataField="cathode_number" HeaderText="Cathode" SortExpression="cathode_number"><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="GunNumber" HeaderText="Gun" ReadOnly="True" SortExpression="GunNumber" > <ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="installtime" HeaderText="Installed" SortExpression="installtime" DataFormatString="{0:yyyy-MM-dd hh:mm}" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="HVTimer_Install" HeaderText="HV at Install" SortExpression="HVTimer_Install" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="removaltime" HeaderText="Removed" SortExpression="removaltime" DataFormatString="{0:yyyy-MM-dd hh:mm}" > <ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="HVTimer_Remove" HeaderText="HV at Remove" SortExpression="HVTimer_Remove" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="totalhours" HeaderText="Total HV" SortExpression="totalhours" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="description" HeaderText="Removal Reason" SortExpression="description" ><ItemStyle Wrap="False" /></asp:BoundField>
                   </Columns>
                   <headerstyle backcolor="Turquoise"
                    forecolor="Black"/>
                </asp:GridView>

            </section>
           
        </div>
    </main>
</asp:Content>