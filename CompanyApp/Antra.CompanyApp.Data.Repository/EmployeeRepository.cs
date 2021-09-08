using System;
using System.Collections.Generic;
using System.Text;
using Antra.CompanyApp.Data.Model;

namespace Antra.CompanyApp.Data.Repository
{
    public class EmployeeRepository : IRepository<Employee>
    {
        DBHelper db;
        public EmployeeRepository()
        {
            db = new DBHelper();
        }
        public int Delete(int id)
        {
            string cmd = "Delete from Employee where Id=@empid";
            Dictionary<string, object> p = new Dictionary<string, object>();
            p.Add("@empid", id);
            return db.Execute(cmd, p);
        }

        public IEnumerable<Employee> GetAll()
        {
            throw new NotImplementedException();
        }

        public Employee GetById(int id)
        {
            throw new NotImplementedException();
        }

        public int Insert(Employee item)
        {
            string cmd = "Insert into Employee values (@ename)";
            Dictionary<string, object> p = new Dictionary<string, object>();
            p.Add("@ename", item.EName);
            return db.Execute(cmd, p);
        }

        public int Update(Employee item)
        {
            string cmd = "Update Employee set EName=@ename where Id=@empid";
            Dictionary<string, object> p = new Dictionary<string, object>();
            p.Add("@ename", item.EName);
            p.Add("@empid", item.Id);
            return db.Execute(cmd, p);
        }
    }
}
