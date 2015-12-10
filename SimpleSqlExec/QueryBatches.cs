/*
 * "Simple SQL Exec"
 * Copyright (c) 2015 Sql Quantum Leap. All rights reserved.
 * 
 */
using System;
using System.Collections.Generic;
using System.IO;

namespace SimpleSqlExec
{
    internal class QueryBatches
    {
        private string _BatchSeparator;
        private List<String> _InputFiles;
        private List<String> _Batches = new List<string>();

        public QueryBatches(InputParameters InputParams)
        {
            _BatchSeparator = InputParams.BatchSeparator;

            if (InputParams.InputFiles.Count > 0)
            {
                this._InputFiles = InputParams.InputFiles;
            }
            else
            {
                // add a place-holder batch in slot 1 since the first call to
                // NextBatch() will remove the first entry.
                this._Batches.Add(String.Empty);
                this._Batches.Add(InputParams.Query); // replace with batch parser method
                this._InputFiles = new List<string>();
            }

            return;
        }

        internal bool NextBatch()
        {
            if (this._Batches.Count > 1)
            {
                this._Batches.RemoveAt(0);
            }
            else
            {
                if (this._InputFiles.Count > 0)
                {
                    LoadBatchesFromFile();
                }
                else
                {
                    return false;
                }
                
            }

            // recursively check for the next non-empty batch
            if (this._Batches[0].Trim() == String.Empty)
            {
                //Console.WriteLine("skipping"); // debug
                return NextBatch();
            }

            return true;
        }

        internal void LoadBatchesFromFile()
        {
            this._Batches.Clear();

            this._Batches.Add(
                File.ReadAllText(this._InputFiles[0]) // replace with batch parsing
                );

            // remove file from the list
            this._InputFiles.RemoveAt(0);

            return;
        }

        internal string GetBatch()
        {
            return _Batches[0];
        }
    }
}
