<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="InstallCathode.aspx.cs" Inherits="CathodeWeb.InstallCathode" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
     <asp:SqlDataSource ID="sqlCathode" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="
         SELECT Cathode_Number, id
         FROM vwCathodeStatus 
         WHERE status_id = 4
         AND furnace = @FurnaceId
         ORDER BY Cathode_Number">
         <SelectParameters>
         <asp:ControlParameter ControlID="ddlFurnace"
             PropertyName="SelectedValue"
             Name="FurnaceId"
             Type="Int32" DefaultValue="1" />
         </SelectParameters>

     </asp:SqlDataSource>

   
     <asp:SqlDataSource ID="SqlGuns" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT id, GunNumber
FROM vwEBGunNoCathode
WHERE furnace = @FurnaceID
ORDER BY GunNumber">
         <SelectParameters>
             <asp:ControlParameter ControlID="ddlFurnace" DefaultValue="1" Name="FurnaceID" PropertyName="SelectedValue" />
         </SelectParameters>
     </asp:SqlDataSource>

   
    <main>
        <section class="row" aria-labelledby="pageTitle">
            <h1 id="pageTitle">Install Cathode</h1>
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
                      <asp:DropDownList ID="ddlCathode" runat="server" Width="150px" DataSourceID="sqlCathode" DataTextField="Cathode_Number" DataValueField="id" AutoPostBack="True" ></asp:DropDownList>
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
                 <asp:Label ID="Label2" runat="server" Text="Available EB Guns"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                     <asp:DropDownList ID="ddlGuns" runat="server" Width="150px" DataSourceID="sqlGuns" DataTextField="GunNumber" DataValueField="id" AutoPostBack="True" ></asp:DropDownList>
                 </td>
             </tr>
             
             <tr>
                 <td style="width: 102px">
                 </td>
                 <td></td>
             </tr>
            <tr>
                 <td style="width: 400px">
                 <asp:Label ID="Label4" runat="server" Text="Install Time ---- hh:mm or YYYY-MM-DD hh:mm"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:TextBox ID="txtInstall" runat="server" Width="200px" AutoCompleteType="Disabled" ></asp:TextBox>
                 </td>
             </tr>
             
              <tr>
                 <td style="width: 102px">
                 </td>
                 <td></td>
             </tr>
            <tr>
                 <td style="width: 102px">
                 <asp:Label ID="Label7" runat="server" Text="High Voltage Timer"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:TextBox ID="txtTimer" runat="server" Width="104px" AutoCompleteType="Disabled"></asp:TextBox>
                 <asp:Button ID="btnTimer" runat="server" Text="Get HV Time" OnClick="btnTimer_Click"></asp:Button> 
                 </td>
             </tr>
             <tr>
            <td style="width: 102px">
                 </td>
                 <td></td>
             </tr>
            <tr>
                 <td style="width: 102px">
                 <asp:Label ID="Label5" runat="server" Text="Campaign"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:TextBox ID="txtCampaign" runat="server" Width="104px" AutoCompleteType="Disabled" ></asp:TextBox>
                 </td>
             </tr>
               <tr>
                     <td style="width: 102px">
                     </td>
                     <td></td>
                 </tr>
                <tr>
                     <td style="width: 102px">
                     <asp:Label ID="Label6" runat="server" Text="Upper Chamber Cleaned"></asp:Label>
                     </td>
                     <td></td>
                     <td>
                     <asp:DropDownList ID="ddlUpper" runat="server">
                        <asp:ListItem Selected="True" Value="99">Select Response</asp:ListItem>
                        <asp:ListItem Value="1">Yes</asp:ListItem>
                        <asp:ListItem Value="0">No</asp:ListItem>
                    </asp:DropDownList>
                     </td>
                 </tr>
               <tr>
                 <td style="width: 102px">
                 </td>
                 <td></td>
             </tr>
            <tr>
                 <td style="width: 400px">
                 <asp:Label ID="Label8" runat="server" Text="Torque wrench used on fingers and Braided wire and pucks are tight."></asp:Label>
                 </td>
                 <td></td>
                 <td>
                  <asp:DropDownList ID="ddlTorque" runat="server">
                    <asp:ListItem Selected="True" Value="99">Select Response</asp:ListItem>
                    <asp:ListItem Value="1">Yes</asp:ListItem>
                    
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
                     <asp:Label ID="Label22" runat="server" Text="Gun Rods Checked"></asp:Label>
                     </td>
                     <td></td>
                     <td>
                     <asp:DropDownList ID="ddlRods" runat="server">
                         <asp:ListItem Selected="True" Value="99">Select Response</asp:ListItem>
                         <asp:ListItem Value="1">Yes</asp:ListItem>
             
                     </asp:DropDownList>
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
                 <asp:TextBox ID="txtBadge" runat="server" Width="104px" AutoCompleteType="Disabled" ></asp:TextBox>&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;<asp:Label ID="Label21" runat="server" Text="Trainee Badge (If applicable)"></asp:Label>
                 <asp:TextBox ID="txtTrainee" runat="server" Width="104px" AutoCompleteType="Disabled" align="left" ></asp:TextBox>
                 </td>
             </tr>
        </table>
         <br />
        <br />
        <asp:Button ID="btnInstall" runat="server" Text="Install Cathode" OnClick="btnInstall_Click"/>
        <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="False"></asp:Label>
        <br />
        <br />
     </main>
     
</asp:Content>
