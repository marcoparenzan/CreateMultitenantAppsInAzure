using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Tenant.Web.Startup))]
namespace Tenant.Web
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
