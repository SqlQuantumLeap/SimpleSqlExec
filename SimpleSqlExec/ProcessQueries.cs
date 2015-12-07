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
        private static void ProcessQueries(InputParameters InputParams, string ConnectionString)
        {

            using (SqlConnection _Connection = new SqlConnection(ConnectionString))
            {
                if (InputParams.MessagesFile != String.Empty)
                {
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
                        _Command.StatementCompleted += Capture.StatementCompletedHandler;
                    }

                    ResultsOutput _Output = null;

                    _Connection.Open();

                    _Command.CommandText = InputParams.Query; // replace with QueryBatches.NextBatch();

                    { // loop through files / batches

                        using (SqlDataReader _Reader = _Command.ExecuteReader())
                        {
                            object[] _ResultRow;
                            string _OutputRow;

                            if (_Output == null)
                            {
                                _Output = Helpers.GetResultsOutput(InputParams);
                            }


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

                            if (_Output.GetType() == typeof(OutputFile))
                            {
                                _Output.Dispose();
                            }
                        } // using (SqlDataReader...
                    }

                } // using (SqlCommand...
            }

            return;
        }
    }
}
