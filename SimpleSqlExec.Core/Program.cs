/*
   Copyright 2015 Solomon Rutzky

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
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
            catch (ArgumentException _ArgException)
            {
                Display.Error(_ArgException.Message);// + " (" + _ArgException.ParamName + ")");

                return 1;
            }
            catch (Exception _Exception)
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
            catch (Exception _Exception)
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