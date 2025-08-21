<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BenchTest.aspx.cs" Inherits="CathodeWeb.BenchTest" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:SqlDataSource ID="sqlCathode" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="        SELECT Cathode_Number
        FROM vwCathodeStatus 
        WHERE status_id = 2
        AND furnace = @FurnaceId
        ORDER BY Cathode_Number">
        <SelectParameters>
        <asp:ControlParameter ControlID="ddlFurnace"
            PropertyName="SelectedValue"
            Name="FurnaceId"
            Type="Int32" DefaultValue="1" />
        </SelectParameters>

    </asp:SqlDataSource>
    <main>
        <section class="row" aria-labelledby="pageTitle">
            <h1 id="pageTitle">Cathode Bench Test</h1>
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
                    <asp:DropDownList ID="ddlCathode" runat="server" Width="150px" DataSourceID="sqlCathode" DataTextField="Cathode_Number" DataValueField="Cathode_Number"></asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td style="width: 102px">
                </td>
                <td></td>
            </tr>
            <tr>
              <td style="width: 102px">
              <asp:Label ID="Label4" runat="server" Text="Bench Findings"></asp:Label>
              </td>
              <td></td>
              <td>
              <asp:TextBox ID="txtBench" runat="server" Width="800px" Rows="3" TextMode="MultiLine" AutoCompleteType="Disabled"></asp:TextBox>
              </td>
          </tr>
           <tr>
                 <td style="width: 102px">
                 </td>
                 <td></td>
             </tr>
            <tr>
                 <td style="width: 102px">
                 <asp:Label ID="Label5" runat="server" Text="Filament"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:Label ID="Label6" runat="server" Text="Intact"></asp:Label>    <asp:CheckBox ID="chkIntact" runat="server" />
                 <asp:TextBox ID="txtFilOhms" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>&#8486;
                 </td>
             </tr>
              <tr>
                    <td style="width: 102px">
                    </td>
                    <td></td>
                   </tr>
                   <tr>
                        <td style="width: 102px">
                        <asp:Label ID="Label9" runat="server" Text="Megohmmeter"></asp:Label>
                        </td>
                        <td></td>
                        <td>
                       <asp:TextBox ID="txtMeg" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>M&#8486;
                        </td>
            </tr>
            <tr>
                   <td style="width: 102px">
                   </td>
                   <td></td>
               </tr>
              <tr>
                   <td style="width: 102px">
                   <asp:Label ID="Label7" runat="server" Text="Uf-base"></asp:Label>
                   </td>
                   <td></td>
                   <td>
                  <asp:TextBox ID="txtUfOhms" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>M&#8486;
                   </td>
               </tr>
            <tr>
                <td style="width: 102px">
                </td>
                <td></td>
            </tr>
           <tr>
                <td style="width: 102px">
                <asp:Label ID="Label8" runat="server" Text="Us-base"></asp:Label>
                </td>
                <td></td>
                <td>
               <asp:TextBox ID="txtUsOhms" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>M&#8486;
                </td>
            </tr>
           
            <tr>
                 <td style="width: 102px; padding:20px">
                 </td>
                 <td></td>
             </tr>
            <tr>
                 <td style="width: 102px">
                 <asp:Label ID="Label2" runat="server" Text="Badge Number"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:TextBox ID="txtBadge" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>
                 </td>
             </tr>
            <tr><td>
   
    </table>
    &nbsp;&nbsp;
    <br />
    <br />
    <asp:Button ID="btnBench" runat="server" Text="Add Bench Findings" 
        onclick="btnBench_Click" />
    <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="False"></asp:Label>
    <br />
    <br />

    </main>

</asp:Content>