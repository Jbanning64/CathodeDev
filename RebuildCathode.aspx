<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="RebuildCathode.aspx.cs" Inherits="CathodeWeb.RebuildCathode" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
     <asp:SqlDataSource ID="sqlCathode" runat="server" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT c.serialnumber as Cathode_Number, 0 as id, 0 as partcount
FROM cathode c
WHERE c.serialnumber NOT IN (SELECT cathode_number FROM vwCathodeStatus WHERE furnace = @FurnaceId)
AND c.furnace = @FurnaceId
UNION
SELECT s.Cathode_Number, s.id, COUNT(parts_id) as partcount
FROM vwCathodeStatus s
LEFT OUTER JOIN parthistory 
ON history_id = s.id
WHERE status_id = 3
AND furnace = @FurnaceId
GROUP BY s.cathode_number, s.id
ORDER BY partcount desc, Cathode_Number asc">
         <SelectParameters>
         <asp:ControlParameter ControlID="ddlFurnace"
             PropertyName="SelectedValue"
             Name="FurnaceId"
             Type="Int32" DefaultValue="1" />
         </SelectParameters>

     </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlParts" runat="server" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT h.id, p.description, h.partcount
       FROM parthistory h
       INNER JOIN parts p
       ON p.id = h.parts_id
       WHERE h.history_id = @HistoryID">
       <SelectParameters>
       <asp:ControlParameter ControlID="ddlCathode"
           PropertyName="SelectedValue"
           Name="HistoryID"
           Type="Int32" DefaultValue="1" />
       </SelectParameters>

    </asp:SqlDataSource>

    <main>
        <section class="row" aria-labelledby="pageTitle">
            <h1 id="pageTitle">Rebuild Cathode</h1>
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
             <tr>
                 <td style="width: 102px">
                 <asp:Label ID="Label3" runat="server" Text="Cathode"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                     <asp:DropDownList ID="ddlCathode" runat="server" Width="150px" DataSourceID="sqlCathode" DataTextField="Cathode_Number" DataValueField="id" AutoPostBack="True" OnDataBound="ddlCathode_DataBound" OnSelectedIndexChanged="ddlCathode_SelectedIndexChanged"></asp:DropDownList>
                 </td>
             </tr>
             
             <tr>
                  <td style="width: 102px">
                  </td>
                  <td></td>
              </tr>
             <tr>
                  <td style="width: 400px">
                  <asp:Label ID="Label4" runat="server" Text="Resistance is greater than 6Mohms between the filament and the solid cathode base plate." ></asp:Label>
                  </td>
                  <td></td>
                  <td>
                  <asp:CheckBox ID="chkResistance" runat="server" />
                    <asp:TextBox ID="txtResistance" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>M&#8486;
                  </td>
              </tr>
             <tr>
                  <td style="width: 102px">
                  </td>
                  <td></td>
              </tr>
             <tr>
                  <td style="width: 400px">
                  <asp:Label ID="Label6" runat="server" Text="Filament to solid cathode spacing is correct per SWTES."></asp:Label>
                  </td>
                  <td></td>
                  <td>
                  <asp:CheckBox ID="chkSpacing" runat="server" />
                  </td>
              </tr>
            <tr>
                  <td style="width: 102px">
                  </td>
                  <td></td>
              </tr>
             <tr>
                  <td style="width: 400px">
                  <asp:Label ID="Label7" runat="server" Text="Filament is centered under solid cathode."></asp:Label>
                  </td>
                  <td></td>
                  <td>
                  <asp:CheckBox ID="chkCentered" runat="server" />
                  </td>
              </tr>
            <tr>
                  <td style="width: 102px">
                  </td>
                  <td></td>
              </tr>
             <tr>
                  <td style="width: 400px">
                  <asp:Label ID="Label8" runat="server" Text="Tungsten inventory completed."></asp:Label>
                  </td>
                  <td></td>
                  <td>
                  <asp:CheckBox ID="chkTungsten" runat="server" />
                  </td>
              </tr>
            <tr>
                 <td style="width: 102px">
                 </td>
                 <td></td>
             </tr>
            <tr>
                 <td style="width: 400px">
                 <asp:Label ID="Label2" runat="server" Text="Tungsten disposal variance." ></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:CheckBox ID="chkTunVar" runat="server" />
                   <asp:TextBox ID="txtTunVar" runat="server" Width="423px" AutoCompleteType="Disabled" TextMode="MultiLine"></asp:TextBox>
                 </td>
             </tr>
             <tr>
                  <td style="width: 102px">
                  </td>
                  <td></td>
              </tr>
             <tr>
                  <td style="width: 400px">
                  <asp:Label ID="Label9" runat="server" Text="Filament resistence recorded." ></asp:Label>
                  </td>
                  <td></td>
                  <td>
                  <asp:CheckBox ID="chkFilament" runat="server" />
                    <asp:TextBox ID="txtFilament" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>&#8486;
                  </td>
              </tr>
            <tr>
                  <td style="width: 102px">
                  </td>
                  <td></td>
              </tr>
             <tr>
                  <td style="width: 102px">
                  <asp:Label ID="Label5" runat="server" Text="Iso Chamber"></asp:Label>
                  </td>
                  <td></td>
                  <td>
                  <asp:TextBox ID="txtISO" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>
                  </td>
              </tr>
             
             <tr>
                   <td style="width: 102px">
                   </td>
                   <td></td>
               </tr>
            <tr style="height:40px">
                  <td style="width: 102px">
                  </td>
                  <td></td>
              </tr>
              <tr>
                   <td style="width: 400px">
                   <asp:Label ID="Label11" runat="server" Text="Cathode Rebuild Completed."></asp:Label>
                   </td>
                   <td></td>
                   <td>
                   <asp:CheckBox ID="chkComplete" runat="server" />
                   </td>
               </tr>
             <tr>
                  <td style="width: 102px; padding:20px">
                  </td>
                  <td></td>
              </tr>
             <tr>
                  <td style="width: 102px">
                  <asp:Label ID="Label10" runat="server" Text="Badge Number"></asp:Label>
                  </td>
                  <td></td>
                  <td>
                  <asp:TextBox ID="txtBadge" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>
                  </td>
              </tr>
             <tr><td>

        </table>
              <br />
             <br />
             <asp:Button ID="btnRebuild" runat="server" Text="Rebuild Cathode" 
                 onclick="btnRebuild_Click" />
             <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="False"></asp:Label>
             <br />
             <br />
             
           <asp:GridView ID="grdPartList" runat="server" AutoGenerateColumns="False" DataSourceID="SqlParts" DataKeyNames="id">
               <Columns>
                   <asp:BoundField DataField="description" HeaderText="Part Description" SortExpression="description" />
                   <asp:BoundField DataField="partcount" HeaderText="Part Count" SortExpression="partcount" />
               </Columns>
        </asp:GridView>

    </main>

</asp:Content>