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

IF "%1" == "" (
	ECHO.
	SET /P SSEskipToSection=Please enter in the test section to start at ^(leave blank for "all"^): 
) ELSE (
	SET SSEskipToSection=%1
)

ECHO.

IF "%SSEskipToSection%" == "" SET SSEskipToSection=all
IF /I "%SSEskipToSection%" == "all" GOTO AllTests
IF /I "%SSEskipToSection%" == "messages" GOTO MessagesTests
IF /I "%SSEskipToSection%" == "generalproperties" GOTO GeneralPropertiesTests
IF /I "%SSEskipToSection%" == "ConnectionParameters" GOTO ConnectionParametersTests
IF /I "%SSEskipToSection%" == "inputfile" GOTO InputFileTests
IF /I "%SSEskipToSection%" == "outputfile" GOTO OutputFileTests

ECHO %SeparatorLine%

:AllTests
REM ------------------------------------------------------
REM General Tests

ECHO %TestMessageIndicator% Success: Display Usage
ECHO.

SimpleSqlExec.exe

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

REM Case 2
ECHO %TestMessageIndicator% Success: Display Usage
ECHO.

SimpleSqlExec.exe -?

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

REM Case 3
ECHO %TestMessageIndicator% Success: Display Usage
ECHO.

SimpleSqlExec.exe -help

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

REM Case 4
ECHO %TestMessageIndicator% ERROR: Invalid parameter specified.
ECHO %TestMessageIndicator% Parameter name: -zzz

SimpleSqlExec.exe -zzz

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

REM Case 5
ECHO %TestMessageIndicator% ERROR: Invalid Query / Command Timeout value: -12; the value must be ^>= 0.
ECHO %TestMessageIndicator% Parameter name: -t
ECHO.

SimpleSqlExec.exe -t -12

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

IF /I NOT "%SSEskipToSection%" == "all" GOTO :EOF


:GeneralPropertiesTests
REM ------------------------------------------------------
REM General property tests

ECHO %TestMessageIndicator% Empty batch separator is invalid
ECHO.
SimpleSqlExec.exe -c ""
ECHO.

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% White-space-only batch separator is invalid
ECHO.
SimpleSqlExec.exe -c "      	  "
ECHO.

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% AttachDBFilename that is white-space only
ECHO %TestMessageIndicator% ERROR: No query has been specified.
ECHO %TestMessageIndicator% Please use the -Q switch to pass in a query batch
ECHO %TestMessageIndicator% or specify one or more files using the -i switch.
ECHO.
SimpleSqlExec.exe -ad "      	  "
ECHO.

ECHO %TestMessageIndicator% ErrorLevel should be: 1
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% AttachDBFilename that does not exist
ECHO %TestMessageIndicator% ERROR: The requested database file to attach:
ECHO %TestMessageIndicator% "f"
ECHO %TestMessageIndicator% cannot be found or is inaccessible.
ECHO.
SimpleSqlExec.exe -ad "f"
ECHO.

ECHO %TestMessageIndicator% ErrorLevel should be: 2
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

IF /I NOT "%SSEskipToSection%" == "all" GOTO :EOF




REM ------------------------------------------------------
REM Query source tests

ECHO %TestMessageIndicator% No query or input file specified.
ECHO %TestMessageIndicator% ERROR: No query has been specified.
ECHO %TestMessageIndicator% Please use the -Q switch to pass in a query batch
ECHO %TestMessageIndicator% or specify one or more files using the -i switch.
ECHO.

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


ECHO %TestMessageIndicator% -Q with query text of only white-space characters
ECHO.
ECHO %TestMessageIndicator% ERROR: No query has been specified.
ECHO %TestMessageIndicator% Please use the -Q switch to pass in a query batch
ECHO %TestMessageIndicator% or specify one or more files using the -i switch.

SimpleSqlExec.exe -Q "     "

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

IF /I NOT "%SSEskipToSection%" == "all" GOTO :EOF




:ConnectionParametersTests
REM ------------------------------------------------------
REM Connection-related Parameters Tests

ECHO %TestMessageIndicator% No Connection parameters passed in!
ECHO %TestMessageIndicator% Test only works if a default instance exists on the local machine.
ECHO.
ECHO %TestMessageIndicator% ERROR: Could not find stored procedure 's'.
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

IF /I NOT "%SSEskipToSection%" == "all" GOTO :EOF


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

IF /I NOT "%SSEskipToSection%" == "all" GOTO :EOF


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

IF /I NOT "%SSEskipToSection%" == "all" GOTO :EOF


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

IF /I NOT "%SSEskipToSection%" == "all" GOTO :EOF


:InputFileTests
REM ------------------------------------------------------
REM Input file tests

ECHO %TestMessageIndicator% -i with non-empty file of only white-space characters
ECHO %TestMessageIndicator% Success!
ECHO.

SimpleSqlExec.exe -i TestQuery4.sql

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -i with a single file
ECHO %TestMessageIndicator% Success!
ECHO.

SimpleSqlExec.exe -i TestQuery1.sql

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -i with two files (related files and in order)
ECHO %TestMessageIndicator% Success!
ECHO.

