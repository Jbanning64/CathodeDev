using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CathodeWeb
{
    public partial class CathodeTraveler : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                string cathode = Request.QueryString["cathode"];
                string gun = Request.QueryString["gun"];
                string hvtime = Request.QueryString["hvtime"];

                // Assign values to controls
                cathodeSpan.InnerText = cathode;
                gunSpan.InnerText = gun;
                hvtimeSpan.InnerText = hvtime;

                // Auto-print
                ClientScript.RegisterStartupScript(this.GetType(), "print", "window.print();", true);
            }

        }
    }
}