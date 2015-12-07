@ECHO OFF
CLS
SETLOCAL ENABLEDELAYEDEXPANSION
SET SeparatorLine=---------------------------------------------------------------
SET TestMessageIndicator=#####

ECHO.
SET /P SSEtestServer=Please enter in the test Server (leave blank for "(LOCAL)"): 
IF "%SSEtestServer%" == "" SET SSEtestServer=(LOCAL)

SET /P SSEtestDatabase=Please enter in the test Database (leave blank for "tempdb"): 
IF "%SSEtestDatabase%" == "" SET SSEtestDatabase=tempdb

SET /P SSEtestLogin=Please enter in the test SQL Server Login (leave blank for "test"): 
IF "%SSEtestLogin%" == "" SET SSEtestLogin=test

SET /P SSEtestPassword=Please enter in the test SQL Server Login's Password (leave blank for "test"): 
IF "%SSEtestPassword%" == "" SET SSEtestPassword=test

ECHO.
SET /P SSEskipToSection=Please enter in the test section to start at (leave blank for "all"): 
IF "%SSEskipToSection%" == "" GOTO AllTests
IF "%SSEskipToSection%" == "messages" GOTO MessagesTests

ECHO %SeparatorLine%

:AllTests
REM ------------------------------------------------------
REM General Tests

ECHO.
ECHO %TestMessageIndicator% Success: Display Usage

SimpleSqlExec.exe

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE

REM Case 2
ECHO.
ECHO %TestMessageIndicator% Success: Display Usage

SimpleSqlExec.exe -?

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE

REM Case 3
ECHO.
ECHO %TestMessageIndicator% Success: Display Usage

SimpleSqlExec.exe -help

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE

REM Case 4
ECHO.
ECHO %TestMessageIndicator% ERROR: Invalid parameter specified.
ECHO %TestMessageIndicator% Parameter name: -zzz

SimpleSqlExec.exe -zzz

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE

REM Case 5
ECHO.
ECHO %TestMessageIndicator% ERROR: Invalid Query / Command Timeout value: -12; the value must be ^>= 0.
ECHO %TestMessageIndicator% Parameter name: -t

SimpleSqlExec.exe -t -12

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE


REM ------------------------------------------------------
REM Query source tests

ECHO %TestMessageIndicator% No query or input file specified.
ECHO.
ECHO %TestMessageIndicator% ERROR: No query has been specified.
ECHO %TestMessageIndicator% Please use the -Q switch to pass in a query batch
ECHO %TestMessageIndicator% or specify one or more files using the -i switch.

SimpleSqlExec.exe -t 5

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -Q with no query text
ECHO.
ECHO %TestMessageIndicator% ERROR: No query has been specified.
ECHO %TestMessageIndicator% Please use the -Q switch to pass in a query batch
ECHO %TestMessageIndicator% or specify one or more files using the -i switch.

SimpleSqlExec.exe -Q

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -Q with empty query text
ECHO.
ECHO %TestMessageIndicator% ERROR: No query has been specified.
ECHO %TestMessageIndicator% Please use the -Q switch to pass in a query batch
ECHO %TestMessageIndicator% or specify one or more files using the -i switch.

SimpleSqlExec.exe -Q ""

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -Q with empty query text AND -i with no files specified
ECHO.
ECHO %TestMessageIndicator% ERROR: No query has been specified.
ECHO %TestMessageIndicator% Please use the -Q switch to pass in a query batch
ECHO %TestMessageIndicator% or specify one or more files using the -i switch.

SimpleSqlExec.exe -Q "" -i

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -Q with empty query text AND -i with non-existant file specified
ECHO.
ECHO %TestMessageIndicator% ERROR: The input file "_not_found.duh" could not be found.
ECHO %TestMessageIndicator% Parameter name: -i

SimpleSqlExec.exe -Q "" -i _not_found.duh

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -Q with non-empty query text AND -i with non-existant file specified
ECHO.
ECHO %TestMessageIndicator% ERROR: The input file "_not_found.duh" could not be found.
ECHO %TestMessageIndicator% Parameter name: -i

SimpleSqlExec.exe -Q "a" -i _not_found.duh

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -Q with empty query text AND -i with empty file specified
ECHO.
ECHO %TestMessageIndicator% ERROR: No query has been specified.
ECHO %TestMessageIndicator% Please use the -Q switch to pass in a query batch
ECHO %TestMessageIndicator% or specify one or more files using the -i switch.

SimpleSqlExec.exe -Q "" -i TestQuery2.sql

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -Q with non-empty query text AND -i with non-empty file specified
ECHO.
ECHO %TestMessageIndicator% ERROR: The -i and -Q switches are mutually exclusive.
ECHO %TestMessageIndicator% Please specify only one of those.

SimpleSqlExec.exe -Q "a" -i TestQuery1.sql

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.






