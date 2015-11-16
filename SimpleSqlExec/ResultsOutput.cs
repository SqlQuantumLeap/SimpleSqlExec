using System;
using System.IO;
//using System.Text;

namespace SimpleSqlExec
{
    internal abstract class ResultsOutput
    {
        abstract internal void Send(string Output);

        abstract internal void Dispose();
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
