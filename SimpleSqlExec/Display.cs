/*
 * "Simple SQL Exec"
 * Copyright (c) 2015 Sql Quantum Leap. All rights reserved.
 * 
 */
using System;

namespace SimpleSqlExec
{
    internal class Display
    {
        internal static void Error(string ErrorMessage)
        {
            Console.Beep();

            //Console.ForegroundColor = ConsoleColor.Red;
            Console.Error.Write("\n\tERROR: ");
            //Console.ResetColor();

            Console.Error.WriteLine(ErrorMessage.Replace("\n", "\n\t") + "\n");

            return;
        }

        internal static void Usage()
        {
            Console.WriteLine("\nSimple SQL Exec");
            Console.Write("Version ");
            Console.WriteLine(System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString(3));
            Console.WriteLine("Copyright (c) 2015 Sql Quantum Leap. All rights reserved.\n");

            Console.WriteLine("Usage: SimpleSqlExec\n");

            Console.ForegroundColor = ConsoleColor.White;
            Console.WriteLine("\tFunctionality mirroring SQLCMD behavior:");
            Console.ResetColor();
            Console.WriteLine("\t-U \"User ID\" (if not present then -E / trusted_connection is used)");
            Console.WriteLine("\t-P \"Password\"");
            Console.WriteLine("\t-S \"Server\"");
            Console.WriteLine("\t-d \"Database name\"");
            Console.WriteLine("\t-H \"Workstation name\"");
            Console.WriteLine("\t-Q \"Query\"");
            Console.WriteLine("\t-l \"Login (i.e. connection) timeout\" (default: \"15\")");
            Console.WriteLine("\t-t \"Query (i.e. command) timeout\" (default: \"30\")");
            Console.WriteLine("\t-K \"Application intent\" (\"ReadOnly\" or \"ReadWrite\"; default: \"ReadWrite\")");
            Console.WriteLine("\t-N Encrypt Connection (default: false)");
            Console.WriteLine("\t-C Trust Server Certificate (default: false)");
            Console.WriteLine("\t-M MultiSubnet Failover (default: false)");
            Console.WriteLine("\t-o \"Output file\"");
            Console.WriteLine("\t-s \"Column separator\" (default: \" \")");
            Console.WriteLine("\t-a \"packet size\" (range: 512 - 32767; default: \"4096\" {default for .NET SqlConnection = \"8000\"!})");
            Console.WriteLine("\t-u Unicode (UTF-16 LE) Output file and Messages File");
            Console.WriteLine("\t-i \"Input file[,input file2...]\"");
            Console.WriteLine("\t-c \"Batch terminator\" (default: \"GO\")");

            Console.WriteLine("\t-? / -help / (no command-line options) Display usage");
            Console.WriteLine("");

            Console.ForegroundColor = ConsoleColor.White;
            Console.WriteLine("\tFunctionality unique to SimpleSqlExec:");
            Console.ResetColor();
            Console.WriteLine("\t-ad \"Attach DB filename\"");
            Console.WriteLine("\t-an \"Application name\" (default: \"Simple SQL Exec\")");
            Console.WriteLine("\t-cs \"Connection string\"");
            Console.WriteLine("\t-ra \"Rows Affected file path or User environment variable name\"");
            Console.WriteLine("\t-mf \"Messages file\"");
            Console.WriteLine("\t-oh \"Output file handling\" (OverWrite, Append, or Error)");
            Console.WriteLine("\t-debug \"Debug info file\"");
            Console.WriteLine("");            

            Console.WriteLine("Notes:");
            Console.WriteLine("\tCommand-line option names are case-sensitive.");
            Console.WriteLine("\tEnvironment variable names are not case-sensitive.\n");

            Console.WriteLine("Visit http://SqlQuantumLeap.com for other useful utilities and more.");

            return;
        }
    
    }
}