REM ------------------------------------------------------
REM Connection-related Parameters Tests


ECHO %TestMessageIndicator% No Connection parameters passed in!
ECHO %TestMessageIndicator% Test only works if a default instance exists on the local machine.
ECHO.
ECHO %TestMessageIndicator% ERROR: Could not find stored procedure 's'.
ECHO
ECHO %TestMessageIndicator% Error Number:    2812
ECHO %TestMessageIndicator% Error Level:     16
ECHO %TestMessageIndicator% Error State:     62
ECHO %TestMessageIndicator% Error Procedure:
ECHO %TestMessageIndicator% Error Line:      1
ECHO %TestMessageIndicator% HRESULT:         -2146232060

SimpleSqlExec.exe -K a -Q "s"

ECHO %TestMessageIndicator% ErrorLevel should be: 4
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

REM Connect using all defaults:
REM Server should be "(LOCAL)" which only works if there is a default instance installed locally
REM Security is "Trusted Connection" which requires Windows Authentication
REM Database should be the Login's default database
ECHO %TestMessageIndicator% Default Server, security (trusted connection), and Database
ECHO.
SimpleSqlExec.exe -Q "SELECT @@SERVERNAME AS [ServerName], DB_NAME() AS [DatabaseName], ORIGINAL_LOGIN() AS [Login];"

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

REM Connect to specified Server and Login's default database
ECHO %TestMessageIndicator% Specified Server; Default security (trusted connection), and Database
ECHO.
SimpleSqlExec.exe -Q "SELECT @@SERVERNAME AS [ServerName], DB_NAME() AS [DatabaseName], ORIGINAL_LOGIN() AS [Login];" -S %SSEtestServer%

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

REM Connect to specified Server and specified database
ECHO %TestMessageIndicator% Specified Server and Database; Default security (trusted connection)
ECHO.
SimpleSqlExec.exe -Q "SELECT @@SERVERNAME AS [ServerName], DB_NAME() AS [DatabaseName], ORIGINAL_LOGIN() AS [Login];" -S %SSEtestServer% -d %SSEtestDatabase%

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

REM Connect to specified Server and specified database using specified SQL Server Login (no Password)
ECHO %TestMessageIndicator% Specified Server, specified Database, and specified SQL Server Login (no Password)
ECHO.
SimpleSqlExec.exe -Q "SELECT @@SERVERNAME AS [ServerName], DB_NAME() AS [DatabaseName], ORIGINAL_LOGIN() AS [Login];" -S %SSEtestServer% -d %SSEtestDatabase% -U %SSEtestLogin%

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

REM Connect to specified Server and specified database using specified SQL Server Login (empty Password)
ECHO %TestMessageIndicator% Specified Server, specified Database, and specified SQL Server Login (empty Password)
ECHO.
SimpleSqlExec.exe -Q "SELECT @@SERVERNAME AS [ServerName], DB_NAME() AS [DatabaseName], ORIGINAL_LOGIN() AS [Login];" -S %SSEtestServer% -d %SSEtestDatabase% -U %SSEtestLogin% -P

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

REM Connect to specified Server and specified database using specified SQL Server Login (empty Password but extra A)
ECHO %TestMessageIndicator% Specified Server, specified Database, and specified SQL Server Login (empty Password but extra A)
ECHO.
SimpleSqlExec.exe -Q "SELECT @@SERVERNAME AS [ServerName], DB_NAME() AS [DatabaseName], ORIGINAL_LOGIN() AS [Login];" -S %SSEtestServer% -d %SSEtestDatabase% -U %SSEtestLogin% -P -test

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

REM Connect to specified Server and specified database using specified SQL Server Login (empty Password but extra B)
ECHO %TestMessageIndicator% Specified Server, specified Database, and specified SQL Server Login (empty Password but extra B)
ECHO.
SimpleSqlExec.exe -Q "SELECT @@SERVERNAME AS [ServerName], DB_NAME() AS [DatabaseName], ORIGINAL_LOGIN() AS [Login];" -S %SSEtestServer% -d %SSEtestDatabase% -U %SSEtestLogin% -P /test

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

REM Connect to specified Server and specified database using specified SQL Server Login (incorrect Password)
ECHO %TestMessageIndicator% Specified Server, specified Database, and specified SQL Server Login (incorrect Password)
ECHO.
SimpleSqlExec.exe -Q "SELECT @@SERVERNAME AS [ServerName], DB_NAME() AS [DatabaseName], ORIGINAL_LOGIN() AS [Login];" -S %SSEtestServer% -d %SSEtestDatabase% -U %SSEtestLogin% -P $!9878979dfghdjfhgkjdfhgkjdhfkg~~~~~~test29384293402sdfsd$

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