SimpleSqlExec.exe -i TestQuery1.sql,TestQuery3.sql

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -i with two files (related files and out of order)
ECHO %TestMessageIndicator% ERROR: Invalid object name '#SimpleSqlExec'.
ECHO %TestMessageIndicator% Error Number:    208
ECHO %TestMessageIndicator% Error Level:     16
ECHO %TestMessageIndicator% Error State:     0
ECHO %TestMessageIndicator% Error Procedure:
ECHO %TestMessageIndicator% Error Line:      1
ECHO %TestMessageIndicator% HRESULT:         -2146232060
ECHO.

SimpleSqlExec.exe -i TestQuery3.sql,TestQuery1.sql

ECHO %TestMessageIndicator% ErrorLevel should be: 4
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -i with three files (related files, in order, middle file is empty and skipped)
ECHO %TestMessageIndicator% Success!
ECHO.

SimpleSqlExec.exe -i TestQuery1.sql,TestQuery4.sql,TestQuery3.sql

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.

IF /I NOT "%SSEskipToSection%" == "all" GOTO :EOF


:OutputFileTests
REM ------------------------------------------------------
REM Output file tests

ECHO %TestMessageIndicator% -i with two files (related files and in order) and -o with bad path
ECHO %TestMessageIndicator% ERROR: The given path's format is not supported.
ECHO.

SimpleSqlExec.exe -i TestQuery1.sql,TestQuery3.sql -o hh:\tt\zz.df

ECHO %TestMessageIndicator% ErrorLevel should be: 2
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -o with good path; make sure "test" file was deleted
ECHO %TestMessageIndicator% 
ECHO.

IF EXIST %TEMP%\SSE_test_output_file.txt (
	DEL /Q %TEMP%\SSE_test_output_file.txt
	ECHO Deleted existing %TEMP%\SSE_test_output_file.txt
)
IF EXIST %TEMP%\SSE_test_output_file.txt (
	ECHO File still exists. That probably shouldn't happen.
) ELSE (
	ECHO File does not exist.
)
ECHO.
REM SimpleSqlExec.exe -Q "DECLARE @Test INT;" -o %TEMP%\SSE_test_output_file.txt
SimpleSqlExec.exe -i TestQuery4.sql -o %TEMP%\SSE_test_output_file.txt
DIR /N %TEMP%\SSE_test_output_file.txt
ECHO.

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -o with good path; make sure "test" file size did not increase
ECHO %TestMessageIndicator% 
ECHO.

REM SimpleSqlExec.exe -Q "DECLARE @Test INT;" -o %TEMP%\SSE_test_output_file.txt
SimpleSqlExec.exe -i TestQuery4.sql -o %TEMP%\SSE_test_output_file.txt
DIR /N %TEMP%\SSE_test_output_file.txt
IF EXIST %TEMP%\SSE_test_output_file.txt DEL /Q %TEMP%\SSE_test_output_file.txt
ECHO.

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -o with good path; make sure result sets across multiple files work
ECHO %TestMessageIndicator% { no pre-existing output file }
ECHO.

IF EXIST results.txt (
	DEL /Q results.txt
	ECHO Deleted existing results.txt
)
SimpleSqlExec.exe -i TestQuery1.sql,TestQuery3.sql -o results.txt
DIR /N results.txt
ECHO.

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -o with good path; make sure output file OverWrite works
ECHO %TestMessageIndicator% { output file should exist }
ECHO.

IF NOT EXIST results.txt (
	ECHO results.txt file does not exist. This test is not valid without that file.
)
SimpleSqlExec.exe -Q "SELECT 'This should be the only text' AS [OverWrite];" -o results.txt
DIR /N results.txt
ECHO.

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -o with good path; make sure output file Append works
ECHO %TestMessageIndicator% { output file should exist }
ECHO.

IF NOT EXIST results.txt (
	ECHO results.txt file does not exist. This test is not valid without that file.
)
SimpleSqlExec.exe -Q "SELECT 'This should be appended text' AS [someTest];" -o results.txt -oh append
DIR /N results.txt
ECHO.

ECHO %TestMessageIndicator% ErrorLevel should be: 0
ECHO %TestMessageIndicator% ErrorLevel is:        %ERRORLEVEL%
ECHO %SeparatorLine%
PAUSE
ECHO.


ECHO %TestMessageIndicator% -o with good path; make sure output file Error(If-Exists) works
ECHO %TestMessageIndicator% { output file should exist }
ECHO.

IF NOT EXIST results.txt (
	ECHO results.txt file does not exist. This test is not valid without that file.
)
SimpleSqlExec.exe -Q "SELECT 'This should not make it to the output file' AS [ErrorIfExists];" -o results.txt -oh error
SET TempSSEErrorLevel=%ERRORLEVEL%
DIR /N results.txt
ECHO.

ECHO %TestMessageIndicator% ErrorLevel should be: 2
ECHO %TestMessageIndicator% ErrorLevel is:        %TempSSEErrorLevel%
ECHO %SeparatorLine%
PAUSE
ECHO.

IF EXIST results.txt DEL /Q results.txt
IF NOT "%SSEskipToSection%" == "all" GOTO :EOF


