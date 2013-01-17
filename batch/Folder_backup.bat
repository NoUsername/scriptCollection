set startdir="%~dp0"
set targetDir=%startdir%
:: name of what you are backing up (used in zip filename)
set CONTENTNAME="ImportantStuff"


:: the file will be first created in a temp dir (because it could be changed multiple times in a row)
:: and only when this is finished it is copied to the destination folder
set TEMPDIR=C:\temp\
:: cd /D "%targetDir%"

call:getFormattedTime

:: zip
set ZIPFILE=%TEMPDIR%%CONTENTNAME%_backup_%datestring%.zip
set ZIPEXE="C:\Program Files (x86)\7-Zip\7z.exe"
if not exist %ZIPEXE% (
set ZIPEXE="C:\Program Files\7-Zip\7z.exe"
)
set ARGS=-tzip


:: first go to the parent folder of the one we want to back up
cd /D "C:\temp\example\basefolder"

:: now add that folder (with full content)
%ZIPEXE% a %ARGS% %ZIPFILE% "FolderToBackUp"

:: this can be done multiple times from different folders because it will be added to the zip:
%ZIPEXE% a %ARGS% %ZIPFILE% "FolderToBackUp2"
:: cd /D "C:\anotherfolder"
:: %ZIPEXE% a %ARGS% %ZIPFILE% "AnotherFolderFromSomewhereElse"

:: copy the backup zip to the final location (e.g. a dropbox folder)
copy %ZIPFILE% "C:\Users\Example\Dropbox\backup"
:: delete file
del %ZIPFILE%
pause

:: Works on any NT/2k machine independent of regional date settings
:: gets a nice date-string (sortable) like: 2012-06-30
:getFormattedTime
@ECHO off
set v_day=
set v_month=
set v_year=

SETLOCAL ENABLEEXTENSIONS
if "%date%A" LSS "A" (set toks=1-3) else (set toks=2-4)
::DEBUG echo toks=%toks%
  for /f "tokens=2-4 delims=(-)" %%a in ('echo:^|date') do (
::DEBUG echo first token=%%a
	if "%%a" GEQ "A" (
	  for /f "tokens=%toks% delims=.-/ " %%i in ('date/t') do (
		set '%%a'=%%i
		set '%%b'=%%j
		set 'yy'=%%k
	  )
	)
  )
  if %'yy'% LSS 100 set 'yy'=20%'yy'%
  set Today=%'yy'%-%'mm'%-%'dd'%

ENDLOCAL & SET v_year=%'yy'%& SET v_month=%'mm'%& SET v_day=%'dd'%

::ECHO Today is Year: [%V_Year%] Month: [%V_Month%] Day: [%V_Day%]
set datestring=%V_Year%-%V_Month%-%V_Day%
::echo %datestring%

goto:eof