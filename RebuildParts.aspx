<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="RebuildParts.aspx.cs" Inherits="CathodeWeb.RebuildParts" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
     <asp:SqlDataSource ID="sqlCathode" runat="server" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="
 SELECT c.Cathode_Number, MAX(c.id) as id
FROM vwCathodeStatus c
LEFT OUTER JOIN parthistory p
ON p.history_id = c.id
WHERE c.status_id = 3
AND furnace = @FurnaceId
GROUP BY c.cathode_number
ORDER BY COUNT(p.history_id) DESC, c.Cathode_Number
">
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
     <asp:SqlDataSource ID="SqlPartList" runat="server" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT id, description
            FROM parts
            ORDER BY description">
     </asp:SqlDataSource>
    <main>
        <section class="row" aria-labelledby="pageTitle">
            <h1 id="pageTitle">Rebuild Cathode Parts</h1>
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
                 <td></td>
             </tr>
             <tr>
                 <td style="width: 102px">
                 <asp:Label ID="Label2" runat="server" Text="Part List"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                     <asp:DropDownList ID="ddlParts" runat="server" Width="150px" DataSourceID="SqlPartList" DataTextField="description" DataValueField="id" AutoPostBack="True" OnDataBound="ddlCathode_DataBound" OnSelectedIndexChanged="ddlCathode_SelectedIndexChanged"></asp:DropDownList>
                 </td>
             </tr>
             <tr>
                 <td style="width: 102px">
                 </td>
                 <td></td>
             </tr>
            <tr>
                 <td style="width: 102px">
                 <asp:Label ID="Label4" runat="server" Text="Number Used" ></asp:Label>
                 </td>
                 <td></td>
                 <td>
                   <asp:TextBox ID="txtCount" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>
                 </td>
             </tr>
              <tr>
                  <td style="width: 102px; padding:20px" >
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

        </table>

          <br />
         <br />
         <asp:Button ID="btnAddPart" runat="server" Text="Add Part" OnClick="btnAddPart_Click" />
         <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="False"></asp:Label>
         <br />
         <br />

       
        <asp:GridView ID="grdPartList" runat="server" AutoGenerateColumns="False" DataSourceID="SqlParts" DataKeyNames="id">
            <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                         <asp:LinkButton ID="btnDelete" runat="server" OnClick="btnDelete_Click">Delete</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="description" HeaderText="Part Description" SortExpression="description" />
                <asp:BoundField DataField="partcount" HeaderText="Part Count" SortExpression="partcount" />
            </Columns>
     </asp:GridView>
    </main>

</asp:Content>
