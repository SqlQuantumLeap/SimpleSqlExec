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
        private static void ProcessQueries(InputParameters InputParams, string ConnectionString)
        {

            using (SqlConnection _Connection = new SqlConnection(ConnectionString))
            {
                if (InputParams.MessagesFile != String.Empty)
                {
                    Helpers.Debug("Setting up the MessagesFile and handler.");

                    // clear out existing file
                    File.Delete(InputParams.MessagesFile);

                    Capture.MessagesFile = InputParams.MessagesFile;
                    Capture.OutputEncoding = InputParams.OutputEncoding;

                    _Connection.InfoMessage += Capture.InfoMessageHandler;
                }
                _Connection.FireInfoMessageEventOnUserErrors = false;

                using (SqlCommand _Command = _Connection.CreateCommand())
                {
                    _Command.CommandType = CommandType.Text;
                    _Command.CommandTimeout = InputParams.QueryTimeout;

                    if (InputParams.RowsAffectedDestination != String.Empty)
                    {
                        Helpers.Debug("Setting up the RowsAffected handler.");

                        _Command.StatementCompleted += Capture.StatementCompletedHandler;
                    }

                    _Connection.Open();

                    ResultsOutput _Output = null;
                    QueryBatches _Queries = null;

                    try
                    {
                        _Queries = new QueryBatches(InputParams);
                        _Output = Helpers.GetResultsOutput(InputParams);

                        while (_Queries.NextBatch())
                        {
                            _Command.CommandText = _Queries.GetBatch();

                            Helpers.Debug("Executing the batch...");
                            using (SqlDataReader _Reader = _Command.ExecuteReader())
                            {
                                object[] _ResultRow;
                                string _OutputRow;


                                do
                                {
                                    _Output.Send(_Output.GetHeader(_Reader, InputParams.ColumnSeparator));

                                    if (_Reader.HasRows)
                                    {
                                        _ResultRow = new object[_Reader.FieldCount];

                                        while (_Reader.Read())
                                        {
                                            _Reader.GetValues(_ResultRow);
                                            _OutputRow = String.Join(InputParams.ColumnSeparator, _ResultRow);

                                            _Output.Send(_OutputRow);
                                        }

                                        _ResultRow = null;
                                    }
                                } while (_Reader.NextResult());
                            } // using (SqlDataReader...
                        } // while (_Queries.NextBatch())
                    }
                    //catch
                    //{
                    //    throw;
                    //}
                    finally
                    {
                        if (_Output.GetType() == typeof(OutputFile))
                        {
                            Helpers.Debug("Close output file!");
                            _Output.Dispose();
                        }
                    }

                } // using (SqlCommand...
            } // using (SqlConnection

            return;
        }
    }
}
