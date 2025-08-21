using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.Net.Mime.MediaTypeNames;

namespace CathodeWeb
{
    public partial class AddCathode : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnAddCathode_Click(object sender, EventArgs e)
        {
            bool serialtest;
            bool badgetest;
            bool ebtest;
            int sn;
            int badge;
            int eb;

            serialtest = int.TryParse(txtSerial.Text.ToString(), out sn);
            badgetest = int.TryParse(txtBadge.Text.ToString(), out badge);
            ebtest = int.TryParse(txtFurnace.Text.ToString(), out eb);

            //Serial Number Input Checks
            if (txtSerial.Text.Length < 4 && !serialtest)
            {
                lblError.Text = "Please provide a valid Cathode Serial number.";
                lblError.Visible = true;
                return;
            }
            else
                if (GetSerialCount(sn) != 0)
            {
                lblError.Text = "Cathode exists. Confirm the serial number.";
                lblError.Visible = true;
                return;
            }

            //Furnace Input Check
            if (!ebtest || (eb <=1 && eb >=2))
            {
                lblError.Text = "Please enter 1 for EB1 or 2 for EB2.";
                lblError.Visible = true;
                return;
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
                SqlCommand cmd = new SqlCommand("Cathode_Insert", MyConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter TheSerial = cmd.Parameters.Add("@serial", SqlDbType.Int);
                SqlParameter TheFurnace = cmd.Parameters.Add("@furnace", SqlDbType.Int);
                SqlParameter TheBadge = cmd.Parameters.Add("@badge", SqlDbType.Int);


                TheSerial.Value = sn;
                TheFurnace.Value = Convert.ToInt32(txtFurnace.Text);
                TheBadge.Value = badge;

                cmd.ExecuteScalar();

                if (null != cmd)
                    cmd.Dispose();
                if (null != MyConnection)
                    MyConnection.Dispose();

                txtSerial.Text = string.Empty;
                txtFurnace.Text = string.Empty;
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


        public int GetSerialCount(int TheSerialNumber)
        {
            SqlConnection conn = null;
            conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString);
            conn.Open();
            string strSQLCommand = "SELECT Count(SerialNumber) FROM [cathode] Where serialnumber = " + TheSerialNumber;
            SqlCommand command = new SqlCommand(strSQLCommand, conn);
            int returnvalue = (int)command.ExecuteScalar();
            conn.Close();
            return returnvalue;
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


    }
}