@ECHO OFF
CLS
SETLOCAL ENABLEDELAYEDEXPANSION
SET SeparatorLine=---------------------------------------------------------------

SQLCMD -Q "SELECT 1/1; SELECT 1 AS [g];" -b

ECHO.
ECHO ErrorLevel = %ERRORLEVEL%
REM ECHO ErrorLevel = !ERRORLEVEL!
ECHO %SeparatorLine%
ECHO.

ECHO "no -b"
SQLCMD -Q "SELECT 1/0; SELECT 1 AS [g];"

ECHO.
ECHO ErrorLevel = %ERRORLEVEL%
REM ECHO ErrorLevel = !ERRORLEVEL!
ECHO %SeparatorLine%
ECHO.


ECHO "with -b"
SQLCMD -Q "SELECT 1/0; SELECT 1 AS [g];" -b

ECHO.
ECHO ErrorLevel = %ERRORLEVEL%
REM ECHO ErrorLevel = !ERRORLEVEL!
ECHO %SeparatorLine%
ECHO.


SQLCMD -Q "RAISERROR('16', 16, 1);" -b

ECHO.
ECHO ErrorLevel = %ERRORLEVEL%
REM ECHO ErrorLevel = !ERRORLEVEL!
ECHO %SeparatorLine%
ECHO.


SQLCMD -Q "RAISERROR('5 only', 5, 1);"

ECHO.
ECHO ErrorLevel = %ERRORLEVEL%
REM ECHO ErrorLevel = !ERRORLEVEL!
ECHO %SeparatorLine%
ECHO.


SQLCMD -Q "RAISERROR('5 with -b', 5, 1);" -b

ECHO.
ECHO ErrorLevel = %ERRORLEVEL%
REM ECHO ErrorLevel = !ERRORLEVEL!
ECHO %SeparatorLine%
ECHO.


SQLCMD -Q "RAISERROR('5 with -m 6 only', 5, 1);" -m 6

ECHO.
ECHO ErrorLevel = %ERRORLEVEL%
REM ECHO ErrorLevel = !ERRORLEVEL!
ECHO %SeparatorLine%
ECHO.


SQLCMD -Q "RAISERROR('5 with -m 6 AND -b', 5, 1);" -b -m 6

ECHO.
ECHO ErrorLevel = %ERRORLEVEL%
REM ECHO ErrorLevel = !ERRORLEVEL!
ECHO %SeparatorLine%
ECHO.


SQLCMD -Q "RAISERROR('5 with -V 6 only', 5, 1);" -V 6

ECHO.
ECHO ErrorLevel = %ERRORLEVEL%
REM ECHO ErrorLevel = !ERRORLEVEL!
ECHO %SeparatorLine%
ECHO.


SQLCMD -Q "RAISERROR('5 with -V 6 AND -b', 5, 1);" -b -V 6

ECHO.
ECHO ErrorLevel = %ERRORLEVEL%
REM ECHO ErrorLevel = !ERRORLEVEL!
ECHO %SeparatorLine%
ECHO.


SQLCMD -Q "RAISERROR('5 with -V 4 only', 5, 1);" -V 4

ECHO.
ECHO ErrorLevel = %ERRORLEVEL%
REM ECHO ErrorLevel = !ERRORLEVEL!
ECHO %SeparatorLine%
ECHO.


SQLCMD -Q "RAISERROR('5 with -V 4 AND -b', 5, 1);" -b -V 4

ECHO.
ECHO ErrorLevel = %ERRORLEVEL%
REM ECHO ErrorLevel = !ERRORLEVEL!
ECHO %SeparatorLine%
ECHO.


SQLCMD -Q "SELECT 1/0; SELECT 1 AS [g];" -b -V 4

ECHO.
ECHO ErrorLevel = %ERRORLEVEL%
REM ECHO ErrorLevel = !ERRORLEVEL!
ECHO %SeparatorLine%
ECHO.


SQLCMD -i TestQuery1.sql,TestQuery3.sql

ECHO.
ECHO ErrorLevel = %ERRORLEVEL%
REM ECHO ErrorLevel = !ERRORLEVEL!
ECHO %SeparatorLine%
ECHO.






