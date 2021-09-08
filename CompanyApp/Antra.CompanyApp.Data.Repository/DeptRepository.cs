using System;
using System.Collections.Generic;
using System.Text;
using Antra.CompanyApp.Data.Model;

namespace Antra.CompanyApp.Data.Repository
{
    public class DeptRepository : IRepository<Dept>
    {
        DBHelper db;
        public DeptRepository()
        {
            db = new DBHelper();
        }
        public int Delete(int id)
        {
            string cmd = "Delete from Dept where Id=@deptid";
            Dictionary<string, object> p = new Dictionary<string, object>();
            p.Add("@deptid", id);
            return db.Execute(cmd, p);
        }

        public IEnumerable<Dept> GetAll()
        {
            throw new NotImplementedException();
        }

        public Dept GetById(int id)
        {
            throw new NotImplementedException();
        }

        public int Insert(Dept item)
        {
            string cmd = "Insert into Dept values (@dname,@loc)";
            Dictionary<string, object> p = new Dictionary<string, object>();
            p.Add("@dname", item.DName);
            p.Add("@loc", item.Loc);
            return db.Execute(cmd, p);
        }

        public int Update(Dept item)
        {
            string cmd = "Update Dept set DName=@dname, Loc=@loc where id=@id";
            Dictionary<string, object> p = new Dictionary<string, object>();
            p.Add("@dname", item.DName);
            p.Add("@loc", item.Loc);
            p.Add("@id", item.Id);
            return db.Execute(cmd, p);
        }
    }
}
