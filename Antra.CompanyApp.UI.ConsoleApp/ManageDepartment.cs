using System;
using System.Collections.Generic;
using System.Text;
using Antra.CompanyApp.Data.Repository;
using Antra.CompanyApp.Data.Model;
namespace Antra.CompanyApp.UI.ConsoleApp
{
    class ManageDepartment
    {
        IRepository<Dept> deptRepository;
        public ManageDepartment()
        {
            deptRepository = new DeptRepository();
        }

        void AddDepartment()
        {
            Dept d = new Dept();
            Console.Write("Enter Name => ");
            d.DName = Console.ReadLine();
            Console.Write("Enter Location => ");
            d.Loc = Console.ReadLine();

            if (deptRepository.Insert(d) > 0)
                Console.WriteLine("Department Added Successfully");
            else
                Console.WriteLine("Some error has occured");
        }
        void DeleteDepartment()
        {
            Console.Write("Enter Id => ");
            int id = Convert.ToInt32(Console.ReadLine());
            if (deptRepository.Delete(id) > 0)
                Console.WriteLine("Department Deleted Successfully");
            else
                Console.WriteLine("Some error has occured");
        }

        void UpdateDepartment()
        {
            Dept d = new Dept();
            Console.Write("Enter Id => ");
            d.Id = Convert.ToInt32(Console.ReadLine());
            Console.Write("Enter Name => ");
            d.DName = Console.ReadLine();
            Console.Write("Enter Location => ");
            d.Loc = Console.ReadLine();

            if (deptRepository.Update(d) > 0)
                Console.WriteLine("Department Updated Successfully");
            else
                Console.WriteLine("Some error has occured");
        }

        public void Run()
        {
            DeleteDepartment();
        }
    }
}
