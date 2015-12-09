/*
 * "Simple SQL Exec"
 * Copyright (c) 2015 Sql Quantum Leap. All rights reserved.
 * 
 */
using System;
using System.Collections.Generic;
using System.Data.SqlClient; // ApplicationIntent enum
using System.IO;
using System.Text; // Encoding


namespace SimpleSqlExec
{
	internal class InputParameters
	{
        /* SQLCMD utility ( https://msdn.microsoft.com/en-us/library/ms162773.aspx )
         * SqlConnection.ConnectionString ( https://msdn.microsoft.com/en-us/library/system.data.sqlclient.sqlconnection.connectionstring.aspx )
         * SqlCommand.CommandTimeout ( https://msdn.microsoft.com/en-us/library/system.data.sqlclient.sqlcommand.commandtimeout.aspx )
         * 
         * -U "User ID" (if not present then -E / trusted_connection is used)
         * -P "Password"
         * -S "Server"
         * -d "Database name"
         * -H "Workstation name"
         * -Q "Query"
         * -l "Login (i.e. connection) timeout"
         * -t "Query (i.e. command) timeout"
         * -K "Application intent" (ReadOnly / ReadWrite)
         * -N Encrypt Connection
         * -C Trust Server Certificate
         * -M MultiSubnet Failover
         * -o "Output file"
         * -s "Column separator"
         * -a "Packet size" (range: 512 - 32767; default: "4096" {default for .NET SqlConnection = "8000"!})
         * -u Unicode (UTF-16 LE) Output file and Messages File
         * -i "input_file[,input_file2...]
         * 
         * -an "Application name"
         * -cs "Connection string"
         * -ra "Rows Affected file path {or environment variable name?}"
         * -mf "Messages File"
         * -ef "Error File"
         * -oh "Output file handling" (OverWrite, Append, or Error)
         * -? / -help  Display usage
         */

        private string _UserID = String.Empty;
        internal string UserID
        {
            get
            {
                return this._UserID;
            }
        }

        private string _Password = String.Empty;
        internal string Password
        {
            get
            {
                return this._Password;
            }
        }

        private string _Server = String.Empty;
        internal string Server
        {
            get
            {
                return this._Server;
            }
        }

        private string _DatabaseName = String.Empty;
        internal string DatabaseName
        {
            get
            {
                return this._DatabaseName;
            }
        }

        private string _WorkstationName = String.Empty;
        internal string WorkstationName
        {
            get
            {
                return this._WorkstationName;
            }
        }

        private string _Query = String.Empty;
        internal string Query
        {
            get
            {
                return this._Query;
            }
        }

        private int _LoginTimeout = 15; // .NET SqlConnection default
        internal int LoginTimeout
        {
            get
            {
                return this._LoginTimeout;
            }
        }

        private int _QueryTimeout = 30; // .NET SqlCommand default
        internal int QueryTimeout
        {
            get
            {
                return this._QueryTimeout;
            }
        }

        private ApplicationIntent _AppIntent = ApplicationIntent.ReadWrite; // .NET SqlConnection default
        internal ApplicationIntent AppIntent
        {
            get
            {
                return this._AppIntent;
            }
        }

        private bool _EncryptConnection = false; // .NET SqlConnection default
        internal bool EncryptConnection
        {
            get
            {
                return this._EncryptConnection;
            }
        }

        private bool _TrustServerCertificate = false; // .NET SqlConnection default
        internal bool TrustServerCertificate
        {
            get
            {
                return this._TrustServerCertificate;
            }
        }

        private bool _MultiSubnetFailover = false; // .NET SqlConnection default
        internal bool MultiSubnetFailover
        {
            get
            {
                return this._MultiSubnetFailover;
            }
        }

        private string _OutputFile = String.Empty;
        internal string OutputFile
        {
            get
            {
                return this._OutputFile;
            }
        }

        private string _ColumnSeparator = " "; // SQLCMD default
        internal string ColumnSeparator
        {
            get
            {
                return this._ColumnSeparator;
            }
        }

        private UInt16 _PacketSize = 4096; // SQLCMD default; .NET default is 8000; range = 512 - 32767
        internal UInt16 PacketSize
        {
            get
            {
                return this._PacketSize;
            }
        }

        private Encoding _OutputEncoding = Console.OutputEncoding; // SQLCMD default
        internal Encoding OutputEncoding
        {
            get
            {
                return this._OutputEncoding;
            }
        }

        private List<string> _InputFiles = new List<string>();
        internal List<string> InputFiles
        {
            get
            {
                return this._InputFiles;
            }
        }



