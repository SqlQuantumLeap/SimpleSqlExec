**SimpleSqlExec** is a lightweight tool for running queries on SQL Server. It is not intended to run queries against any other RDBMS. It is mainly intended to replace SQLCMD to use the .NET SqlConnection instead of ODBC, and to have no external dependencies. This can be especially useful when deploying an application with [SQL Server Express LocalDB](https://msdn.microsoft.com/en-us/library/hh510202.aspx) (more info here: [Local Data Overview](https://msdn.microsoft.com/en-us/library/ms233817.aspx) ).

The goal is to provide functionality similar to SQLCMD, but nothing related to being interactive or reporting, etc.

---

Please see the [Wiki](../../wiki) for additional details.
