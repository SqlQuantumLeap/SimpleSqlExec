/*
 * "Simple SQL Exec"
 * Copyright (c) 2015 Sql Quantum Leap. All rights reserved.
 * 
 */
using System;
using System.Data.SqlClient;

namespace SimpleSqlExec
{
    internal class Helpers
    {
        internal static string GetConnectionString(InputParameters InputParams)
        {
            SqlConnectionStringBuilder _ConnectionString;

            if (InputParams.ConnectionString != String.Empty)
            {
                _ConnectionString = new SqlConnectionStringBuilder(InputParams.ConnectionString);

                return _ConnectionString.ConnectionString;
            }

            _ConnectionString = new SqlConnectionStringBuilder();

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
    }
}
