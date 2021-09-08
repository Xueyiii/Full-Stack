using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
namespace Antra.CompanyApp.Data.Repository
{
    class DBHelper
    {
        public int Execute(string sqlCommand, Dictionary<string, object> parameters)
        {
            SqlConnection connection = new SqlConnection("Data Source=.;Initial Catalog=CompanyDB;Integrated Security=True");

            SqlCommand command = new SqlCommand();
            try
            {
                connection.Open();
                command.CommandText = sqlCommand;
                if (parameters != null)
                {
                    foreach (var item in parameters)
                    {
                        command.Parameters.AddWithValue(item.Key, item.Value);
                    }
                }

                command.Connection = connection;

                return command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                // log the exception to files
            }
            finally
            {
                connection.Close();
                connection.Dispose();
                command.Dispose();
            }

            return 0;
        }
    }
}
