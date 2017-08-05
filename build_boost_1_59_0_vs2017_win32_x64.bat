@ECHO OFF
SETLOCAL

REM time measurement start
set start=%time%

ECHO ###############################################################################
ECHO ########################## -BUILDING BJAM BINARIES- ###########################
ECHO ###############################################################################
REM Save a copy of current directory
SET MYPATH="%CD%"

REM Change directory to directory of batch file resides
if exist .\b2.exe del .\b2.exe
if exist .\bjam.exe del .\bjam.exe
call .\bootstrap.bat

if exist .\tools\build\src\tools\mpi.jam MOVE .\tools\build\src\tools\mpi.jam .\tools\build\src\tools\mpi.jam_backup 
COPY E:\Softwares\boost_build\mpi.jam .\tools\build\src\tools

if exist .\bin.v2 rmdir .\bin.v2 /s/q
if exist ..\bin rmdir ..\bin /s/q
ECHO ###############################################################################
ECHO ########## -BUILDING BOOST LIBRARIES 32bit **RUNTIME-LINK = ALL**- ############
ECHO ###############################################################################
if exist .\stage_x86 rmdir .\stage_x86 /s/q
REM Update project-config.jam
if exist .\project-config.jam del .\project-config.jam
ECHO import option ;> project-config.jam
ECHO.>>project-config.jam
ECHO using msvc : 14.1 : "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.10.25017\bin\HostX86\x86\cl.exe" ;>> project-config.jam
ECHO.>>project-config.jam
ECHO option.set keep-going : false ;>> project-config.jam
ECHO.>>project-config.jam
ECHO using mpi ; >>project-config.jam

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
b2.exe --toolset=msvc-14.1 --clean-all
b2.exe --toolset=msvc-14.1 architecture=x86 address-model=32 --stagedir=".\stage_x86" threading=multi --build-type=complete stage

if exist .\bin.v2 rmdir .\bin.v2 /s/q
ECHO ###############################################################################
ECHO ########## -BUILDING BOOST LIBRARIES 64bit **RUNTIME-LINK = ALL**- ############
ECHO ###############################################################################
if exist .\stage_x64 rmdir \stage_x64 /s/q
REM Update project-config.jam
if exist .\project-config.jam del .\project-config.jam
ECHO import option ;> project-config.jam
ECHO.>>project-config.jam
ECHO using msvc : 14.1 : "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.10.25017\bin\HostX64\x64\cl.exe" ;>> project-config.jam
ECHO.>>project-config.jam
ECHO option.set keep-going : false ;>> project-config.jam
ECHO.>>project-config.jam
ECHO using mpi ; >>project-config.jam

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
b2.exe --toolset=msvc-14.1 --clean-all
b2.exe --toolset=msvc-14.1 architecture=x86 address-model=64 --stagedir=".\stage_x64" threading=multi --build-type=complete stage

CD %MYPATH%

REM time measurement end
set end=%time%
set options="tokens=1-4 delims=:.,"
for /f %options% %%a in ("%start%") do set start_h=%%a&set /a start_m=100%%b %% 100&set /a start_s=100%%c %% 100&set /a start_ms=100%%d %% 100
for /f %options% %%a in ("%end%") do set end_h=%%a&set /a end_m=100%%b %% 100&set /a end_s=100%%c %% 100&set /a end_ms=100%%d %% 100

set /a hours=%end_h%-%start_h%
set /a mins=%end_m%-%start_m%
set /a secs=%end_s%-%start_s%
set /a ms=%end_ms%-%start_ms%
if %ms% lss 0 set /a secs=%secs%-1 & set /a ms=100%ms%
if %secs% lss 0 set /a mins=%mins%-1 & set /a secs=60%secs%
if %mins% lss 0 set /a hours=%hours%-1 & set /a mins=60%mins%
if %hours% lss 0 set /a hours=24%hours%
if 1%ms% lss 100 set ms=0%ms%

set /a totalsecs = %hours%*3600 + %mins%*60 + %secs% 

if %secs% lss 10 set secs=0%secs%
if %mins% lss 10 set mins=0%mins%
if %hours% lss 10 set hours=0%hours%

ECHO
ECHO It took %hours%:%mins%:%secs%.%ms% (%totalsecs%.%ms%s total) to build

ENDLOCAL
@ECHO ON
