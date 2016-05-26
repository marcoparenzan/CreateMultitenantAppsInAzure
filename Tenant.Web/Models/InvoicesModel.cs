namespace Tenant.Web.Models
{
    using System;
    using System.Data.Entity;
    using System.Linq;

    public class InvoicesModel : DbContext
    {
        public InvoicesModel()
            : base("name=InvoicesModel")
        {
        }

        public virtual DbSet<Invoice> Invoices { get; set; }
    }

    public class Invoice
    {
        public int InvoiceId { get; set; }
        public int Number { get; set; }
        public DateTime Date { get; set; }
        public string Customer { get; set; }
        public decimal Amount { get; set; }
        public DateTime DueDate { get; set; }
    }
}