        private string _ApplicationName = "Simple SQL Exec";
        internal string ApplicationName
        {
            get
            {
                return this._ApplicationName;
            }
        }

        private string _AttachDBFilename = String.Empty;
        internal string AttachDBFilename
        {
            get
            {
                return this._AttachDBFilename;
            }
        }

        private string _ConnectionString = String.Empty;
        internal string ConnectionString
        {
            get
            {
                return this._ConnectionString;
            }
        }

        private string _RowsAffectedDestination = String.Empty;
        internal string RowsAffectedDestination
        {
            get
            {
                return this._RowsAffectedDestination;
            }
        }

        private string _MessagesFile = String.Empty;
        internal string MessagesFile
        {
            get
            {
                return this._MessagesFile;
            }
        }

        private string _ErrorFile = String.Empty;
        internal string ErrorFile
        {
            get
            {
                return this._ErrorFile;
            }
        }

        private bool _OutputFileAppend = false; // SQLCMD default and no option for "true"
        internal bool OutputFileAppend
        {
            get
            {
                return this._OutputFileAppend;
            }
        }
        private bool _CheckForExistingOutputFile = false; // true if "-oh Error" is passed in

        private bool _DisplayUsage = false;
        internal bool DisplayUsage
        {
            get
            {
                return this._DisplayUsage;
            }
        }


