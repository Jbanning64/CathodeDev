<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CathodeWeb._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
        <section class="row" aria-labelledby="aspnetTitle">
            <h1 id="aspnetTitle">Cathode Status</h1>
            <p class="lead">Some blah blah blah</p>
            
                <asp:SqlDataSource ID="SqlEB1Guns" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT s.cathode_number AS Cathode, 'Gun #' + CAST(e.number AS varchar(1)) AS Gun_Number, i.installtime AS CathodeInstall_Time, 
CASE e.number
WHEN 1 THEN (SELECT TOP 1 Gun1Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer
WHEN 2 THEN (SELECT TOP 1 Gun2Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer
WHEN 3 THEN (SELECT TOP 1 Gun3Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer
WHEN 4 THEN (SELECT TOP 1 Gun4Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer
WHEN 5 THEN (SELECT TOP 1 Gun5Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer
WHEN 6 THEN (SELECT TOP 1 Gun6Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer
WHEN 7 THEN (SELECT TOP 1 Gun7Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer
WHEN 8 THEN (SELECT TOP 1 Gun8Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer
END as Usage

FROM  dbo.ebguns AS e LEFT OUTER JOIN
dbo.vwCathodeStatus AS s ON s.gun_id = e.id   LEFT OUTER JOIN
dbo.installdata AS i ON i.history_id = s.id LEFT OUTER JOIN
dbo.users AS u ON u.badge = i.badge_id

WHERE s.furnace = 1
AND s.status_id =1
ORDER BY Gun_Number
                    "></asp:SqlDataSource>
                 <asp:SqlDataSource ID="SqlNoCathode" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT GunNumber 
FROM vwEBGunNoCathode
WHERE furnace = 1"></asp:SqlDataSource>
                 <asp:SqlDataSource ID="sqlEB1Other" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT cathode_number, value, status_id
                        FROM vwCathodeStatus WHERE furnace = 1 AND status_id &lt;&gt; 1 
UNION
SELECT c.serialnumber as Cathode_Number, 'New Cathode' as value, 0 as status_id
        FROM cathode c
        WHERE c.serialnumber NOT IN (SELECT cathode_number FROM vwCathodeStatus WHERE furnace = 1)
        AND c.furnace = 1
ORDER BY status_id, cathode_number
">

                 </asp:SqlDataSource>    


        </section>

        <div class="row">
            <section class="col-md-4" aria-labelledby="gettingStartedTitle">
                <h2 id="gettingStartedTitle">EB1 Cathode Info</h2>
                <br />
                <h3 id="grdTitle">Cathodes Installed</h3>
                <asp:GridView ID="grdEB1Guns" runat="server" DataSourceID="SqlEB1Guns" AutoGenerateColumns="False" CellPadding="10" CellSpacing="5">
                    <headerstyle backcolor="LightGreen"
                            forecolor="Black"/>
                    
                    <rowstyle backcolor="LightCyan"  
                           forecolor="Black"
                           font-italic="false"/>
                    
                        <alternatingrowstyle backcolor="PaleTurquoise"  
                          forecolor="Black"
                          font-italic="false"/>
                    <Columns>
                        <asp:BoundField DataField="Cathode" HeaderText="Cathode" SortExpression="Cathode" />
                        <asp:BoundField DataField="Gun_Number" HeaderText="Gun" ReadOnly="True" SortExpression="Gun_Number" />
                        <asp:BoundField DataField="CathodeInstall_Time" HeaderText="Install Date" SortExpression="CathodeInstall_Time" DataFormatString="{0:yyyy-MM-dd hh:mm}"/>
                        <asp:BoundField DataField="Usage" HeaderText="Usage" SortExpression="HV Hours" ReadOnly="True" />
                    </Columns>
                </asp:GridView>
                <br />
                <br />
                <h3 id="grdTitle2">Guns No Cathode</h3>
                <asp:GridView ID="grdEB1NoCathode" runat="server" AutoGenerateColumns="False" DataSourceID="SqlNoCathode" ShowHeader="false" EmptyDataText="All Guns Filled" ShowHeaderWhenEmpty="true">
                    <Columns>
                        <asp:BoundField DataField="GunNumber" ReadOnly="True" SortExpression="GunNumber" />
                    </Columns>
                </asp:GridView>

            </section>
            <section class="col-md-4" aria-labelledby="librariesTitle">
                <h2 id="librariesTitle">EB1 Other Cathodes</h2>
                <br />
            <h3 id="grdTitle4">Unused Cathode Status</h3>
               <asp:GridView ID="grdEB1Other" runat="server" DataSourceID="sqlEB1Other" AutoGenerateColumns="False" CellPadding="5" DataKeyNames="status_id" OnRowDataBound="grdEB1Other_RowDataBound">
                   <headerstyle backcolor="Turquoise"
                    forecolor="Black"/>
                   <Columns>
                       <asp:BoundField DataField="cathode_number" HeaderText="Cathode" SortExpression="cathode_number" />
                       <asp:BoundField DataField="value" HeaderText="Status" SortExpression="value" />
                   </Columns>
                </asp:GridView>

            </section>
            <section class="col-md-4" aria-labelledby="hostingTitle">
                <h2 id="hostingTitle">Other Stuff</h2>
               
            </section>
        </div>
    </main>

</asp:Content>
