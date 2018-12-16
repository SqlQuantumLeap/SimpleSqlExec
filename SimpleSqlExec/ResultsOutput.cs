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
        public OutputDisplay()
        {
            Helpers.Debug("Setting up output to Console.");

            return;
        }

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

        public OutputFile(string FileName, bool Append, Encoding OutputEncoding)
        {
            Helpers.Debug("Setting up output to File.");

            this._FileName = FileName;
            this._Append = Append;

            //_OutputFile = new FileStream(InputParams.OutputFile, FileMode.Create, FileAccess.ReadWrite, FileShare.Read);
            this._OutputFile = new StreamWriter(FileName, Append, OutputEncoding);

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
