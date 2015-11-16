using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace SimpleSqlExec
{
    class Capture
    {
        internal static int _RowsAffected = 0;
        internal static StringBuilder _Messages = new StringBuilder(5000);

        internal static void StatementCompletedHandler(object Sender,
            StatementCompletedEventArgs EventInfo)
        {
            _RowsAffected += EventInfo.RecordCount;

            return;
        }

        internal static void InfoMessageHandler(object Sender,
            SqlInfoMessageEventArgs EventInfo)
        {

            _Messages.AppendLine(EventInfo.Message);

            return;
        }
    
    }
}
