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
    public partial class CathodePartsReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRun_Click(object sender, EventArgs e)
        {
            DateTime start = DateTime.Parse(txtStart.Text);
            DateTime end = DateTime.Parse(txtEnd.Text);

            string sql = @"
                SELECT 
                    CASE
                        WHEN p.description = 'Rod'
                            THEN '4 Rod Set'
                        ELSE
                            p.description
                    END AS CathodeParts,
                    CASE
                        WHEN p.description = 'Rod'
                            THEN SUM(ph.partcount) / 4
                        ELSE
                            SUM(ph.partcount)
                    END AS PartTotals
                FROM parthistory ph
                INNER JOIN parts p
                    ON p.id = ph.parts_id
                WHERE ph.created_at >= @start
                AND ph.created_at < @end
                GROUP BY p.description
                ORDER BY p.description;
            ";

            using (SqlConnection conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["CathodeConnString"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@start", start);
                cmd.Parameters.AddWithValue("@end", end);

                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();

                DataTable dt = new DataTable();
                dt.Load(rdr);

                gvParts.DataSource = dt;
                gvParts.DataBind();
            }
        }
    }
}