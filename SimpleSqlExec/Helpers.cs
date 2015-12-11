/*
 * "Simple SQL Exec"
 * Copyright (c) 2015 Sql Quantum Leap. All rights reserved.
 * 
 */
using System;
using System.Data.SqlClient;
using System.IO;
using System.Text;

namespace SimpleSqlExec
{
    internal class Helpers
    {
        private static bool _DebugEnabled = false;
        private static string _DebugFile = null;

        internal static string GetConnectionString(InputParameters InputParams)
        {
            SqlConnectionStringBuilder _ConnectionString;

            if (InputParams.ConnectionString != String.Empty)
            {
                Debug("Using passed-in ConnectionString.");
                _ConnectionString = new SqlConnectionStringBuilder(InputParams.ConnectionString);
                _ConnectionString.Pooling = false; // override just in case it was passed in
                _ConnectionString.ContextConnection = false; // override just in case it was passed in

                return _ConnectionString.ConnectionString;
            }
            
            _ConnectionString = new SqlConnectionStringBuilder();

            _ConnectionString.Pooling = false;
            _ConnectionString.ApplicationIntent = InputParams.AppIntent;
            _ConnectionString.ApplicationName = InputParams.ApplicationName;
            _ConnectionString.AttachDBFilename = InputParams.AttachDBFilename;
            _ConnectionString.ConnectTimeout = InputParams.LoginTimeout;
            _ConnectionString.DataSource = InputParams.Server;
            _ConnectionString.Encrypt = InputParams.EncryptConnection;
            _ConnectionString.InitialCatalog = InputParams.DatabaseName;
            _ConnectionString.MultiSubnetFailover = InputParams.MultiSubnetFailover;
            _ConnectionString.TrustServerCertificate = InputParams.TrustServerCertificate;
            _ConnectionString.WorkstationID = InputParams.WorkstationName;
            _ConnectionString.PacketSize = InputParams.PacketSize;

            if (InputParams.UserID != String.Empty)
            {
                _ConnectionString.UserID = InputParams.UserID;
                _ConnectionString.Password = InputParams.Password;
                _ConnectionString.IntegratedSecurity = false;
            }
            else
            {
                _ConnectionString.IntegratedSecurity = true;
            }

            return _ConnectionString.ConnectionString;
        }
    
        internal static ResultsOutput GetResultsOutput(InputParameters InputParams)
        {
            if (InputParams.OutputFile == String.Empty)
            {
                return new OutputDisplay();
            }
            else
            {
                return new OutputFile(InputParams.OutputFile,
                    InputParams.OutputFileAppend, InputParams.OutputEncoding);
            }
        }

        internal static void SetDebugMode(string DebugInfoFile)
        {
            if (DebugInfoFile != String.Empty)
            {
                _DebugFile = DebugInfoFile;
                _DebugEnabled = true;
            }

            return;
        }

        internal static void Debug(string DebugMessage)
        {
            if(!_DebugEnabled)
            {
                return;
            }

            string _FullMessage = String.Concat(
                DateTime.Now.ToString("yyyy-MM-dd @ HH:mm:ss.fff"),
                " -- ",
                DebugMessage,
                "\r\n");

            File.AppendAllText(_DebugFile, _FullMessage, Encoding.UTF8);

            return;
        }
    }
}
