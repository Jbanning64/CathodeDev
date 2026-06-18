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
                             <asp:SqlDataSource ID="SqlGunHistory" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT h.cathode_number , 'Gun #' + CAST(e.number as varchar(1)) as GunNumber, i.installtime, i.volttimer as HVTimer_Install, r.removaltime, r.hvtimer as HVTimer_Remove, r.totalhours, --ri.description
	
-- Manual concatenation of up to 3 descriptions
    LTRIM(
        RTRIM(
            COALESCE(ri.description, '') +
            CASE WHEN ri2.description IS NOT NULL 
                 THEN ', ' + ri2.description ELSE '' END +
            CASE WHEN ri3.description IS NOT NULL 
                 THEN ', ' + ri3.description ELSE '' END +
			-- If *any* removalinfo_id = 7, append otherinfo
			CASE WHEN 7 IN (r.removalinfo_id, r.removalinfo_id2, r.removalinfo_id3)
				 THEN CASE 
					WHEN (COALESCE(ri.description,'') 
						  + COALESCE(', ' + ri2.description,'') 
						  + COALESCE(', ' + ri3.description,'')) = ''
					THEN r.otherinfo          -- no descriptions yet
					ELSE ', ' + r.otherinfo   -- append to existing
				  END
				ELSE ''
			END
        )
    ) AS description, u.username AS InstalledBy, u2.username AS RemovedBy
         FROM history h
         INNER JOIN installdata i
         ON i.history_id = h.id
         LEFT OUTER JOIN removaldata1 r
         ON r.history_id = (SELECT TOP 1 ID FROM history where id &gt; h.id AND gun_id = h.gun_id ORDER BY id asc)
         INNER JOIN ebguns e
         ON e.id = h.gun_id
         LEFT OUTER JOIN users u
         ON u.badge = i.badge_id
         LEFT OUTER JOIN users u2
         ON u2.badge = r.badge_id
         LEFT OUTER JOIN removalinfo ri
         ON ri.id = r.removalinfo_id
		 LEFT OUTER JOIN removalinfo ri2 ON ri2.id = r.removalinfo_id2
		 LEFT OUTER JOIN removalinfo ri3 ON ri3.id = r.removalinfo_id3
         WHERE h.gun_id = @gunid
         AND (e.furnace &lt;&gt; 1 OR h.created_at &gt; '2026-06-14 00:00')
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
             <asp:SqlDataSource ID="SqlCathodeHistory" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT h.cathode_number, 'Gun #' + CAST(e.number as varchar(1)) as GunNumber, i.installtime, i.volttimer as HVTimer_Install, r.removaltime, r.hvtimer as HVTimer_Remove, r.totalhours, --ri.description
-- Manual concatenation of up to 3 descriptions
    LTRIM(
        RTRIM(
            COALESCE(ri.description, '') +
            CASE WHEN ri2.description IS NOT NULL 
                 THEN ', ' + ri2.description ELSE '' END +
            CASE WHEN ri3.description IS NOT NULL 
                 THEN ', ' + ri3.description ELSE '' END +
			-- If *any* removalinfo_id = 7, append otherinfo
			CASE WHEN 7 IN (r.removalinfo_id, r.removalinfo_id2, r.removalinfo_id3)
				 THEN CASE 
					WHEN (COALESCE(ri.description,'') 
						  + COALESCE(', ' + ri2.description,'') 
						  + COALESCE(', ' + ri3.description,'')) = ''
					THEN r.otherinfo          -- no descriptions yet
					ELSE ', ' + r.otherinfo   -- append to existing
				  END
				ELSE ''
			END
        )
    ) AS description, u.username AS InstalledBy, u2.username AS RemovedBy
