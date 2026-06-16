<%@ Page Title="CathodeTraveler" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CathodeTraveler.aspx.cs" Inherits="CathodeWeb.CathodeTraveler" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
        }

        h2 {
            margin-top: 40px;
            border-bottom: 2px solid #333;
            padding-bottom: 5px;
        }

        .label {
            font-weight: bold;
            margin-top: 15px;
            display: block;
        }

        .input-line {
            border-bottom: 1px solid #000;
            display: inline-block;
            width: 250px;
            height: 18px;
        }

        .checkbox-group {
            margin-top: 10px;
        }

        .checkbox-group label {
            display: block;
            margin-bottom: 6px;
        }

        .large-box {
            border: 1px solid #000;
            height: 120px;
            width: 95%;
            margin-top: 10px;
        }

        table.parts-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        table.parts-table td {
            padding: 4px 6px;
            vertical-align: top;
        }

        .noprint {
            margin-bottom: 20px;
        }

        @media print {
            .noprint {
                display: none;
            }
        }
    </style>


    <div class="noprint">
        <asp:Button ID="btnPrint" runat="server" Text="Print" 
            OnClientClick="window.print(); return false;" />
        <hr />
    </div>

    <!-- SECTION 1 -->
    <h2>Section 1 – Initial Inspection</h2>

    <div style="display:flex; gap:35px; margin-top:20px; align-items:center; width:100%; margin:0;">

        <div>
            Cathode #: <span id="cathodeSpan" runat="server" style="width:120px;"></span>
        </div>

        <div>
            Pulled From Gun #: <span id="gunSpan" runat="server" style="width:200px;"></span>
        </div>

        <div>
            Total HV Time: <span id="hvtimeSpan" runat="server" style="width:200px;"></span>
        </div>

    </div>
    
    <span class="label">Bench Test Findings:</span>
    <div class="large-box"></div>

    <span class="label">Ohm Check Results:</span>
     <div style="display:flex; gap:35px; margin-top:20px; align-items:center; width:100%; margin:0;">
        <div>
            Filament Intact <span class="input-line" style="width:120px;"></span> Ω
        </div>
        <div>
            Megohmmeter Results <span class="input-line" style="width:120px;"></span> Ω
        </div>
    </div>
    <div style="display:flex; gap:35px; margin-top:20px; align-items:center; width:100%; margin:0;">
        <div>
            Uf-base <span class="input-line" style="width:120px;"></span> Ω
        </div>
        <div>
            Us-base <span class="input-line" style="width:120px;"></span> Ω
        </div>
    </div>
    
    <!-- SECTION 2 -->
    <h2>Section 2 – Rebuild</h2>

    <span class="label">Part List</span>

    <table class="parts-table">
        <tr>
            <td>Solid Cathode</td><td><span class="input-line" style="width:60px;"></span></td>
            <td>Potential Rod</td><td><span class="input-line" style="width:60px;"></span></td>
        </tr>
        <tr>
            <td>Filament</td><td><span class="input-line" style="width:60px;"></span></td>
            <td>Electrode Rod</td><td><span class="input-line" style="width:60px;"></span></td>
        </tr>
        <tr>
            <td>Rod Carrier</td><td><span class="input-line" style="width:60px;"></span></td>
            <td>Rod</td><td><span class="input-line" style="width:60px;"></span></td>
        </tr>
        <tr>
            <td>Filament Holder</td><td><span class="input-line" style="width:60px;"></span></td>
            <td>Cathode Carrier</td><td><span class="input-line" style="width:60px;"></span></td>
        </tr>
        <tr>
            <td>Shielding Nut</td><td><span class="input-line" style="width:60px;"></span></td>
            <td>Shielding Sheet</td><td><span class="input-line" style="width:60px;"></span></td>
        </tr>
        <tr>
            <td>Bushing</td><td><span class="input-line" style="width:60px;"></span></td>
            <td>Arresting Sheet</td><td><span class="input-line" style="width:60px;"></span></td>
        </tr>
        <tr>
            <td>Potential Sheet</td><td><span class="input-line" style="width:60px;"></span></td>
            <td>Focusing Electrode</td><td><span class="input-line" style="width:60px;"></span></td>
        </tr>
        <tr>
            <td>Focusing Cylinder</td><td><span class="input-line" style="width:60px;"></span></td>
            <td>Contact Bar</td><td><span class="input-line" style="width:60px;"></span></td>
        </tr>
        <tr>
            <td>Collar Nut</td><td><span class="input-line" style="width:60px;"></span></td>
            <td>Contact Bolt</td><td><span class="input-line" style="width:60px;"></span></td>
        </tr>
        <tr>
            <td>Shielding Ring</td><td><span class="input-line" style="width:60px;"></span></td>
            <td>Ion Collector</td><td><span class="input-line" style="width:60px;"></span></td>
        </tr>
        <tr>
            <td>Contact Piece</td><td><span class="input-line" style="width:60px;"></span></td>
            <td></td><td></td>
        </tr>
    </table>

    <span class="label">Resistance > 6 Mohm (Filament → Solid Cathode Base):</span>
    <span class="input-line" style="width:80px;"></span> Ω

    <span class="label">Filament Resistance:</span><span class="input-line" style="width:80px;"></span> Ω



</asp:Content>
