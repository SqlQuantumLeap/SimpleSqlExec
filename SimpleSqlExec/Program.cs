/*
 * "Simple SQL Exec"
 * Copyright (c) 2015 Sql Quantum Leap. All rights reserved.
 * 
 */
using System;
using System.Data;
using System.Data.SqlClient;


namespace SimpleSqlExec
{
    class Program
    {
        static int Main(string[] args)
        {
            InputParameters _InputParams;

            Console.Title = "Simple SQL Exec (from Sql Quantum Leap -- http://SqlQuantumLeap.com/)";

            try
            {
                _InputParams = new InputParameters(args);
            }
            catch(ArgumentException _ArgException)
            {
                Display.Error(_ArgException.Message + " (" + _ArgException.ParamName + ")");

                return 1;
            }
            catch(Exception _Exception)
            {
                Display.Error(_Exception.Message);

                return 2;
            }

            if (_InputParams.DisplayUsage)
            {
                Display.Usage();

                return 0;
            }


            string _ConnectionString;

            try
            {
                _ConnectionString = Helpers.GetConnectionString(_InputParams);
            }
            catch(Exception _Exception)
            {
                Display.Error(_Exception.Message);

                return 3;
            }

            try
            {
                using (SqlConnection _Connection = new SqlConnection(_ConnectionString))
                {
                    using (SqlCommand _Command = new SqlCommand(_InputParams.Query))
                    {
                        _Command.Connection = _Connection;
                        _Command.CommandTimeout = _InputParams.QueryTimeout;


                        _Connection.Open();

                        _Command.ExecuteNonQuery();
                    }
                }
            }
            catch (SqlException _SqlException)
            {
                Display.Error(String.Concat(_SqlException.Message, "\n",
                    "Error Number:    ", _SqlException.Number, "\n",
                    "Error Level:     ", _SqlException.Class, "\n",
                    "Error State:     ", _SqlException.State, "\n",
                    "Error Procedure: ", _SqlException.Procedure, "\n",
                    "Error Line:      ", _SqlException.LineNumber, "\n",
                    "HRESULT:         ", _SqlException.ErrorCode, "\n"
                    ));

                return 4;
            }
            catch (Exception _Exception)
            {
                Display.Error(_Exception.Message);

                return 5;
            }

            return 0;
        }
    }
}
