/*
 * "Simple SQL Exec"
 * Copyright (c) 2015 Sql Quantum Leap. All rights reserved.
 * 
 */
using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;


namespace SimpleSqlExec
{
    partial class Program
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
                Display.Error(_ArgException.Message);// + " (" + _ArgException.ParamName + ")");

                return 1;
            }
            catch(Exception _Exception)
            {
                Display.Error(_Exception.Message);

                return 2;
            }

            Helpers.SetDebugMode(_InputParams.DebugInfoFile);
            Helpers.Debug("--===========================================================--");
            Helpers.Debug("Starting...");

            if (_InputParams.DisplayUsage)
            {
                Display.Usage();

                return 0;
            }


            string _ConnectionString;

            try
            {
                Helpers.Debug("Parsing ConnectionString.");

                _ConnectionString = Helpers.GetConnectionString(_InputParams);
            }
            catch(Exception _Exception)
            {
                Display.Error(_Exception.Message);

                return 3;
            }


            try
            {
                ProcessQueries(_InputParams, _ConnectionString);
            }
            catch (SqlException _SqlException)
            {
                Display.Error(String.Concat(_SqlException.Message, "\n\n",
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
                Helpers.Debug(_Exception.Message);
                Helpers.Debug(_Exception.StackTrace);

                return 5;
            }


            try
            {
                if (_InputParams.RowsAffectedDestination != String.Empty)
                {
                    Helpers.Debug("Handling RowsAffected.");

                    if (_InputParams.RowsAffectedDestination.LastIndexOf(".") > -1)
                    {
                        Helpers.Debug("RowsAffected saved to file: " + _InputParams.RowsAffectedDestination);

                        File.WriteAllText(_InputParams.RowsAffectedDestination,
                            Capture._RowsAffected.ToString());
                    }
                    else
                    {
                        Helpers.Debug("RowsAffected stored in variable: " + _InputParams.RowsAffectedDestination);

                        Environment.SetEnvironmentVariable(_InputParams.RowsAffectedDestination,
                            Capture._RowsAffected.ToString(), EnvironmentVariableTarget.User);
                    }
                }
            }
            catch (Exception _Exception)
            {
                Display.Error(_Exception.Message);

                return 7;
            }


            Helpers.Debug("Ending...");
            Helpers.Debug("--===========================================================--");
            return 0;
        }
    }
}
