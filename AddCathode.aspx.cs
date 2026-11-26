using System;
using System.Configuration;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Drawing;
using System.Web.UI.WebControls;

namespace CathodeWeb
{
    public partial class AddCathode : System.Web.UI.Page
    {
        private static string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SetMode(false);
            }
        }

        // ---------------------------------------------------------------
        // Mode switching
        // ---------------------------------------------------------------

        protected void chkRetire_CheckedChanged(object sender, EventArgs e)
        {
            HideMessage();
            SetMode(chkRetire.Checked);
        }

        private void SetMode(bool retire)
        {
            pnlAdd.Visible = !retire;
            btnAddCathode.Visible = !retire;

            pnlRetire.Visible = retire;
            btnRetireCathode.Visible = retire;

            litTitle.Text = retire ? "Retire Cathode Page" : "Add Cathode Page";

            if (retire)
            {
                LoadFurnaces();
                ResetCathodeList();
            }
        }

        // ---------------------------------------------------------------
        // Add Cathode
        // ---------------------------------------------------------------

        protected void btnAddCathode_Click(object sender, EventArgs e)
        {
            int sn;
            int badge;
            int eb;

            bool serialtest = int.TryParse(txtSerial.Text.Trim(), out sn);
            bool badgetest = int.TryParse(txtBadge.Text.Trim(), out badge);
            bool ebtest = int.TryParse(txtFurnace.Text.Trim(), out eb);

            //Serial Number Input Checks
            if (txtSerial.Text.Trim().Length < 4 || !serialtest)
            {
                ShowMessage("Please provide a valid Cathode Serial number.", false);
                return;
            }
            if (GetSerialCount(sn) != 0)
            {
                ShowMessage("Cathode exists. Confirm the serial number.", false);
                return;
            }

            //Furnace Input Check
            if (!ebtest || (eb != 1 && eb != 2))
            {
                ShowMessage("Please enter 1 for EB1 or 2 for EB2.", false);
                return;
            }

            //Badge Input Check
            if (!badgetest)
            {
                ShowMessage("Please provide a valid Employee number.", false);
                return;
            }
            if (GetBadgeCount(badge) == 0)
            {
                ShowMessage("Employee number does not exist. Confirm the Employee number.", false);
                return;
            }

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand("Cathode_Insert", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@serial", SqlDbType.Int).Value = sn;
                    cmd.Parameters.Add("@furnace", SqlDbType.Int).Value = eb;
                    cmd.Parameters.Add("@badge", SqlDbType.Int).Value = badge;
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                txtSerial.Text = string.Empty;
                txtFurnace.Text = string.Empty;
                txtBadge.Text = string.Empty;
                ShowMessage("Cathode " + sn + " added.", true);
            }
            catch (Exception ex)
            {
                ShowMessage(ex.Message, false);
            }
        }

        // ---------------------------------------------------------------
        // Retire Cathode
        // ---------------------------------------------------------------

        private void LoadFurnaces()
        {
            ddlRetireFurnace.Items.Clear();
            ddlRetireFurnace.Items.Add(new ListItem("-- Select --", ""));

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("SELECT DISTINCT furnace FROM dbo.ebguns ORDER BY furnace", conn))
            {
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        string f = Convert.ToString(rdr["furnace"]);
                        ddlRetireFurnace.Items.Add(new ListItem("EB " + f, f));
                    }
                }
            }
        }

        private void ResetCathodeList()
        {
            ddlRetireCathode.Items.Clear();
            ddlRetireCathode.Items.Add(new ListItem("-- Select --", ""));
        }

        // Active cathodes for the furnace that are NOT currently installed in a gun.
        // "Installed" = latest history record has status_id = 1 (same rule as vwCathodeStatus).
        // Cathodes with no history at all are also listed.
        private void LoadRetireCathodes(int furnace)
        {
            ResetCathodeList();

            const string sql =
                "SELECT c.serialnumber, s.value AS status " +
                "FROM dbo.cathode c " +
                "LEFT OUTER JOIN dbo.vwCathodeStatus s ON s.cathode_number = c.serialnumber " +
                "WHERE c.active = 1 AND c.furnace = @furnace " +
                "  AND NOT EXISTS (SELECT 1 FROM dbo.vwCathodeStatus v " +
                "                  WHERE v.cathode_number = c.serialnumber AND v.status_id = 1) " +
                "ORDER BY c.serialnumber";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.Add("@furnace", SqlDbType.Int).Value = furnace;
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        string serial = Convert.ToString(rdr["serialnumber"]);
                        string status = rdr["status"] == DBNull.Value ? "" : Convert.ToString(rdr["status"]);
                        string text = status.Length > 0 ? serial + " - " + status : serial;
                        ddlRetireCathode.Items.Add(new ListItem(text, serial));
                    }
                }
            }

            if (ddlRetireCathode.Items.Count == 1)
            {
                ShowMessage("No cathodes on this furnace are available to retire.", false);
            }
        }

        protected void ddlRetireFurnace_SelectedIndexChanged(object sender, EventArgs e)
        {
            HideMessage();
            if (int.TryParse(ddlRetireFurnace.SelectedValue, out int furnace))
                LoadRetireCathodes(furnace);
            else
                ResetCathodeList();
        }

        protected void btnRetireCathode_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(ddlRetireFurnace.SelectedValue, out int furnace))
            {
                ShowMessage("Select a furnace.", false);
                return;
            }
            if (!int.TryParse(ddlRetireCathode.SelectedValue, out int serial))
            {
                ShowMessage("Select a cathode to retire.", false);
                return;
            }
            if (!int.TryParse(txtBadge.Text.Trim(), out int badge))
            {
                ShowMessage("Please provide a valid Employee number.", false);
                return;
            }

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand("dbo.spRetireCathode", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@serial", SqlDbType.Int).Value = serial;
                    cmd.Parameters.Add("@badge", SqlDbType.Int).Value = badge;
                    conn.Open();
                    cmd.ExecuteScalar();
                }

                LoadRetireCathodes(furnace);
                txtBadge.Text = string.Empty;
                ShowMessage("Cathode " + serial + " has been retired.", true);
            }
            catch (SqlException ex)
            {
                // 50011-50013 are the user-facing messages raised by spRetireCathode
                if (ex.Number >= 50011 && ex.Number <= 50013)
                {
                    if (ex.Number != 50011) LoadRetireCathodes(furnace);
                    ShowMessage(ex.Message, false);
                }
                else
                {
                    ShowMessage("A database error occurred. The cathode was not retired.", false);
                }
            }
        }

        // ---------------------------------------------------------------
        // Helpers
        // ---------------------------------------------------------------

        private void ShowMessage(string text, bool success)
        {
            lblError.Text = Server.HtmlEncode(text);
            lblError.ForeColor = success ? Color.Green : Color.Red;
            lblError.Visible = true;
        }

        private void HideMessage()
        {
            lblError.Text = string.Empty;
            lblError.Visible = false;
        }

        public int GetSerialCount(int TheSerialNumber)
        {
            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("SELECT COUNT(serialnumber) FROM dbo.cathode WHERE serialnumber = @serial", conn))
            {
                cmd.Parameters.Add("@serial", SqlDbType.Int).Value = TheSerialNumber;
                conn.Open();
                return (int)cmd.ExecuteScalar();
            }
        }

        public int GetBadgeCount(int TheBadgeNumber)
        {
            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("SELECT COUNT(badge) FROM dbo.users WHERE badge = @badge", conn))
            {
                cmd.Parameters.Add("@badge", SqlDbType.Int).Value = TheBadgeNumber;
                conn.Open();
                return (int)cmd.ExecuteScalar();
            }
        }
    }
}
