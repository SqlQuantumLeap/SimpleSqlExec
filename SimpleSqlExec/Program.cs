using System;
using System.Data;
using System.Data.SqlClient;

namespace SimpleSqlCmd
{
    class Program
    {
        static void Main(string[] args)
        {
            using(SqlConnection _Connection = new SqlConnection(args[0]))
            {
                using(SqlCommand _Command = new SqlCommand(args[1], _Connection))
                {    
                   _Connection.Open();

                   _Command.ExecuteNonQuery();
                }
            }

            return;
        }
    }
}
