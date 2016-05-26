using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Portal.Web.Startup))]
namespace Portal.Web
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
