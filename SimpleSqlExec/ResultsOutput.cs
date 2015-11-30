using System;
using System.Data.SqlClient;
using System.IO;
using System.Text;

namespace SimpleSqlExec
{
    internal abstract class ResultsOutput
    {
        abstract internal void Send(string Output);

        abstract internal void Dispose();

        public string GetHeader(SqlDataReader Reader, string ColumnSeparator)
        {
            if (Reader.FieldCount == 0)
            {
                return String.Empty;
            }

            if (Reader.FieldCount == 1)
            {
                return Reader.GetName(0);
            }

            StringBuilder _Header = new StringBuilder(200);
            _Header.Append(Reader.GetName(0));

            for (int _Index = 1; _Index < Reader.FieldCount; _Index++)
            {
                _Header.Append(ColumnSeparator);
                _Header.Append(Reader.GetName(_Index));
            }

            return _Header.ToString();
        }
    }

    internal class OutputDisplay : ResultsOutput
    {
        internal override void Send(string Output)
        {
            Console.WriteLine(Output);

            return;
        }

        internal override void Dispose()
        {
            throw new NotImplementedException();
        }
    }

    internal class OutputFile : ResultsOutput
    {
        //FileStream _OutputFile = null;
        private StreamWriter _OutputFile;
        private string _FileName;
        private bool _Append;

        public OutputFile(string FileName, bool Append)
        {
            this._FileName = FileName;
            this._Append = Append;

            //_OutputFile = new FileStream(InputParams.OutputFile, FileMode.Create, FileAccess.ReadWrite, FileShare.Read);
            this._OutputFile = new StreamWriter(FileName, Append); // System.Text.Encoding.

            return;
        }

        internal override void Send(string Output)
        {
            this._OutputFile.WriteLine(Output);

            return;
        }

        internal override void Dispose()
        {
            if (this._OutputFile != null)
            {
                this._OutputFile.Flush();

                this._OutputFile.Dispose();
            }

            return;
        }
    }
}
