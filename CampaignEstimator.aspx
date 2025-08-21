<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CampaignEstimator.aspx.cs" Inherits="CathodeWeb.CampaignEstimator" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
        <section class="row" aria-labelledby="pageTitle">
            <h1 id="pageTitle">Campaign Usage Estimator</h1>
        </section>

        <asp:SqlDataSource ID="SqlHVEst" runat="server" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT s.cathode_number AS Cathode, 'Gun #' + CAST(e.number AS varchar(1)) AS Gun_Number, i.installtime AS CathodeInstall_Time, 
CASE e.number
WHEN 1 THEN (SELECT TOP 1 Gun1Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer + @NextHours
WHEN 2 THEN (SELECT TOP 1 Gun2Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer + @NextHours
WHEN 3 THEN (SELECT TOP 1 Gun3Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer + @NextHours
WHEN 4 THEN (SELECT TOP 1 Gun4Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer + @NextHours
WHEN 5 THEN (SELECT TOP 1 Gun5Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer + @NextHours
WHEN 6 THEN (SELECT TOP 1 Gun6Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer + @NextHours
WHEN 7 THEN (SELECT TOP 1 Gun7Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer + @NextHours
WHEN 8 THEN (SELECT TOP 1 Gun8Time FROM EB1HVTIMER ORDER BY HVTimerDate DESC) - i.volttimer + @NextHours
END as Usage

FROM  dbo.ebguns AS e LEFT OUTER JOIN
dbo.vwCathodeStatus AS s ON s.gun_id = e.id   LEFT OUTER JOIN
dbo.installdata AS i ON i.history_id = s.id LEFT OUTER JOIN
dbo.users AS u ON u.badge = i.badge_id

WHERE s.furnace = 1
AND s.status_id =1
ORDER BY Gun_Number">
            <SelectParameters>
                <asp:ControlParameter ControlID="txtEstimate" DefaultValue="0" Name="NextHours" PropertyName="Text" />
            </SelectParameters>
    </asp:SqlDataSource>

           <table style="width: 80%">
                <tr>
                    <td style="width: 102px">
                    <asp:Label ID="Label1" runat="server" Text="Next Campaign Est HV Hours" Width="150px"></asp:Label>
                    </td>
                    <td></td>
                    <td>
                    <asp:TextBox ID="txtEstimate" runat="server" Width="75px" AutoCompleteType="Disabled" TextMode="Number"></asp:TextBox>
                    </td>
                </tr>
        </table>
        <br />
        <br />
        <asp:GridView ID="grdEB1Guns" runat="server" DataSourceID="SqlHVEst" AutoGenerateColumns="False" CellPadding="10" CellSpacing="5" OnDataBinding="grdEB1Guns_DataBinding">
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
                <asp:BoundField DataField="Usage" HeaderText="Est Usage" SortExpression="HV Hours" ReadOnly="True" />
            </Columns>
        </asp:GridView>

        
    </main>

</asp:Content>