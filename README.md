**SimpleSqlExec** is a lightweight tool for running queries on SQL Server. It is not intended to run queries against any other RDBMS. It is mainly intended to replace SQLCMD to use the .NET SqlConnection instead of ODBC, and to have no external dependencies. This can be especially useful when deploying an application with [SQL Server Express LocalDB](https://msdn.microsoft.com/en-us/library/hh510202.aspx) (more info here: [Local Data Overview](https://msdn.microsoft.com/en-us/library/ms233817.aspx) ).

The goal is to provide functionality similar to SQLCMD, but nothing related to being interactive, or reporting client statistics, etc.

Eventually **SimpleSqlExec** will allow for options such as:

* multiple batches
* specifying the batch separater (`-c` option for SQLCMD; default = `GO`)
* "Batch Abort" (`-b` option for SQLCMD)
* Passing in variables  (`-v` option for SQLCMD)

---

**SQLCMD options that will _not_ be implemented:**

* `-I` to turn on QUOTED_IDENTIFIER
* `-q` "cmdline query"
* `-L[c]` list local servers
* `-z` "new_password"

**Connection String keywords that will _not_ be implemented:**

* `Asynchronous Processing` / `Async`
* `Context Connection`
* `MultipleActiveResultSets`
* `Persist Security Info` / `PersistSecurityInfo`
* `Transaction Binding`


Please see the [Wiki](../../wiki) for additional details.
