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
using System.Text;

namespace SimpleSqlExec
{
    class Capture
    {
        internal static int _RowsAffected = 0;
        public static string MessagesFile = String.Empty;
        public static Encoding OutputEncoding;

        internal static void StatementCompletedHandler(object Sender,
            StatementCompletedEventArgs EventInfo)
        {
            _RowsAffected += EventInfo.RecordCount;

            return;
        }

        internal static void InfoMessageHandler(object Sender,
            SqlInfoMessageEventArgs EventInfo)
        {
            File.AppendAllText(MessagesFile, EventInfo.Message + "\n", OutputEncoding);

            return;
        }
    
    }
}