FROM history h
INNER JOIN installdata i
ON i.history_id = h.id
LEFT OUTER JOIN removaldata1 r
ON r.history_id = (SELECT TOP 1 ID FROM history where id &gt; h.id AND cathode_number = h.cathode_number ORDER BY id asc)
INNER JOIN ebguns e
ON e.id = h.gun_id
LEFT OUTER JOIN users u
ON u.badge = i.badge_id
LEFT OUTER JOIN users u2
ON u2.badge = r.badge_id
LEFT OUTER JOIN removalinfo ri ON ri.id = r.removalinfo_id
LEFT OUTER JOIN removalinfo ri2 ON ri2.id = r.removalinfo_id2
LEFT OUTER JOIN removalinfo ri3 ON ri3.id = r.removalinfo_id3
WHERE h.cathode_number = @cathode 
AND (e.furnace &lt;&gt; 1 OR h.created_at &gt; '2026-06-14 00:00')
ORDER BY cathode_number, h.id">
                 <SelectParameters>
                     <asp:ControlParameter ControlID="ddlCathode" DefaultValue="1269" Name="cathode" PropertyName="SelectedValue" />
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
                <asp:GridView ID="grdEBHistory" runat="server" DataSourceID="SqlGunHistory" AutoGenerateColumns="False" CellPadding="10" CellSpacing="5">
                    <Columns>
                        <asp:BoundField DataField="cathode_number" HeaderText="Cathode" HeaderStyle-Wrap="false" SortExpression="cathode_number"><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="GunNumber" HeaderText="Gun" HeaderStyle-Wrap="false" ReadOnly="True" SortExpression="GunNumber" > <ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="installtime" HeaderText="Installed" HeaderStyle-Wrap="false" SortExpression="installtime" DataFormatString="{0:yyyy-MM-dd HH:mm}" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="HVTimer_Install" HeaderText="HV at Install" HeaderStyle-Wrap="false" SortExpression="HVTimer_Install" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="InstalledBy" HeaderText="Installer" HeaderStyle-Wrap="false" ReadOnly="True" SortExpression="InstalledBy" > <ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="removaltime" HeaderText="Removed" HeaderStyle-Wrap="false" SortExpression="removaltime" DataFormatString="{0:yyyy-MM-dd HH:mm}" > <ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="HVTimer_Remove" HeaderText="HV at Remove" HeaderStyle-Wrap="false" SortExpression="HVTimer_Remove" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="totalhours" HeaderText="Total HV" HeaderStyle-Wrap="false" SortExpression="totalhours" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="description" HeaderText="Removal Reason" HeaderStyle-Wrap="false" SortExpression="description" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="RemovedBy" HeaderText="Remover" ReadOnly="True" HeaderStyle-Wrap="false" SortExpression="RemovedBy" > <ItemStyle Wrap="False" /></asp:BoundField>
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
               <asp:GridView ID="grdCathodeHistory" runat="server" DataSourceID="SqlCathodeHistory" AutoGenerateColumns="False" CellPadding="10" CellSpacing="5">
                   <Columns>
                       <asp:BoundField DataField="cathode_number" HeaderText="Cathode" HeaderStyle-Wrap="false" SortExpression="cathode_number"><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="GunNumber" HeaderText="Gun" ReadOnly="True" HeaderStyle-Wrap="false" SortExpression="GunNumber" > <ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="installtime" HeaderText="Installed" HeaderStyle-Wrap="false" SortExpression="installtime" DataFormatString="{0:yyyy-MM-dd HH:mm}" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="HVTimer_Install" HeaderText="HV at Install" HeaderStyle-Wrap="false" SortExpression="HVTimer_Install" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="InstalledBy" HeaderText="Installer" HeaderStyle-Wrap="false" ReadOnly="True" SortExpression="InstalledBy" > <ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="removaltime" HeaderText="Removed" HeaderStyle-Wrap="false" SortExpression="removaltime" DataFormatString="{0:yyyy-MM-dd HH:mm}" > <ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="HVTimer_Remove" HeaderText="HV at Remove" HeaderStyle-Wrap="false" SortExpression="HVTimer_Remove" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="totalhours" HeaderText="Total HV" HeaderStyle-Wrap="false" SortExpression="totalhours" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="description" HeaderText="Removal Reason" HeaderStyle-Wrap="false" SortExpression="description" ><ItemStyle Wrap="False" /></asp:BoundField>
                        <asp:BoundField DataField="RemovedBy" HeaderText="Remover" ReadOnly="True" HeaderStyle-Wrap="false" SortExpression="RemovedBy" > <ItemStyle Wrap="False" /></asp:BoundField>
                   </Columns>
                   <headerstyle backcolor="Turquoise"
                    forecolor="Black"/>
                </asp:GridView>

            </section>
           
        </div>
    </main>
</asp:Content>