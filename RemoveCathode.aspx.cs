using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CathodeWeb
{
    public partial class RemoveCathode : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ddlFurnace_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlGuns.DataBind();
        }

        protected void ddlGuns_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlGuns.Items.Count > 0)
            {
                txtCathode.Text = ddlGuns.SelectedValue.ToString();
                txtRemove.Text = string.Empty;
                txtHVTimer.Text = string.Empty;
                txtTotalHV.Text = string.Empty;
                string theID = ddlGuns.SelectedItem.Text;
                txtGunID.Text = GetGunID(theID, ddlFurnace.SelectedValue.ToString()).ToString();
            }
            else
            {
                txtCathode.Text = string.Empty;
                txtRemove.Text = string.Empty;
                txtHVTimer.Text = string.Empty;
                txtTotalHV.Text = string.Empty;
            }

        }

        protected void ddlGuns_DataBound(object sender, EventArgs e)
        {
            if (ddlGuns.Items.Count > 0)
            {
                txtCathode.Text = ddlGuns.SelectedValue.ToString();
                string theID = ddlGuns.SelectedItem.Text;
                txtGunID.Text = GetGunID(theID, ddlFurnace.SelectedValue.ToString()).ToString();
            }
            else
            {
                txtCathode.Text = string.Empty;
                txtRemove.Text = string.Empty;
                txtHVTimer.Text = string.Empty;
                txtTotalHV.Text = string.Empty;
            }

        }

        protected void btnRemove_Click(object sender, EventArgs e)
        {
            bool timertest;
            bool hvtimetest;
            bool badgetest;
            //bool uppertest;
            bool arctest;
            bool matest;
            bool traineetest;
            int timer;
            int badge;
            int hv;
            //float upper;
            float arc;
            float ma;
            int train;

            int removal_id = 0;
            int removal_id2 = 0;
            int removal_id3 = 0;
            int checkcounter = 0;

            timertest = int.TryParse(txtTotalHV.Text.ToString(), out timer);
            badgetest = int.TryParse(txtBadge.Text.ToString(), out badge);
            hvtimetest = int.TryParse(txtHVTimer.Text.ToString(), out hv);
            //uppertest = float.TryParse(txtUpper.Text.ToString(),out upper);
            arctest = float.TryParse(txtArcKV.Text.ToString(), out arc);
            matest = float.TryParse(txtLow.Text.ToString(), out ma);
            traineetest = int.TryParse(txtTrainee.Text.ToString(), out train);


            /*
            //Campaign Input Check
            if (txtCampaign.Text.Length < 5)
            {
                lblError.Text = "Please provide a valid Campaign number.";
                lblError.Visible = true;
                return;
            }
            */

            //Install Time Input Check
            if (txtRemove.Text.Length < 5)
            {
                lblError.Text = "Please provide a valid time value.";
                lblError.Visible = true;
                return;
            }

            string regpattern = @"^([0-2][0-3]|[0-1][0-9]):[0-5][0-9]+$";
            bool hhmm_Match = Regex.IsMatch(txtRemove.Text, regpattern, RegexOptions.IgnoreCase);

            string regpatternfull = @"[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) (2[0-3]|[01][0-9]):[0-5][0-9]";
            bool full_Match = Regex.IsMatch(txtRemove.Text, regpatternfull, RegexOptions.IgnoreCase);

            if (txtRemove.Text.Length == 5)
            {
                if (!hhmm_Match)
                {
                    lblError.Text = "Please check your time input.  It should be 24H format with leading zeros.";
                    lblError.Visible = true;
                    return;
                }
            }

            if (txtRemove.Text.Length > 5)
            {
                if (!full_Match)
                {
                    lblError.Text = "Please check your time input.  It should be YYYY-MM-DDD hh:mm format with leading zeros, 2025-01-01 00:00.";
                    lblError.Visible = true;
                    return;
                }
            }

            //High Voltage Timer CHeck
            if (!timertest)
            {
                lblError.Text = "Please provide a valid High Voltage Timer input.";
                lblError.Visible = true;
                return;
            }

            //Upper Clean Check
            if (ddlUs.SelectedIndex == 0)
            {
                lblError.Text = "Please select yes or no for Us 1400 Stable.";
                lblError.Visible = true;
                return;
            }

            /*
            //Gun Rod Check Check
            if (ddlRods.SelectedIndex == 0)
            {
                lblError.Text = "Please confirm the Gun rods have been inspected.";
                lblError.Visible = true;
                return;
            }
            */

            /*
            //Upper Chamber Vac CHeck
            if (!uppertest)
            {
                lblError.Text = "Please provide a valid Upper Chamber Vacuum input.";
                lblError.Visible = true;
                return;
            }
            */

            //Set the removal reason
            if (chkTime.Checked)
            {
                removal_id = 1;
                checkcounter++;
            }

            if (chkNoMA.Checked)
            {
                if (checkcounter == 0)
                {
                    removal_id = 1002;
                    checkcounter++;
                }
                else if (checkcounter == 1)
                {
                    removal_id2 = 1002;
                    checkcounter++;
                }
            }

            if (chkArc.Checked)
            {

                if (checkcounter == 0)
                {
                    removal_id = 3;
                    checkcounter++;
                }
                else if (checkcounter == 1)
                {
                    removal_id2 = 3;
                    checkcounter++;
                }
                else if (checkcounter == 2)
                {
                    removal_id3 = 3;
                    checkcounter++;
                }

                if (!arctest)
                {
                    lblError.Text = "Please provide a valid Arcing kV input.";
                    lblError.Visible = true;
                    return;
                }
            }

            if (chkTemp.Checked)
            {
                if (checkcounter == 0)
                {
                    removal_id = 4;
                    checkcounter++;
                }
                else if (checkcounter == 1)
                {
                    removal_id2 = 4;
                    checkcounter++;
                }
                else if (checkcounter == 2)
                {
                    removal_id3 = 4;
                    checkcounter++;
                }
                else if (checkcounter >= 3)
                {
                    checkcounter++;
                }
            }

            if (chkUf.Checked)
            {
                if (checkcounter == 0)
                {
                    removal_id = 5;
                    checkcounter++;
                }
                else if (checkcounter == 1)
                {
                    removal_id2 = 5;
                    checkcounter++;
                }
                else if (checkcounter == 2)
                {
                    removal_id3 = 5;
                    checkcounter++;
                }
                else if (checkcounter >= 3)
                {
                    checkcounter++;
                }
            }

            if (chkAlign.Checked)
            {
                if (checkcounter == 0)
                {
                    removal_id = 6;
                    checkcounter++;
                }
                else if (checkcounter == 1)
                {
                    removal_id2 = 6;
                    checkcounter++;
                }
                else if (checkcounter == 2)
                {
                    removal_id3 = 6;
                    checkcounter++;
                }
                else if (checkcounter >= 3)
                {
                    checkcounter++;
                }
            }

            if (chkOther.Checked)
            {
                if (checkcounter == 0)
                {
                    removal_id = 7;
                    checkcounter++;
                }
                else if (checkcounter == 1)
                {
                    removal_id2 = 7;
                    checkcounter++;
                }
                else if (checkcounter == 2)
                {
                    removal_id3 = 7;
                    checkcounter++;
                }
                else if (checkcounter >= 3)
                {
                    checkcounter++;
                }

                if (txtOther.Text.Length < 5)
                {
                    lblError.Text = "Please provide at least 5 characters describing the reason for cathode removal.";
                    lblError.Visible = true;
                    return;
                }
            }

            if (chkLow.Checked)
            {
                if (checkcounter == 0)
                {
                    removal_id = 2;
                    checkcounter++;
                }
                else if (checkcounter == 1)
                {
                    removal_id2 = 2;
                    checkcounter++;
                }
                else if (checkcounter == 2)
                {
                    removal_id3 = 2;
                    checkcounter++;
                }
                else if (checkcounter >= 3)
                {
                    checkcounter++;
                }

                if (!matest)
                {
                    lblError.Text = "Please provide a valid Low MA input.";
                    lblError.Visible = true;
                    return;
                }
            }

            if (chkUnstable.Checked)
            {
                if (checkcounter == 0)
                {
                    removal_id = 1003;
                    checkcounter++;
                }
                else if (checkcounter == 1)
                {
                    removal_id2 = 1003;
                    checkcounter++;
                }
                else if (checkcounter == 2)
                {
                    removal_id3 = 1003;
                    checkcounter++;
                }
                else if (checkcounter >= 3)
                {
                    checkcounter++;
                }
            }

            if (checkcounter > 3)
            {
                lblError.Text = "Please only check up to three removal reasons.";
                lblError.Visible = true;
                return;
            }

            if (checkcounter < 1)
            {
                lblError.Text = "Please check one removal reason.";
                lblError.Visible = true;
                return;
            }

            //Trainee Input Check
            if (txtTrainee.Text.Length > 0)
            {
                if (!traineetest)
                {
                    lblError.Text = "Please provide a valid Employee number for the Trainee.";
                    lblError.Visible = true;
                    return;
                }
                else
                    if (GetBadgeCount(train) == 0)
                {
                    lblError.Text = "Employee number does not exist. Confirm the Employee number of Trainee.";
                    lblError.Visible = true;
                    return;
                }
            }

            //Badge Input Check
            if (!badgetest)
            {
                lblError.Text = "Please provide a valid Employee number.";
                lblError.Visible = true;
                return;
            }
            else
                if (GetBadgeCount(badge) == 0)
            {
                lblError.Text = "Employee number does not exist. Confirm the Employee number.";
                lblError.Visible = true;
                return;
            }

            try
            {
                SqlConnection MyConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString);
               
                MyConnection.Open();
                SqlCommand cmd = new SqlCommand("spRemoveCathode", MyConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter TheCathode = cmd.Parameters.Add("@cathode", SqlDbType.Int);
                SqlParameter TheBadge = cmd.Parameters.Add("@badge", SqlDbType.Int);
                SqlParameter TheCampaign = cmd.Parameters.Add("@campaign", SqlDbType.NVarChar, 20);
                SqlParameter TheTimer = cmd.Parameters.Add("@hours", SqlDbType.Int);
                SqlParameter TheHVTimer = cmd.Parameters.Add("@hvtimer", SqlDbType.Int);
                SqlParameter TheUs = cmd.Parameters.Add("@us", SqlDbType.Bit);
                SqlParameter TheUpper = cmd.Parameters.Add("@uppervac", SqlDbType.Real);
                SqlParameter TheRemoval = cmd.Parameters.Add("@removaltype", SqlDbType.Int);
                SqlParameter TheRemoval2 = cmd.Parameters.Add("@removaltype2", SqlDbType.Int);
                SqlParameter TheRemoval3 = cmd.Parameters.Add("@removaltype3", SqlDbType.Int);
                SqlParameter TheRemoveTime = cmd.Parameters.Add("@removaltime", SqlDbType.NVarChar, 20);
                SqlParameter TheArc = cmd.Parameters.Add("@arcing", SqlDbType.Real);
                SqlParameter TheOther = cmd.Parameters.Add("@otherinfo", SqlDbType.NVarChar, 4000);
                SqlParameter TheLow = cmd.Parameters.Add("@low_ma", SqlDbType.Real);
                SqlParameter TheTrainee = cmd.Parameters.Add("@trainee", SqlDbType.Int);
                SqlParameter TheRods = cmd.Parameters.Add("@rod", SqlDbType.Bit);
                SqlParameter TheGunId = cmd.Parameters.Add("@gunid", SqlDbType.Int);



                TheCathode.Value = txtCathode.Text;
                TheBadge.Value = badge;
                TheTimer.Value = timer;
                TheHVTimer.Value = hv;
                TheUs.Value = int.Parse(ddlUs.SelectedValue);
                TheUpper.Value = 0;
                TheRemoveTime.Value = txtRemove.Text;
                TheCampaign.Value = "N/A";
                //TheRods.Value = int.Parse(ddlRods.SelectedValue);
                TheRods.Value = 0;
                TheGunId.Value = int.Parse(txtGunID.Text);  

                if (txtTrainee.Text.Length > 0)
                {
                    TheTrainee.Value = train;
                }
                

                switch (removal_id)
                {
                    case 1:
                        TheRemoval.Value = removal_id;
                        break;
                    case 2:
                        TheRemoval.Value = removal_id;
                        TheLow.Value = ma;
                        break;
                    case 3:
                        TheRemoval.Value = removal_id;
                        TheArc.Value = arc; 
                        break;
                    case 4:
                        TheRemoval.Value = removal_id;
                        break;
                    case 5:
                        TheRemoval.Value = removal_id;
                        break;
                    case 6:
                        TheRemoval.Value = removal_id;
                        break;
                    case 7:
                        TheRemoval.Value = removal_id;
                        TheOther.Value = txtOther.Text; 
                        break;
                    case 1002:
                        TheRemoval.Value = removal_id;
                        break;
                    case 1003:
                        TheRemoval.Value = removal_id;
                        break;

                }

                switch (removal_id2)
                {
                    case 1:
                        TheRemoval2.Value = removal_id2;
                        break;
                    case 2:
                        TheRemoval2.Value = removal_id2;
                        TheLow.Value = ma;
                        break;
                    case 3:
                        TheRemoval2.Value = removal_id2;
                        TheArc.Value = arc;
                        break;
                    case 4:
                        TheRemoval2.Value = removal_id2;
                        break;
                    case 5:
                        TheRemoval2.Value = removal_id2;
                        break;
                    case 6:
                        TheRemoval2.Value = removal_id2;
                        break;
                    case 7:
                        TheRemoval2.Value = removal_id2;
                        TheOther.Value = txtOther.Text;
                        break;
                    case 1002:
                        TheRemoval2.Value = removal_id2;
                        break;
                    case 1003:
                        TheRemoval2.Value = removal_id2;
                        break;

                }

                switch (removal_id3)
                {
                    case 1:
                        TheRemoval3.Value = removal_id3;
                        break;
                    case 2:
                        TheRemoval3.Value = removal_id3;
                        TheLow.Value = ma;
                        break;
                    case 3:
                        TheRemoval3.Value = removal_id3;
                        TheArc.Value = arc;
                        break;
                    case 4:
                        TheRemoval3.Value = removal_id3;
                        break;
                    case 5:
                        TheRemoval3.Value = removal_id3;
                        break;
                    case 6:
                        TheRemoval3.Value = removal_id3;
                        break;
                    case 7:
                        TheRemoval3.Value = removal_id3;
                        TheOther.Value = txtOther.Text;
                        break;
                    case 1002:
                        TheRemoval3.Value = removal_id3;
                        break;
                    case 1003:
                        TheRemoval3.Value = removal_id3;
                        break;

                }


                cmd.ExecuteScalar();

                if (null != cmd)
                    cmd.Dispose();
                if (null != MyConnection)
                    MyConnection.Dispose();

                ddlGuns.DataBind(); 
                txtUpper.Text= string.Empty;
                ddlUs.SelectedIndex = 0;
                ddlRods.SelectedIndex = 0;  
                txtTotalHV.Text = string.Empty;
                txtHVTimer.Text = string.Empty;
                txtRemove.Text = string.Empty;
                //txtCampaign.Text = string.Empty;
                chkTime.Checked = false;    
                chkTemp.Checked = false;    
                chkNoMA.Checked = false;    
                chkAlign.Checked = false;   
                chkArc.Checked = false; 
                chkLow.Checked = false;
                chkOther.Checked = false;   
                chkUf.Checked = false;  
                chkUnstable.Checked = false;
                txtOther.Text = string.Empty;
                txtArcKV.Text = string.Empty;
                txtLow.Text = string.Empty;
                
                txtBadge.Text = string.Empty;
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

        protected void btnTimer_Click(object sender, EventArgs e)
        {
            if (txtRemove.Text.Length < 5)
            {
                lblError.Text = "Please provide a valid time value.";
                lblError.Visible = true;
                return;
            }

            string regpattern = @"^([0-2][0-3]|[0-1][0-9]):[0-5][0-9]+$";
            bool hhmm_Match = Regex.IsMatch(txtRemove.Text, regpattern, RegexOptions.IgnoreCase);

            string regpatternfull = @"[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) (2[0-3]|[01][0-9]):[0-5][0-9]";
            bool full_Match = Regex.IsMatch(txtRemove.Text, regpatternfull, RegexOptions.IgnoreCase);

            string dateBuilder = String.Empty;


            if (txtRemove.Text.Length > 5)
            {
                if (!full_Match)
                {
                    lblError.Text = "Please check your time input.  It should be YYYY-MM-DDD hh:mm format with leading zeros, 2025-01-01 00:00.";
                    lblError.Visible = true;
                    return;
                }
                else
                {
                    dateBuilder = txtRemove.Text;
                }
            }

            if (txtRemove.Text.Length == 5)
            {
                if (!hhmm_Match)
                {
                    lblError.Text = "Please check your time input.  It should be 24H format with leading zeros.";
                    lblError.Visible = true;
                    return;
                }
                else
                {
                    //dateBuilder = DateTime.Today.ToString("yyyy-MM-dd") + " " + txtRemove.Text;
                    string theDate = clientDate.Value;  // "yyyy-MM-dd"
                    dateBuilder = theDate + " " + txtRemove.Text;
                    txtRemove.Text = dateBuilder;
                }
            }


            int FurnaceValue = int.Parse(ddlFurnace.SelectedValue);

            int hvTime = GetHVTime(ddlGuns.SelectedItem.ToString(), dateBuilder, FurnaceValue);
            int hvInstall = GetHVInstall(int.Parse(txtCathode.Text));


            txtHVTimer.Text = hvTime.ToString();
            txtTotalHV.Text = (hvTime - hvInstall).ToString();   


            lblError.Text = String.Empty;
            lblError.Visible = false;
        }

        public int GetHVTime(string TheGun, string TheRemoveTime, int TheFurnace)
        {
            string gunTag = "Gun" + TheGun.Substring(TheGun.Length -1) + "Time";

            string strSQLCommand;


            SqlConnection conn = null;
            conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString);
            conn.Open();
            if (TheFurnace == 1)
            {
                strSQLCommand = "SELECT TOP 1 " + gunTag + " FROM EB1HVTimer WHERE HVTimerDate <= '" + TheRemoveTime + "' ORDER BY HVTimerDate DESC";
            }
            else
            {
                strSQLCommand = "SELECT TOP 1 CAST(ROUND(" + gunTag + ", 0) AS int) FROM EB2HVTimer WHERE HVTimerDate <= '" + TheRemoveTime + "' ORDER BY HVTimerDate DESC";
            }
                SqlCommand command = new SqlCommand(strSQLCommand, conn);
            object returnvalue = command.ExecuteScalar();
            conn.Close();

            if (returnvalue != null)
            {
                return int.Parse(returnvalue.ToString());
            }
            else 
            {
                return 0;
            }
        }

        public int GetHVInstall(int TheCathode)
        {
            
            SqlConnection conn = null;
            conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString);
            conn.Open();
            string strSQLCommand = "SELECT i.volttimer FROM vwCathodeStatus s INNER JOIN installdata i ON i.history_id = s.id WHERE s.status_id = 1 AND s.cathode_number = " + TheCathode;
            SqlCommand command = new SqlCommand(strSQLCommand, conn);
            object returnvalue = command.ExecuteScalar();
            conn.Close();

            if (returnvalue != null)
            {
                return int.Parse(returnvalue.ToString());
            }
            else
            {
                return 0;
            }
        }

        public int GetGunID(string TheGun, string TheFurnace)
        {

            SqlConnection conn = null;
            conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString);
            conn.Open();
            string strSQLCommand = "SELECT gun_id FROM vwEBCathodesInUse WHERE Gun_Number = '" + TheGun + "' AND Furnace = " + TheFurnace;
            SqlCommand command = new SqlCommand(strSQLCommand, conn);
            object returnvalue = command.ExecuteScalar();
            conn.Close();

            if (returnvalue != null)
            {
                return int.Parse(returnvalue.ToString());
            }
            else
            {
                return 0;
            }
        }








    }
}