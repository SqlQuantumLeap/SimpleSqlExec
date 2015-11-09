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
            return;
        }
    
    }
}
