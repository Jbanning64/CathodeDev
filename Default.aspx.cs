using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Data.SqlClient;

namespace CathodeWeb
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadEBTimes();
        }

        private void LoadEBTimes()
        {
            DataView dv = (DataView)SqlEB1Update.Select(DataSourceSelectArguments.Empty);
            DataView dv2 = (DataView)SqlEB2Update.Select(DataSourceSelectArguments.Empty);

            if (dv.Count > 0)
            {
                txtEB1Time.Text = dv[0]["HVTimerDate"].ToString();
            }
            else
            {
                txtEB1Time.Text = "No Data";
            }

            if (dv2.Count > 0)
            {
                txtEB2Time.Text = dv2[0]["HVTimerDate"].ToString();
            }
            else
            {
                txtEB2Time.Text = "No Data";
            }

        }

        protected void grdEB1Other_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //Get the value of column from the DataKeys using the RowIndex.
                int id = Convert.ToInt32(grdEB1Other.DataKeys[e.Row.RowIndex].Values[0]);

                if (id == 2)
                {
                    e.Row.BackColor = System.Drawing.Color.LightSalmon;
                }
                else if (id == 3)
                {
                    e.Row.BackColor = System.Drawing.Color.LightYellow;
                }
                else if (id == 4)
                {
                    e.Row.BackColor = System.Drawing.Color.LightGreen;
                }

            }


        }

        protected void grdEB2Other_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //Get the value of column from the DataKeys using the RowIndex.
                int id = Convert.ToInt32(grdEB2Other.DataKeys[e.Row.RowIndex].Values[0]);

                if (id == 2)
                {
                    e.Row.BackColor = System.Drawing.Color.LightSalmon;
                }
                else if (id == 3)
                {
                    e.Row.BackColor = System.Drawing.Color.LightYellow;
                }
                else if (id == 4)
                {
                    e.Row.BackColor = System.Drawing.Color.LightGreen;
                }

            }
        }
    }
}