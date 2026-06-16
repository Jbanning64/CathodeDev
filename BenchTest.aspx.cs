using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CathodeWeb
{
    public partial class BenchTest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnBench_Click(object sender, EventArgs e)
        {
            bool filtest;
            bool uftest;
            bool ustest;
            bool megtest;
            bool badgetest;
            float fil;
            float uf;
            float us;
            float meg;
            int badge;


            filtest = float.TryParse(txtFilOhms.Text.ToString(), out fil);
            uftest = float.TryParse(txtUfOhms.Text.ToString(), out uf);
            ustest = float.TryParse(txtUsOhms.Text.ToString(), out us);
            megtest = float.TryParse(txtMeg.Text.ToString(), out meg);
            badgetest = int.TryParse(txtBadge.Text.ToString(), out badge);

            //Finding Input Checks
            if (txtBench.Text.Length < 1)
            {
                lblError.Text = "Please provide bench findings.";
                lblError.Visible = true;
                return;
            }


            //Filament Input Checks
            if (chkIntact.Checked && !filtest)
            {
                lblError.Text = "If the filament is intact, an ohm measurement is required.";
                lblError.Visible = true;
                return;
            }
            

            //Uf-base Input Check
            if (!uftest)
            {
                lblError.Text = "Please provide a valid Mega Ohms value for Uf-base.";
                lblError.Visible = true;
                return;
            }

            //Us-base Input Check
            if (!ustest)
            {
                lblError.Text = "Please provide a valid Mega Ohms value for Us-base.";
                lblError.Visible = true;
                return;
            }

            //Megohm Input Check
            if (!megtest)
            {
                lblError.Text = "Please provide a valid Mega Ohms value for Megohmmeter.";
                lblError.Visible = true;
                return;
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
                SqlCommand cmd = new SqlCommand("spRebuildCathodeBenchTest", MyConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter TheCathode = cmd.Parameters.Add("@cathode", SqlDbType.Int);
                SqlParameter TheBadge = cmd.Parameters.Add("@badge", SqlDbType.Int);
                SqlParameter TheFinding = cmd.Parameters.Add("@findings", SqlDbType.NVarChar, 4000);
                SqlParameter TheFilament = cmd.Parameters.Add("@intact", SqlDbType.Bit);
                SqlParameter TheFilOhm = cmd.Parameters.Add("@filament", SqlDbType.Real);
                SqlParameter TheUf = cmd.Parameters.Add("@ufbase", SqlDbType.Real);
                SqlParameter TheUs = cmd.Parameters.Add("@usbase", SqlDbType.Real);
                SqlParameter TheMeg = cmd.Parameters.Add("@meg", SqlDbType.Real);


                TheCathode.Value = ddlCathode.SelectedValue;
                TheBadge.Value = badge;
                TheFinding.Value = txtBench.Text;
                TheFilament.Value = chkIntact.Checked;
                if (!filtest)
                {
                    TheFilOhm.Value = 0;
                }
                else
                {
                    TheFilOhm.Value = fil;
                }
                TheUf.Value = uf;
                TheUs.Value = us;
                TheMeg.Value = meg;


                cmd.ExecuteScalar();

                if (null != cmd)
                    cmd.Dispose();
                if (null != MyConnection)
                    MyConnection.Dispose();

                ddlCathode.DataBind();
                chkIntact.Checked = false;
                txtBench.Text = string.Empty;
                txtFilOhms.Text = string.Empty;
                txtUfOhms.Text = string.Empty;
                txtUsOhms.Text = string.Empty;
                txtMeg.Text = string.Empty;
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

        protected void ddlFurnace_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlCathode.DataBind();
        }

        protected void btnPrintCathode_Click(object sender, EventArgs e)
        {
            string gun = "";
            string hvtime = "";
            string cathode = ddlCathode.SelectedItem.ToString();

            string sql = "SELECT 'EB' + CAST(c.furnace AS varchar(1)) +  ' Gun ' + CAST(e.number as varchar(1)) AS GunNumber, r1.totalhours " +
                "FROM vwCathodeStatus h " +
                "INNER JOIN removaldata1 r1 " +
                "ON r1.history_id = h.id " +
                "INNER JOIN cathode c " +
                "ON c.serialnumber = h.cathode_number " +
                "INNER JOIN ebguns e " +
                "ON e.id = h.gun_id " +
                "WHERE h.cathode_number = " + cathode + " " +
                "AND (h.status_id = 2 OR h.status_id = 3)";


            SqlConnection conn = null;
            conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString);
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                conn.Open();
                SqlDataReader r = cmd.ExecuteReader();

                if (r.Read())
                {
                    gun = r["GunNumber"].ToString();
                    hvtime = r["totalhours"].ToString();
                }
            }

            conn.Close();

            string url = $"CathodeTraveler.aspx?cathode={cathode}&gun={gun}&hvtime={hvtime}";

            Response.Redirect(url);
            //Response.Redirect("CathodeTraveler.aspx?cathode=900&gun=5&hvtime=4500");
        }
    }
}