        public InputParameters(string[] args)
        {
            if (args.Length == 0)
            {
                _DisplayUsage = true;

                return;
            }

			for (int _Index = 0; _Index < args.Length; _Index++)
			{
				switch (args[_Index])
				{
					case "-U":
					case "/U":
						this._UserID = args[++_Index];
						break;
					case "-P":
					case "/P":
                        if ((args.Length >= (_Index + 2))
                            && !args[_Index + 1].StartsWith("-", StringComparison.Ordinal)
                            && !args[_Index + 1].StartsWith("/", StringComparison.Ordinal))
                        {
                            this._Password = args[++_Index];
                        }
						break;
					case "-S":
					case "/S":
						this._Server = args[++_Index];
						break;
                    case "-d":
                    case "/d":
                        this._DatabaseName = args[++_Index];
                        break;
                    case "-H":
					case "/H":
						this._WorkstationName = args[++_Index];
						break;
					case "-Q":
					case "/Q":
                        if ((args.Length >= (_Index + 2))
                            && !args[_Index + 1].StartsWith("-", StringComparison.Ordinal)
                            && !args[_Index + 1].StartsWith("/", StringComparison.Ordinal))
                        {
                            this._Query = args[++_Index].TrimEnd(null);
                        }
						break;
					case "-l":
					case "/l":
						Int32.TryParse(args[++_Index], out this._LoginTimeout);
                        if (this.LoginTimeout < 0)
                        {
                            throw new ArgumentException(String.Concat("Invalid Connect / Login Timeout value: ",
                                this.LoginTimeout, "; the value must be >= 0."), "-l");
                        }
						break;
					case "-t":
					case "/t":
                        Int32.TryParse(args[++_Index], out this._QueryTimeout);
                        if (this.QueryTimeout < 0)
                        {
                            throw new ArgumentException(String.Concat("Invalid Query / Command Timeout value: ",
                                this.QueryTimeout, "; the value must be >= 0."), "-t");
                        }
                        break;
                    case "-K":
                    case "/K":
                        Enum.TryParse<ApplicationIntent>(args[++_Index], out this._AppIntent);
						break;
                    case "-N":
                    case "/N":
                        this._EncryptConnection = true;
                        break;
                    case "-C":
                    case "/C":
                        this._TrustServerCertificate = true;
                        break;
                    case "-M":
                    case "/M":
                        this._MultiSubnetFailover = true;
                        break;
					case "-o":
					case "/o":
						this._OutputFile = args[++_Index].Trim();
						break;
                    case "-s":
                    case "/s":
                        this._ColumnSeparator = args[++_Index];
                        break;
                    case "-a":
                    case "/a":
                        UInt16.TryParse(args[++_Index], out this._PacketSize);
                        if (this.PacketSize < 512)
                        {
                            throw new ArgumentException(String.Concat("Invalid PacketSize value: ",
                                this.PacketSize, "; the value must be between 512 and 32767."), "-a");
                        }
						break;
                    case "-u":
                    case "/u":
                        this._OutputEncoding = new UnicodeEncoding();
                        break;
                    case "-i":
                    case "/i":
                        if ((args.Length >= (_Index + 2))
                            && !args[_Index + 1].StartsWith("-", StringComparison.Ordinal)
                            && !args[_Index + 1].StartsWith("/", StringComparison.Ordinal))
                        {
                            foreach(string _File in args[++_Index].Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                            {
                                if (File.Exists(_File))
                                {
                                    this._InputFiles.Add(_File);
                                }
                                else
                                {
                                    throw new ArgumentException(String.Concat("The input file \"", _File, "\" could not be found."), "-i");
                                }
                            }
                        }
                        break;

                    case "-an":
                    case "/an":
                        this._ApplicationName = args[++_Index];
                        break;
                    case "-af":
                    case "/af":
                        this._AttachDBFilename = args[++_Index];
                        break;
                    case "-cs":
                    case "/cs":
                        this._ConnectionString = args[++_Index];
                        break;
                    case "-ra":
                    case "/ra":
                        this._RowsAffectedDestination = args[++_Index];
                        break;
                    case "-mf":
                    case "/mf":
                        this._MessagesFile = args[++_Index].Trim();
                        break;
                    case "-ef":
                    case "/ef":
                        this._ErrorFile = args[++_Index];
                        break;
                    case "-oh":
                    case "/oh":
                        switch (args[++_Index].ToUpperInvariant())
                        {
                            case "OVERWRITE":
                                this._OutputFileAppend = false;
                                break;
                            case "APPEND":
                                this._OutputFileAppend = true;
                                break;
                            case "ERROR":
                                // The existence check cannot be done immediately due to no enforced
                                // order of input parameters: "-o" might not have been parsed yet.
                                this._CheckForExistingOutputFile = true;
                                break;
                            default:
                                throw new ArgumentException(String.Concat("Invalid OutputFileHandling value: ",
                                    args[_Index], ".\nValid values are: Overwrite, Append, and Error."), "-oh");
                        }
                        break;
                    case "-help":
					case "-?":
					case "/help":
					case "/?":
						this._DisplayUsage = true;
						break;
					default:
						throw new ArgumentException("Invalid parameter specified.", args[_Index]);
                } // switch (args[_Index])
            } // for (int _Index = 0; _Index < args.Length; _Index++)

            if (!this.DisplayUsage)
            {
                ValidateParameters();
            }
        } // public InputParameters(string[] args)


        private void ValidateParameters()
        {
            if (this.InputFiles.Count > 0 && this.Query != String.Empty)
            {
                throw new ArgumentException("The -i and -Q switches are mutually exclusive.\nPlease specify only one of those.");
            }

            if (this.InputFiles.Count == 0 && this.Query == String.Empty)
            {
                throw new ArgumentException("No query has been specified.\nPlease use the -Q switch to pass in a query batch\nor specify one or more files using the -i switch.");
            }

            if (this.InputFiles.Count > 0)
            {
                FileInfo _TempFile;
                bool _AllFilesEmpty = true;

                foreach (string _File in this.InputFiles)
                {
                    _TempFile = new FileInfo(_File);

                    if (_TempFile.Length > 0)
                    {
                        _AllFilesEmpty = false;
                        break;
                    }
                }

                if (_AllFilesEmpty)
                {
                    throw new ArgumentException("All of the input files specified are empty.\nPlease specify one or more non-empty files,\nor use the -Q switch to specify a query.");
                }
            }

            if (this.OutputFile != String.Empty)
            {
                CheckOutputFilePath(this.OutputFile);
            }

            if (this._CheckForExistingOutputFile && this.OutputFile != String.Empty)
            {
                CheckForExistingOutputFile(this.OutputFile);
            }

            return;
        }

        private static void CheckForExistingOutputFile(string OutputFile)
        {
            if (File.Exists(OutputFile))
            {
                throw new IOException("The results output file:\n\"" + OutputFile + "\"\nalready exists.");
            }

            return;
        }

        private static void CheckOutputFilePath(string OutputFile)
        {
            if (File.Exists(OutputFile))
            {
                // If the file already exists, open it for append but don't append anything (i.e. check for permissions)
                using (FileStream _CheckFile = File.Open(OutputFile, FileMode.Open, FileAccess.Write, FileShare.Read))
                {
                    _CheckFile.Close();
                }
            }
            else
            {
                // try to create the file. if successful, delete it.
                using (FileStream _CheckFile = File.Open(OutputFile, FileMode.Create, FileAccess.Write, FileShare.Read))
                {
                    _CheckFile.Close();
                }

                File.Delete(OutputFile);
            }

            return;
        }
    }
}
