using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CathodeWeb
{
    public partial class RebuildParts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ddlFurnace_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlCathode.DataBind();
        }

        protected void ddlCathode_DataBound(object sender, EventArgs e)
        {

        }

        protected void ddlCathode_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void btnAddPart_Click(object sender, EventArgs e)
        {
            bool parttest;
            bool badgetest;
            int part;
            int badge;


            parttest = int.TryParse(txtCount.Text.ToString(), out part);
            badgetest = int.TryParse(txtBadge.Text.ToString(), out badge);

            //Part Count Checks
            if (!parttest)
            {
                lblError.Text = "Please provide a number for the part count.";
                lblError.Visible = true;
                return;
            }
            else if (parttest && (part < 1 || part > 20))
            {
                lblError.Text = "Please provide a valid part count.";
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
                SqlCommand cmd = new SqlCommand("spRebuildParts", MyConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter TheID = cmd.Parameters.Add("@historyid", SqlDbType.Int);
                SqlParameter TheBadge = cmd.Parameters.Add("@badge", SqlDbType.Int);
                SqlParameter ThePart = cmd.Parameters.Add("@partid", SqlDbType.Int);
                SqlParameter TheCount = cmd.Parameters.Add("@partcount", SqlDbType.Int);

                TheID.Value = ddlCathode.SelectedValue;
                TheBadge.Value = badge;
                ThePart.Value = ddlParts.SelectedValue;
                TheCount.Value = part;


                cmd.ExecuteScalar();

                if (null != cmd)
                    cmd.Dispose();
                if (null != MyConnection)
                    MyConnection.Dispose();

                ddlCathode.DataBind();
                grdPartList.DataBind();
                txtCount.Text = string.Empty;
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

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            bool badgetest;
            int badge;


            badgetest = int.TryParse(txtBadge.Text.ToString(), out badge);

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



            int rowind = ((GridViewRow)(sender as Control).NamingContainer).RowIndex;   
            int partID = Convert.ToInt32(grdPartList.DataKeys[rowind].Values[0]);

            SqlConnection conn = null;
            conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString);
            conn.Open();
            string strSQLCommand = "DELETE FROM parthistory WHERE id = " + partID;
            SqlCommand command = new SqlCommand(strSQLCommand, conn);
            command.ExecuteNonQuery();
            conn.Close();

            grdPartList.DataBind(); 

        }
    }
}