REM Connect to specified Server and specified database using specified SQL Server Login
ECHO %TestMessageIndicator% Specified Server, specified Database, and specified SQL Server Login
ECHO.
SimpleSqlExec.exe -Q "SELECT @@SERVERNAME AS [ServerName], DB_NAME() AS [DatabaseName], ORIGINAL_LOGIN() AS [Login];" -S %SSEtestServer% -d %SSEtestDatabase% -U %SSEtestLogin% -P %SSEtestPassword%

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.



REM Connect to specified Server and Login's default database using ConnectionString
ECHO %TestMessageIndicator% Specified Server; Default security (trusted connection), and Database via ConnectionString
ECHO.
SimpleSqlExec.exe -Q "SELECT @@SERVERNAME AS [ServerName], DB_NAME() AS [DatabaseName], ORIGINAL_LOGIN() AS [Login];" -cs "Data Source=%SSEtestServer%; Integrated Security=true;"

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

REM Connect to specified Server and specified database using ConnectionString
ECHO %TestMessageIndicator% Specified Server and specified Database; Default security (trusted connection) via ConnectionString
ECHO.
SimpleSqlExec.exe -Q "SELECT @@SERVERNAME AS [ServerName], DB_NAME() AS [DatabaseName], ORIGINAL_LOGIN() AS [Login];" -cs "Data Source=%SSEtestServer%; Initial Catalog=%SSEtestDatabase%; Integrated Security=true;"

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


REM ------------------------------------------------------
REM Displayed Result Set Tests

ECHO %TestMessageIndicator% One result set, one row, one column
ECHO.
SimpleSqlExec.exe -Q "SELECT 1 AS [Col1];"

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

ECHO %TestMessageIndicator% Two result sets, one row, various columns
ECHO.
SimpleSqlExec.exe -Q "SELECT 1 AS [Col1], 2 AS [Col2];SELECT GETDATE() AS [Col1b];"

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

ECHO %TestMessageIndicator% Two result sets, one row, two columns, Unicode string
ECHO.
SimpleSqlExec.exe -Q "SELECT 1 AS [Col1], 2 AS [Col2];SELECT GETDATE() AS [Col1b], NCHAR(7777) AS [Col2b];"

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


:MessagesTests
REM ------------------------------------------------------
REM Messages File Tests

ECHO %TestMessageIndicator% No capturing of Messages
ECHO.
ECHO.
SimpleSqlExec.exe -Q "PRINT 5;"

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

ECHO %TestMessageIndicator% Create new messages file
ECHO.
IF EXIST messages.txt DEL /Q messages.txt
SimpleSqlExec.exe -Q "PRINT 5;" -mf messages.txt
type messages.txt
ECHO.

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

ECHO %TestMessageIndicator% Overwrite existing messages file
ECHO.
SimpleSqlExec.exe -Q "PRINT 6;" -mf messages.txt
type messages.txt
ECHO.

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

ECHO %TestMessageIndicator% Overwrite existing messages file; Unicode character; non-Unicode encoding
ECHO.
SimpleSqlExec.exe -Q "PRINT '7' + NCHAR(7777);" -mf messages.txt
type messages.txt
ECHO.

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% Overwrite existing messages file; Unicode character; Unicode encoding
ECHO.
SimpleSqlExec.exe -Q "PRINT '8' + NCHAR(7777);" -mf messages.txt -u
type messages.txt
ECHO.

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.



REM ------------------------------------------------------
REM Error Handling as it relates to timing of Messages Tests

ECHO %TestMessageIndicator% Interleaved results and messages; no errors
ECHO.
SimpleSqlExec.exe -Q "SELECT 1 AS [Col1]; PRINT 5; SELECT 2 AS [Col2]; PRINT 6;" -mf messages.txt
type messages.txt
ECHO.

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

ECHO %TestMessageIndicator% Interleaved results and messages; error at the end
ECHO.
SimpleSqlExec.exe -Q "SELECT 11 AS [Col1]; PRINT 55; SELECT 22 AS [Col2]; PRINT 65; RAISERROR('test1', 16, 1);" -mf messages.txt
type messages.txt
ECHO.

ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

ECHO %TestMessageIndicator% Interleaved results and messages; error between PRINT statements
ECHO.
SimpleSqlExec.exe -Q "SELECT 111 AS [Col1]; PRINT 58; RAISERROR('test2', 16, 1); SELECT 222 AS [Col2]; PRINT 68;" -mf messages.txt
type messages.txt
ECHO.

ECHO ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% Interleaved results and messages in a stored proc; error between PRINT statements
ECHO.
SimpleSqlExec.exe -Q "EXEC ('CREATE PROCEDURE #tmp AS SELECT 112 AS [Col1]; PRINT 59; RAISERROR(''test3'', 16, 1); SELECT 223 AS [Col2]; PRINT 69;'); EXEC #tmp;" -mf messages.txt
type messages.txt
ECHO.

ECHO ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

