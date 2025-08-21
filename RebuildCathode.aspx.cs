using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Collections.Specialized;
using System.IO;
using System.Configuration;
using System.Text.RegularExpressions;

namespace CathodeWeb
{
    public partial class RebuildCathode : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }

        protected void ddlFurnace_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlCathode.DataBind();
        }

        protected void btnRebuild_Click(object sender, EventArgs e)
        {

            bool isotest;
            bool restest;
            bool filtest;
            bool badgetest;
            int iso;
            float res;
            float fil;
            int badge;


            isotest = int.TryParse(txtISO.Text.ToString(), out iso);
            restest = float.TryParse(txtResistance.Text.ToString(), out res);
            filtest = float.TryParse(txtFilament.Text.ToString(), out fil);
            badgetest = int.TryParse(txtBadge.Text.ToString(), out badge);

            //Finding Input Checks
            if (txtISO.Text.Length > 1 && !isotest)
            {
                lblError.Text = "Please provide a valid ISO chamber number.";
                lblError.Visible = true;
                return;
            }
            else if (txtISO.Text.Length > 1 && isotest && (iso >= 1 && iso <= 4))
            {
                lblError.Text = "Please provide a valid ISO chamber number (1 - 4).";
                lblError.Visible = true;
                return;
            }


            //Resitance Ohms Input Checks
            if (chkResistance.Checked && !restest)
            {
                lblError.Text = "If the cathode resistance is checked, an ohm measurement is required.";
                lblError.Visible = true;
                return;
            }

            if (!chkResistance.Checked && restest)
            {
                lblError.Text = "Please check the Filament base resistance checkbox if entering a resistance value.";
                lblError.Visible = true;
                return;
            }


            //Tungsten Variance Input Checks
            if (chkTunVar.Checked && txtTunVar.Text.Length < 5)
            {
                lblError.Text = "If Tungsten Variance is checked, detailed information about the variance is required.";
                lblError.Visible = true;
                return;
            }

            if (!chkTunVar.Checked && txtTunVar.Text.Length > 0)
            {
                lblError.Text = "Please check the Tungsten Variance checkbox if entering variance informatoin.";
                lblError.Visible = true;
                return;
            }


            //Filament Ohms Input Checks
            if (chkFilament.Checked && !filtest)
            {
                lblError.Text = "If the Filament resistance is checked, an ohm measurement is required.";
                lblError.Visible = true;
                return;
            }

            if (!chkFilament.Checked && filtest)
            {
                lblError.Text = "Please check the Filament resistence checkbox if entering a resistance value.";
                lblError.Visible = true;
                return;
            }

            //Complete without all data
            if (chkComplete.Checked)
            {
                if (!isotest || !chkResistance.Checked || !restest || !chkSpacing.Checked || !chkCentered.Checked || !chkTungsten.Checked || !chkFilament.Checked || !filtest)
                {
                    lblError.Text = "Please confirm all required data is input.";
                    lblError.Visible = true;
                    return;
                }
            }

            //Complete Without Parts
            if (chkComplete.Checked)
            {
                if (GetPartCount(Convert.ToInt32(ddlCathode.SelectedValue)) == 0)
                {
                    lblError.Text = "At least one part must be selected to complete the cathode rebuild.";
                    lblError.Visible = true;
                    return;
                }
            }

            //Badge Input Check
            if (!badgetest)
            {
                lblError.Text = "Please provide a valid Badge number.";
                lblError.Visible = true;
                return;
            }
            else
                if (GetBadgeCount(badge) == 0)
            {
                lblError.Text = "Badge number does not exist. Confirm the badge number.";
                lblError.Visible = true;
                return;
            }

            try
            {
                SqlConnection MyConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString);
                MyConnection.Open();
                SqlCommand cmd = new SqlCommand("spRebuildCathodeFinal", MyConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter TheCathode = cmd.Parameters.Add("@cathode", SqlDbType.Int);
                SqlParameter TheID = cmd.Parameters.Add("@historyid", SqlDbType.Int);
                SqlParameter TheBadge = cmd.Parameters.Add("@badge", SqlDbType.Int);
                SqlParameter TheComplete = cmd.Parameters.Add("@rebuildcomplete", SqlDbType.Int);


                TheCathode.Value = ddlCathode.SelectedItem.Text;
                TheID.Value = ddlCathode.SelectedValue;
                TheBadge.Value = badge;
                if (isotest && txtISO.Enabled)
                {
                    SqlParameter TheIso = cmd.Parameters.Add("@iso", SqlDbType.Int);
                    TheIso.Value = iso;
                }
                
                if (chkResistance.Checked && chkResistance.Enabled)
                {
                    SqlParameter TheResistance = cmd.Parameters.Add("@filamentbase", SqlDbType.Bit);
                    SqlParameter TheResistanceValue = cmd.Parameters.Add("@filamentbasevalue", SqlDbType.Float);
                    TheResistance.Value = 1;
                    TheResistanceValue.Value = res;
                }
                if (chkSpacing.Checked && chkSpacing.Enabled)
                {
                    SqlParameter TheSpacing = cmd.Parameters.Add("@spacing", SqlDbType.Bit);
                    TheSpacing.Value = 1;
                }
                if (chkCentered.Checked && chkCentered.Enabled)
                {
                    SqlParameter TheCenter = cmd.Parameters.Add("@center", SqlDbType.Bit);
                    TheCenter.Value = 1;
                }
                if (chkTungsten.Checked && chkTungsten.Enabled)
                {
                    SqlParameter TheTungsten = cmd.Parameters.Add("@tungsten", SqlDbType.Bit);
                    TheTungsten.Value = 1;
                }
                if (chkTunVar.Checked && chkTunVar.Enabled)
                {
                    SqlParameter TheTunVar = cmd.Parameters.Add("@tunvar", SqlDbType.Bit);
                    SqlParameter TheTunVarInfo = cmd.Parameters.Add("@tunvarinfo", SqlDbType.NVarChar, 4000);
                    TheTunVar.Value = 1;
                    TheTunVarInfo.Value = txtTunVar.Text;
                }
                if (chkFilament.Checked && chkFilament.Enabled)
                {
                    SqlParameter TheFilament = cmd.Parameters.Add("@filamentresistance", SqlDbType.Bit);
                    SqlParameter TheFilamentValue = cmd.Parameters.Add("@filamentresistancevalue", SqlDbType.Float);
                    TheFilament.Value = 1;
                    TheFilamentValue.Value = fil;
                }

                if (chkComplete.Checked)
                {
                    TheComplete.Value = 1;
                }
                else
                {
                    TheComplete.Value = 0;
                }



                cmd.ExecuteScalar();

                if (null != cmd)
                    cmd.Dispose();
                if (null != MyConnection)
                    MyConnection.Dispose();

                ddlCathode.DataBind();
                txtBadge.Text = string.Empty;
                chkComplete.Checked = false;    
                lblError.Visible = false;

            }
            catch (Exception ex2)
            {
                string strMessage = ex2.Message;
                lblError.Text = strMessage;
                lblError.Visible = true;
                return;
            }

        }

        public int GetBadgeCount(int TheBadgelNumber)
        {
            SqlConnection conn = null;
            conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString);
            conn.Open();
            string strSQLCommand = "SELECT Count(badge) FROM [users] Where badge = " + TheBadgelNumber;
            SqlCommand command = new SqlCommand(strSQLCommand, conn);
            int returnvalue = (int)command.ExecuteScalar();
            conn.Close();
            return returnvalue;
        }

        public int GetRebuildData(string TheHistoryID)
        {
            
            if (TheHistoryID.Length == 0)
            {
                TheHistoryID = "0";
            }
            
            string query = $@"SELECT MAX(isochamber) as isochamber, SUM(CAST(lathecheck AS INT)) as lathecheck, SUM(CAST(filamentbase AS INT)) as filamentbase,
                MAX(filamentbasevalue) as filamentbasevalue, SUM(CAST(filamentspacing AS INT)) as filamentspacing,
                SUM(CAST(filamentcenter AS INT)) as filamentcenter, SUM(CAST(tungsten AS INT)) as tungsten, SUM(CAST(filamentohm AS INT)) as filamentohm, MAX(filamentohmvalue) as filamentohmvalue,
                SUM(CAST(tungstenvariance AS INT)) as tunvar, MAX(tungstenvarianceinfo) as tungstenvarianceinfo
                FROM rebuilddata 
                WHERE history_id = {TheHistoryID}
                GROUP BY history_id";

            SqlConnection conn = null;
            conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString);
            conn.Open();
            string strSQLCommand = query;
            SqlCommand command = new SqlCommand(strSQLCommand, conn);
            SqlDataReader reader = command.ExecuteReader();

            if (reader.HasRows)
            {
                while (reader.Read())
                {

                    if (reader[0] != System.DBNull.Value)
                    {
                        txtISO.Text = reader[0].ToString();
                        txtISO.Enabled = false;
                    }
                    else
                    {
                        txtISO.Text = String.Empty;
                        txtISO.Enabled = true;
                    }

                    if (reader[2] != System.DBNull.Value)
                    {
                        chkResistance.Checked = true;
                        chkResistance.Enabled = false;
                        txtResistance.Text = reader[3].ToString();
                        txtResistance.Enabled = false;
                    }
                    else
                    {
                        chkResistance.Checked = false;
                        chkResistance.Enabled = true;
                        txtResistance.Text = string.Empty;
                        txtResistance.Enabled = true;
                    }

                    if (reader[4] != System.DBNull.Value)
                    {
                        chkSpacing.Checked = true;
                        chkSpacing.Enabled = false;
                    }
                    else
                    {
                        chkSpacing.Checked = false;
                        chkSpacing.Enabled = true;
                    }

                    if (reader[5] != System.DBNull.Value)
                    {
                        chkCentered.Checked = true;
                        chkCentered.Enabled = false;
                    }
                    else
                    {
                        chkCentered.Checked = false;
                        chkCentered.Enabled = true;

                    }

                    if (reader[6] != System.DBNull.Value)
                    {
                        chkTungsten.Checked = true;
                        chkTungsten.Enabled = false;
                    }
                    else
                    {
                        chkTungsten.Checked = false;
                        chkTungsten.Enabled = true;
                    }

                    if (reader[7] != System.DBNull.Value)
                    {
                        chkFilament.Checked = true;
                        chkFilament.Enabled = false;
                        txtFilament.Text = reader[8].ToString();
                        txtFilament.Enabled = false;
                    }
                    else
                    {
                        chkFilament.Checked = false;
                        chkFilament.Enabled = true;
                        txtFilament.Text = string.Empty;
                        txtFilament.Enabled = true;
                    }
                    if (reader[9] != System.DBNull.Value)
                    {
                        chkTunVar.Checked = true;
                        chkTunVar.Enabled = false;
                        txtTunVar.Text = reader[10].ToString();
                        txtTunVar.Enabled = false;
                    }
                    else
                    {
                        chkTunVar.Checked = false;
                        chkTunVar.Enabled = true;
                        txtTunVar.Text = string.Empty;
                        txtTunVar.Enabled = true;
                    }

                }
            }
            else
            {
                txtISO.Text = string.Empty;
                txtISO.Enabled = true;
                chkResistance.Checked = false;
                chkResistance.Enabled=true; 
                txtResistance.Text = string.Empty;  
                txtResistance.Enabled=true;
                chkSpacing.Checked = false;
                chkSpacing.Enabled = true;
                chkCentered.Checked = false;
                chkCentered.Enabled = true;
                chkTungsten.Checked = false;    
                chkTungsten.Enabled = true;
                chkTunVar.Checked = false;
                chkTunVar.Enabled = true;
                txtTunVar.Text = string.Empty;
                txtTunVar.Enabled = true;
                chkFilament.Checked = false;
                chkFilament.Enabled = true;
                txtFilament.Text = string.Empty;
                txtFilament.Enabled = true;

            }

            reader.Close();
            conn.Close();

            return 0;

        }

        protected void ddlCathode_DataBound(object sender, EventArgs e)
        {
            int dummy = GetRebuildData(ddlCathode.SelectedValue.ToString());
            lblError.Visible = false;
        }

        protected void ddlCathode_SelectedIndexChanged(object sender, EventArgs e)
        {
            int dummy = GetRebuildData(ddlCathode.SelectedValue.ToString());
            lblError.Visible = false;
        }

        public int GetPartCount(int TheHistoryID)
        {
            SqlConnection conn = null;
            conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString);
            conn.Open();
            string strSQLCommand = "SELECT Count(history_id) FROM [parthistory] Where history_id = " + TheHistoryID;
            SqlCommand command = new SqlCommand(strSQLCommand, conn);
            int returnvalue = (int)command.ExecuteScalar();
            conn.Close();
            return returnvalue;
        }
    }
}