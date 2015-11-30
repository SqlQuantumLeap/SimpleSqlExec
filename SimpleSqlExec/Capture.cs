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
        //internal static StringBuilder _Messages = new StringBuilder(5000);
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
            //_Messages.AppendLine(EventInfo.Message);

            File.AppendAllText(MessagesFile, EventInfo.Message, OutputEncoding);

            return;
        }
    
    }
}
