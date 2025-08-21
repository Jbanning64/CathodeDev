using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CathodeWeb
{
    public partial class QuickHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ddlFurnace_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void ddlGun_SelectedIndexChanged(object sender, EventArgs e)
        {
            grdEBHistory.DataBind();    
        }

        protected void ddlCathode_SelectedIndexChanged(object sender, EventArgs e)
        {
            grdCathodeHistory.DataBind();   
        }
    }
}