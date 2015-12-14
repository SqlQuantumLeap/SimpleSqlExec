/*
 * "Simple SQL Exec"
 * Copyright (c) 2015 Sql Quantum Leap. All rights reserved.
 * 
 */
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

namespace SimpleSqlExec
{

    internal class QueryBatches
    {
        private class QueryBatch
        {
            public string QueryText;
            public int ExecutionCount;

            public QueryBatch(string QueryText, int ExecutionCount)
            {
                this.QueryText = QueryText;
                this.ExecutionCount = ExecutionCount;

                return;
            }
        }

        private string _BatchTerminator;
        private List<String> _InputFiles;
        private List<QueryBatch> _Batches = new List<QueryBatch>();


        public QueryBatches(InputParameters InputParams)
        {
            _BatchTerminator = InputParams.BatchTerminator;

            // add a place-holder batch in slot 1 since the first call to
            // NextBatch() will remove the first entry.
            this._Batches.Add(new QueryBatch(" { placeholder } ", 1));

            if (InputParams.InputFiles.Count > 0)
            {
                Helpers.Debug("Query from files.");
                this._InputFiles = InputParams.InputFiles;
            }
            else
            {
                Helpers.Debug("Query from input parameter.");
                ParseBatches(InputParams.Query);

                this._InputFiles = new List<string>();
            }

            return;
        }

        internal bool NextBatch()
        {
            if (this._Batches.Count > 1 || this._Batches[0].ExecutionCount > 1)
            {
                if (this._Batches[0].ExecutionCount > 1)
                {
                    Helpers.Debug("Decrement execution count.");
                    this._Batches[0].ExecutionCount--;
                }
                else
                {
                    Helpers.Debug("Moving to next batch.");
                    this._Batches.RemoveAt(0);
                }
            }
            else
            {
                if (this._InputFiles.Count > 0)
                {
                    LoadSqlFromFile();
                }
                else
                {
                    Helpers.Debug("No batches left.");
                    return false;
                }
                
            }

            // recursively check for the next non-empty batch
            if (this._Batches[0].QueryText.Trim() == String.Empty)
            {
                Helpers.Debug("Skipping processing of empty batch!");
                return NextBatch();
            }

            return true;
        }

        internal void LoadSqlFromFile()
        {
            this._Batches.Clear();

            Helpers.Debug("Loading file: " + this._InputFiles[0]);
            ParseBatches(
                File.ReadAllText(this._InputFiles[0])
                );

            // remove file from the list
            this._InputFiles.RemoveAt(0);

            return;
        }

        internal string GetBatch()
        {
            Helpers.Debug("Retrieving batch:\n\n" + _Batches[0].QueryText + "\n\n");
            Helpers.Debug("Executions left for this batch: " + _Batches[0].ExecutionCount.ToString());

            return _Batches[0].QueryText;
        }


        private void ParseBatches(string SqlToExec)
        {
            Helpers.Debug("Parsing SQL into batches...");
            string _Query;
            int _Iteration;
            string _Pattern = String.Concat(
                @"(?si)(.*?\n)??(?<=^|\n)[ \t]*",
                this._BatchTerminator,
                @"(?:[ \t]+(\d+))?[ \t]*(?:--[^\n]*)?(?:\r?\n|$)|(.*)$"
                );

            foreach (Match _Batch in Regex.Matches(SqlToExec, _Pattern))
            {
                _Query = String.Empty;

                _Query = String.Concat(_Batch.Groups[1].Value.Trim(), _Batch.Groups[3].Value.Trim());
                if (String.IsNullOrEmpty(_Query))
                {
                    Helpers.Debug("Skipping adding empty batch to the queue!");
                    continue;
                }

                if (!_Batch.Groups[2].Success
                    || !Int32.TryParse(_Batch.Groups[2].Value, out _Iteration))
                {
                    _Iteration = 1;
                }

                Helpers.Debug("Adding batch:\n\n" + _Query + "\n\n");
                Helpers.Debug("Process the batch above this many times: " + _Iteration.ToString());

                this._Batches.Add(
                    new QueryBatch(_Query, _Iteration)
                    );
            }

            return;
        }


    }
}
