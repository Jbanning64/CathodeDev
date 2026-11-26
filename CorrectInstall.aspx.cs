using System;
using System.Configuration;
using System.Data;
using System.Drawing;
using Microsoft.Data.SqlClient;   // change to System.Data.SqlClient if the other pages use that provider

namespace CathodeDev
{
    public partial class CorrectInstall : System.Web.UI.Page
    {
        private static string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFurnaces();
            }
        }

        private void LoadFurnaces()
        {
            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("SELECT DISTINCT furnace FROM dbo.ebguns ORDER BY furnace", conn))
            {
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        string f = Convert.ToString(rdr["furnace"]);
                        ddlFurnace.Items.Add(new System.Web.UI.WebControls.ListItem("EB " + f, f));
                    }
                }
            }
        }

        // Lists only guns that currently have a cathode installed, showing which cathode.
        // The item value is "gunid|cathode" so the procedure can detect a stale page.
        private void LoadGuns(int furnace)
        {
            ddlGun.Items.Clear();
            ddlGun.Items.Add(new System.Web.UI.WebControls.ListItem("-- Select --", ""));

            const string sql =
                "SELECT gun_id, Cathode, Gun_Number " +
                "FROM dbo.vwEBCathodesInUse " +
                "WHERE furnace = @furnace " +
                "ORDER BY Gun_Number";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.Add("@furnace", SqlDbType.Int).Value = furnace;
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        string value = Convert.ToString(rdr["gun_id"]) + "|" + Convert.ToString(rdr["Cathode"]);
                        string text = Convert.ToString(rdr["Gun_Number"]) + " - Cathode " + Convert.ToString(rdr["Cathode"]);
                        ddlGun.Items.Add(new System.Web.UI.WebControls.ListItem(text, value));
                    }
                }
            }
        }

        protected void ddlFurnace_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblMessage.Text = "";
            if (int.TryParse(ddlFurnace.SelectedValue, out int furnace))
            {
                LoadGuns(furnace);
            }
            else
            {
                ddlGun.Items.Clear();
                ddlGun.Items.Add(new System.Web.UI.WebControls.ListItem("-- Select --", ""));
            }
        }

        protected void btnUninstall_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(ddlFurnace.SelectedValue, out int furnace) || string.IsNullOrEmpty(ddlGun.SelectedValue))
            {
                ShowMessage("Select a furnace and a gun.", false);
                return;
            }

            if (!int.TryParse(txtBadge.Text.Trim(), out int badge))
            {
                ShowMessage("Enter a valid employee ID.", false);
                return;
            }

            string[] parts = ddlGun.SelectedValue.Split('|');
            if (parts.Length != 2 || !int.TryParse(parts[0], out int gunId) || !int.TryParse(parts[1], out int cathode))
            {
                ShowMessage("Select a gun.", false);
                return;
            }

            try
            {
                int removedCathode;
                using (var conn = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand("dbo.spCorrectCathodeInstall", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@gunid", SqlDbType.Int).Value = gunId;
                    cmd.Parameters.Add("@cathode", SqlDbType.Int).Value = cathode;
                    cmd.Parameters.Add("@badge", SqlDbType.Int).Value = badge;
                    conn.Open();
                    removedCathode = Convert.ToInt32(cmd.ExecuteScalar());
                }

                ShowMessage("Uninstall successful. Cathode " + removedCathode +
                            " has been removed from the selected gun. Use the Install Cathode page to install the correct cathode.", true);
                LoadGuns(furnace);
            }
            catch (SqlException ex)
            {
                // 50001-50004 are the user-facing messages raised by the procedure
                if (ex.Number >= 50001 && ex.Number <= 50004)
                {
                    ShowMessage(ex.Message, false);
                    if (ex.Number != 50001) LoadGuns(furnace);
                }
                else
                {
                    ShowMessage("A database error occurred. The uninstall was not completed.", false);
                }
            }
        }

        private void ShowMessage(string text, bool success)
        {
            lblMessage.Text = Server.HtmlEncode(text);
            lblMessage.ForeColor = success ? Color.Green : Color.Firebrick;
        }
    }
}
