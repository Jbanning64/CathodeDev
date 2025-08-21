using System;
using System.Collections.Generic;
using System.Configuration;
using Microsoft.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.Data;
using System.Diagnostics;

namespace CathodeWeb
{
    public partial class InstallCathode : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ddlFurnace_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlCathode.DataBind();  
        }

        protected void btnInstall_Click(object sender, EventArgs e)
        {
            bool timertest;
            bool badgetest;
            bool traineetest;
            int timer;
            int badge;
            int train;

            timertest = int.TryParse(txtTimer.Text.ToString(), out timer);
            badgetest = int.TryParse(txtBadge.Text.ToString(), out badge);
            traineetest = int.TryParse(txtTrainee.Text.ToString(), out train);

            //Campaign Input Check
            if (txtCampaign.Text.Length < 5)
            {
                lblError.Text = "Please provide a valid Campaign number.";
                lblError.Visible = true;
                return;
            }

            //Install Time Input Check
            if (txtInstall.Text.Length < 5)
            {
                lblError.Text = "Please provide a valid time value.";
                lblError.Visible = true;
                return;
            }

            string regpattern = @"^([0-2][0-3]|[0-1][0-9]):[0-5][0-9]+$";
            bool hhmm_Match = Regex.IsMatch(txtInstall.Text,regpattern, RegexOptions.IgnoreCase);

            string regpatternfull = @"[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) (2[0-3]|[01][0-9]):[0-5][0-9]";
            bool full_Match = Regex.IsMatch(txtInstall.Text, regpatternfull, RegexOptions.IgnoreCase);

            if (txtInstall.Text.Length == 5)
            {
                if (!hhmm_Match)
                {
                    lblError.Text = "Please check your time input.  It should be 24H format with leading zeros.";
                    lblError.Visible = true;
                    return;
                }
            }

            if (txtInstall.Text.Length > 5)
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

            //Torque CHeck
            if (ddlTorque.SelectedIndex == 0)
            {
                lblError.Text = "Please confirm the Torque statement.";
                lblError.Visible = true;
                return;
            }

            //Gun Rod Check Check
            if (ddlRods.SelectedIndex == 0)
            {
                lblError.Text = "Please confirm the Gun rods have been inspected.";
                lblError.Visible = true;
                return;
            }

            //Empty Gun dropdown check
            if (ddlGuns.Items.Count == 0)
            {
                lblError.Text = "No Guns available for installation.";
                lblError.Visible = true;
                return;
            }

            //Upper Clean Check
            if (ddlUpper.SelectedIndex == 0)
            {
                lblError.Text = "Please select yes or no for upper chamber clean.";
                lblError.Visible = true;
                return;
            }

            //Trainee Input Check
            if (txtTrainee.Text.Length > 0)
            {
                if (!traineetest)
                {
                    lblError.Text = "Please provide a valid Badge number for the Trainee.";
                    lblError.Visible = true;
                    return;
                }
                else
                    if (GetBadgeCount(train) == 0)
                {
                    lblError.Text = "Badge number does not exist. Confirm the badge number of Trainee.";
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
                SqlCommand cmd = new SqlCommand("spInstallCathode", MyConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter TheCathode = cmd.Parameters.Add("@cathode", SqlDbType.Int);
                SqlParameter TheGun = cmd.Parameters.Add("@gunid", SqlDbType.Int);
                SqlParameter TheBadge = cmd.Parameters.Add("@badge", SqlDbType.Int);
                SqlParameter TheTimer = cmd.Parameters.Add("@timer", SqlDbType.Int);
                SqlParameter TheChamber = cmd.Parameters.Add("@chamber", SqlDbType.Bit);
                SqlParameter TheInstall = cmd.Parameters.Add("@installtime", SqlDbType.NVarChar, 20);
                SqlParameter TheTorque = cmd.Parameters.Add("@torque", SqlDbType.Bit);
                SqlParameter TheCampaign = cmd.Parameters.Add("@campaign", SqlDbType.NVarChar, 20);
                SqlParameter TheRods = cmd.Parameters.Add("@rod", SqlDbType.Bit);
                SqlParameter TheTrainee = cmd.Parameters.Add("@trainee", SqlDbType.Int);


                TheCathode.Value = ddlCathode.SelectedItem.Text;
                TheGun.Value = ddlGuns.SelectedValue;
                TheBadge.Value = badge;
                TheTimer.Value = txtTimer.Text;
                TheChamber.Value = int.Parse(ddlUpper.SelectedValue);
                TheTorque.Value = int.Parse(ddlTorque.SelectedValue);
                TheInstall.Value = txtInstall.Text; 
                TheCampaign.Value = txtCampaign.Text;
                TheRods.Value = int.Parse(ddlRods.SelectedValue);
                if (txtTrainee.Text.Length > 0)
                {
                    TheTrainee.Value = train;
                }

                cmd.ExecuteScalar();

                if (null != cmd)
                    cmd.Dispose();
                if (null != MyConnection)
                    MyConnection.Dispose();

                ddlCathode.DataBind();
                ddlGuns.DataBind();
                ddlTorque.SelectedIndex = 0;
                ddlUpper.SelectedIndex = 0; 
                ddlRods.SelectedIndex = 0;      
                txtTimer.Text = string.Empty;
                txtInstall.Text = string.Empty;
                txtCampaign.Text = string.Empty;    
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
            if (txtInstall.Text.Length < 5)
            {
                lblError.Text = "Please provide a valid time value.";
                lblError.Visible = true;
                return;
            }

            string regpattern = @"^([0-2][0-3]|[0-1][0-9]):[0-5][0-9]+$";
            bool hhmm_Match = Regex.IsMatch(txtInstall.Text, regpattern, RegexOptions.IgnoreCase);

            string regpatternfull = @"[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) (2[0-3]|[01][0-9]):[0-5][0-9]";
            bool full_Match = Regex.IsMatch(txtInstall.Text, regpatternfull, RegexOptions.IgnoreCase);

            string dateBuilder = String.Empty;

            if (txtInstall.Text.Length == 5)
            {
                if (!hhmm_Match)
                {
                    lblError.Text = "Please check your time input.  It should be 24H format with leading zeros.";
                    lblError.Visible = true;
                    return;
                }
                else
                {
                    dateBuilder = DateTime.Today.ToString("yyyy-MM-dd") + " " + txtInstall.Text;
                }
            }

            if (txtInstall.Text.Length > 5)
            {
                if (!full_Match)
                {
                    lblError.Text = "Please check your time input.  It should be YYYY-MM-DDD hh:mm format with leading zeros, 2025-01-01 00:00.";
                    lblError.Visible = true;
                    return;
                }
                else
                {
                    dateBuilder = txtInstall.Text;
                }
            }

            if (ddlGuns.Items.Count == 0)
            {
                lblError.Text = "No Guns available for installation.";
                lblError.Visible = true;
                return;
            }


            int gunNumber = int.Parse(ddlGuns.SelectedValue.ToString());

            int hvTime = GetHVTime(gunNumber, dateBuilder);

            txtTimer.Text = hvTime.ToString();  

            lblError.Text = String.Empty;
            lblError.Visible = false;
           
        }

        public int GetHVTime(int TheGun, string TheInstallTime)
        {
            string gunTag = "Gun" + TheGun.ToString() + "Time";
                        
            SqlConnection conn = null;
            conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString);
            conn.Open();
            string strSQLCommand = "SELECT TOP 1" + gunTag + " FROM EB1HVTimer WHERE HVTimerDate <= '" + TheInstallTime + "' ORDER BY HVTimerDate DESC";
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