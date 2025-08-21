<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RemoveCathode.aspx.cs" Inherits="CathodeWeb.RemoveCathode" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
        <section class="row" aria-labelledby="pageTitle">
            <h1 id="pageTitle">Remove Cathode</h1>
        </section>
        <asp:SqlDataSource ID="SqlGuns" runat="server" ProviderName="<%$ ConnectionStrings:CathodeConnString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:CathodeConnString %>" SelectCommand="SELECT Gun_Number, Cathode, gun_id
FROM vwEBCathodesInUse
WHERE furnace = @FurnaceID ORDER BY Gun_Number">
             <SelectParameters>
                 <asp:ControlParameter ControlID="ddlFurnace"
                     PropertyName="SelectedValue"
                     Name="FurnaceId"
                     Type="Int32" DefaultValue="1" />
                 </SelectParameters>
        </asp:SqlDataSource>
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
                 <asp:Label ID="Label3" runat="server" Text="Guns"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                     <asp:DropDownList ID="ddlGuns" runat="server" Width="150px" DataSourceID="SqlGuns" DataTextField="Gun_Number" DataValueField="Cathode" AutoPostBack="True" OnDataBound="ddlGuns_DataBound" OnSelectedIndexChanged="ddlGuns_SelectedIndexChanged" ></asp:DropDownList>
                     <asp:TextBox ID="txtGunID" runat="server" Visible="False"></asp:TextBox>
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
                 <asp:Label ID="Label5" runat="server" Text="Cathode"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:TextBox ID="txtCathode" runat="server" Width="104px" AutoCompleteType="Disabled" Enabled="False" ></asp:TextBox>
                 </td>
            </tr>
              <tr>
                 <td style="width: 102px">
                 </td>
                 <td></td>
             </tr>
            <tr>
                 <td style="width: 400px">
                 <asp:Label ID="Label6" runat="server" Text="Removal Time ---- hh:mm or YYYY-MM-DD hh:mm"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:TextBox ID="txtRemove" runat="server" Width="200px" AutoCompleteType="Disabled" ></asp:TextBox>
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
                 <asp:Label ID="Label4" runat="server" Text="HV Timer"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:TextBox ID="txtHVTimer" runat="server" Width="104px" AutoCompleteType="Disabled"  ></asp:TextBox>
                <asp:Button ID="btnTimer" runat="server" Text="Get HV Time" OnClick="btnTimer_Click" ></asp:Button>
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
                 <asp:Label ID="Label7" runat="server" Text="Total HV Time"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:TextBox ID="txtTotalHV" runat="server" Width="104px" AutoCompleteType="Disabled"  ></asp:TextBox>
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
                 <asp:Label ID="Label2" runat="server" Text="Campaign"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:TextBox ID="txtCampaign" runat="server" Width="104px" AutoCompleteType="Disabled"  ></asp:TextBox>
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
                 <asp:Label ID="Label8" runat="server" Text="Us 1400 Stable"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                  <asp:DropDownList ID="ddlUs" runat="server">
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
                <td style="width: 102px">
                </td>
                <td></td>
                <td></td>
            </tr>
             <tr>
                 <td style="width: 102px">
                 <asp:Label ID="Label9" runat="server" Text="Upper Chamber Vac (mT)"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:TextBox ID="txtUpper" runat="server" Width="104px" AutoCompleteType="Disabled"  ></asp:TextBox>
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
                 <asp:Label ID="Label10" runat="server" Text="Reason Pulled:"></asp:Label>
                 </td>
             </tr>
               <tr>
                <td style="width: 102px">
                </td>
                <td></td>
                <td></td>
            </tr>
             <tr>
                 <td style="width: 102px" align="right" >
                 <asp:Label ID="Label11" runat="server" Text="Time"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:Checkbox ID="chkTime" runat="server" ></asp:Checkbox>
                 </td>
            </tr>
              <tr>
                 <td style="width: 102px; height: 22px;" align="right" >
                 <asp:Label ID="Label12" runat="server" Text="No MAs"></asp:Label>
                 </td>
                 <td style="height: 22px"></td>
                 <td style="height: 22px">
                 <asp:Checkbox ID="chkNoMA" runat="server" ></asp:Checkbox>
                 </td>
            </tr>
               <tr>
                 <td style="width: 102px" align="right" >
                 <asp:Label ID="Label13" runat="server" Text="Arcing Rate (kV)"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:Checkbox ID="chkArc" runat="server" ></asp:Checkbox>
                <asp:TextBox ID="txtArcKV" runat="server" Width="104px" AutoCompleteType="Disabled"  ></asp:TextBox>
                 </td>
            </tr>
               <tr>
                 <td style="width: 102px; height: 22px;" align="right" >
                 <asp:Label ID="Label14" runat="server" Text="High Temp"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:Checkbox ID="chkTemp" runat="server" ></asp:Checkbox>
                 </td>
            </tr>
              <tr>
                 <td style="width: 102px" align="right" >
                 <asp:Label ID="Label15" runat="server" Text="Uf"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:Checkbox ID="chkUf" runat="server" ></asp:Checkbox>
                 </td>
            </tr>
               <tr>
                 <td style="width: 102px" align="right" >
                 <asp:Label ID="Label16" runat="server" Text="Alignment"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:Checkbox ID="chkAlign" runat="server" ></asp:Checkbox>
                 </td>
            </tr>
                <tr>
                 <td style="width: 102px" align="right" >
                 <asp:Label ID="Label17" runat="server" Text="Unstable MAs"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:Checkbox ID="chkUnstable" runat="server" ></asp:Checkbox>
                 </td>
            </tr>
            <tr>
                 <td style="width: 102px" align="right" >
                 <asp:Label ID="Label18" runat="server" Text="Low MAs"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:Checkbox ID="chkLow" runat="server" ></asp:Checkbox>
                <asp:TextBox ID="txtLow" runat="server" Width="104px" AutoCompleteType="Disabled"  ></asp:TextBox>
                 </td>
            </tr>
              <tr>
                  <td style="width: 102px" align="right" >
                  <asp:Label ID="Label19" runat="server" Text="Other (Please Explain:)"></asp:Label>
                  </td>
                  <td></td>
                  <td>
                  <asp:Checkbox ID="chkOther" runat="server" ></asp:Checkbox>
                 <asp:TextBox ID="txtOther" runat="server" Width="242px" AutoCompleteType="Disabled" TextMode="MultiLine"  ></asp:TextBox>
                  </td>
             </tr>
              <tr>
                 <td style="width: 102px; padding:20px">
                 </td>
                 <td></td>
             </tr>
            
            <tr>
                 <td style="width: 102px">
                 <asp:Label ID="Label20" runat="server" Text="Badge Number"></asp:Label>
                 </td>
                 <td></td>
                 <td>
                 <asp:TextBox ID="txtBadge" runat="server" Width="104px" AutoCompleteType="Disabled" align="left" ></asp:TextBox>&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;<asp:Label ID="Label21" runat="server" Text="Trainee Badge (If applicable)"></asp:Label>
                 <asp:TextBox ID="txtTrainee" runat="server" Width="104px" AutoCompleteType="Disabled" align="left" ></asp:TextBox>
                 </td>
 </tr>
         </table>
         <br />
        <br />
        <asp:Button ID="btnRemove" runat="server" Text="Remove Cathode" OnClick="btnRemove_Click" />
        <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="False"></asp:Label>
        <br />
        <br />

    </main>

</asp:Content>