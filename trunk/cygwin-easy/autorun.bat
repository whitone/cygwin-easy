@echo off

rem autorun.bat - Copyright 2007 Stefano Cotta Ramusino.
rem ====================================================
rem Written by Stefano Cotta Ramusino, February 2007.
rem Modified by Stefano Cotta Ramusino, March 2007.
rem
rem Based on X.bat - Copyright 2004 Trustees of Indiana University under 
rem the GNU General Public License.
rem Written by Dick Repasky, February 2004.
rem Modified by Dick Repasky, August 2004.
rem 
rem This program is free software; you can redistribute it and/or modify it 
rem under the terms of the GNU General Public License as published by the 
rem Free Software Foundation; either version 2 of the License, or (at 
rem your option) any later version.
rem 
rem This program is distributed in the hope that it will be useful, but 
rem WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
rem or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
rem for more details.
rem 
rem You should have received a copy of the GNU General Public License along 
rem with this program; if not, write to the Free Software Foundation, Inc., 
rem 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

rem Inform the user to wait
rem -----------------------
if not "%1"=="x" echo Starting Cygwin, please wait ... 2> nul
if "%1"=="x" echo Starting Cygwin X Windows, please wait ... 2> nul
echo.

rem Check the TEMP variable
rem -----------------------
if not "%temp%"=="" set oldtemp=%temp%
if not "%temp%"=="" goto maketemp
if not "%tmp%"=="" set temp=%tmp%
if not "%temp%"=="" goto maketemp
if not "%windir%"=="" set temp=%windir%\temp
if not "%temp%"=="" goto maketemp
if exist C:\. set temp=C:\temp
if not "%temp%"=="" goto maketemp
goto errtemp

:maketemp
rem Make the temporary directories
rem ------------------------------
if not exist "%temp%" mkdir "%temp%" 2> nul
set temp=%temp%\cygwin
if not exist "%temp%" mkdir "%temp%" 2> nul
if not exist "%temp%\etc" mkdir "%temp%\etc" 2> nul
if not exist "%temp%\etc\passwd" echo. > "%temp%\etc\passwd" 2> nul
if not exist "%temp%\etc\group" echo. > "%temp%\etc\group" 2> nul
if not exist "%temp%\lnk" mkdir "%temp%\lnk" 2> nul
if not exist "%temp%\tmp" mkdir "%temp%\tmp" 2> nul
if not exist "%temp%\var" mkdir "%temp%\var" 2> nul
if not exist "%temp%\var\tmp" mkdir "%temp%\var\tmp" 2> nul
if not "%curdrive%"=="" goto runwhat
goto checkos

:checkos
rem Check the operating system
rem --------------------------
if "%os%"=="Windows_NT" goto winnt
goto win9x

:win9x
rem Determine current drive on Win9x
rem --------------------------------
rem Based on CURDRIV1.BAT by Rob van der Woude (http://www.xs4all.nl/~robw/rob/)
rem Technique by Laurence Soucy (http://bigfot.com/~batfiles)
rem
cd | choice /n /c:ABCDEFGHIJKLMNOPQRSTUVWXYZ set curdrive=> "%temp%\curdrive.bat" 2> nul
call "%temp%\curdrive.bat" 2> nul
del "%temp%\curdrive.bat" 2> nul
set curdrive=%curdrive%:
goto runwhat

:winnt
rem Determine current drive on WinNT
rem --------------------------------
set curdrive=%~d0
if not "%1"=="x" title Cygwin Easy 2> nul
if "%1"=="x" title Cygwin X Windows Easy 2> nul
goto runwhat

:runwhat
rem Check if Cygwin Easy is already configured
rem ------------------------------------------
if not exist "%temp%\lnk\remove.bat" goto sethome
if not exist "%temp%\lnk\cygwin.bat" goto sethome
if not exist "%temp%\lnk\X.bat" goto sethome
call "%temp%\lnk\remove.bat" get 2> nul
if "%unindrive%"=="" goto sethome
if "%unindrive%"=="%curdrive%" goto cygbat
goto unins

:unins
rem Remove previous Cygwin Easy configuration
rem -----------------------------------------
call "%temp%\lnk\remove.bat" 2> nul
goto maketemp

:cygbat
rem Call an already configured Cygwin Easy
rem --------------------------------------
cls
if not "%1"=="x" call "%temp%\lnk\cygwin.bat" %2
if "%1"=="x" call "%temp%\lnk\X.bat" %2
goto end

:sethome
rem Set home directory
rem ------------------
if not "%home%"=="" set oldhome=%home%
if not "%2"=="" set home=%2
if not "%2"=="" goto homepass
echo @echo off > "%temp%\lnk\cygwin.bat" 2> nul
%curdrive%\cygwin\bin\cygpath -D -w | %curdrive%\cygwin\bin\sed "s/^\(.*\)/set home=\1\r/" >> "%temp%\lnk\cygwin.bat" 2> nul
call "%temp%\lnk\cygwin.bat" 2> nul
if exist "%home%\cygwineasy.ini" goto myhome
echo @echo off > "%temp%\lnk\cygwin.bat" 2> nul
%curdrive%\cygwin\bin\cygpath -D -w | %curdrive%\cygwin\bin\sed "s/^\(.*\)/set home=\1\/cygwin\r/" >> "%temp%\lnk\cygwin.bat" 2> nul
call "%temp%\lnk\cygwin.bat" 2> nul
goto startcyg

:myhome
rem Get home directory from a settings file
rem ---------------------------------------
echo @echo off > "%temp%\lnk\cygwin.bat" 2> nul
type "%home%\cygwineasy.ini" | %curdrive%\cygwin\bin\grep -E ^HOME | %curdrive%\cygwin\bin\sed "s/^\(.*\) */set \1/" >> "%temp%\lnk\cygwin.bat" 2> nul
call "%temp%\lnk\cygwin.bat" 2> nul
goto startcyg

:homepass
rem Use home directory passed as argument
rem -------------------------------------
echo @echo off > "%temp%\lnk\cygwin.bat" 2> nul
echo set home=%home%>> "%temp%\lnk\cygwin.bat" 2> nul
goto startcyg

:startcyg
rem Start Cygwin environment
rem ------------------------
rem Based on cygmin.bat posted to the Cygwin mailing list by Fergus 
rem http://www.cygwin.com/ml.cygwin/2003-07/msg01117.html.
rem
echo @echo off > "%temp%\remount.bat" 2> nul
echo set cygtemp=%temp%>> "%temp%\remount.bat" 2> nul
%curdrive%\cygwin\bin\mount -m | %curdrive%\cygwin\bin\sed s/mount/"%%cygtemp%%\\/mount"/gi >> "%temp%\remount.bat" 2> nul
%curdrive%\cygwin\bin\u2d "%temp%/remount.bat" 2> nul
%curdrive%\cygwin\bin\umount -c > nul 2> "%temp%\umount.log"
del /q "%temp%\umount.log" 2> nul
%curdrive%\cygwin\bin\umount -A 2> nul
%curdrive%\cygwin\bin\mount -bfu %curdrive%/cygwin / 2> nul
%curdrive%\cygwin\bin\mount -bfu %curdrive%/cygwin/bin /usr/bin 2> nul
%curdrive%\cygwin\bin\mount -bfu %curdrive%/cygwin/lib /usr/lib 2> nul
%curdrive%\cygwin\bin\mount -bfu "%temp%/tmp" /tmp 2> nul
%curdrive%\cygwin\bin\mount -bfu "%temp%/var/tmp" /var/tmp 2> nul
%curdrive%\cygwin\bin\mount -t --change-cygdrive-prefix /cygdrive 2> nul
%curdrive%\cygwin\bin\bash -c "/usr/share/cygwin-easy/autorun.sh %curdrive%" 2> nul
goto makebat

:makebat
rem Create Cygwin Easy batch scripts
rem --------------------------------
echo if not "%%1"=="" set home=%%1>> "%temp%\lnk\cygwin.bat" 2> nul
echo set temp=%temp%\tmp>> "%temp%\lnk\cygwin.bat" 2> nul
echo set tmpdir=%%temp%%>> "%temp%\lnk\cygwin.bat" 2> nul
echo :chkdisk >> "%temp%\lnk\cygwin.bat" 2> nul
echo if not exist %curdrive%\cygwin echo Please insert "Cygwin Easy disk" in the drive %curdrive% >> "%temp%\lnk\cygwin.bat" 2> nul
echo if not exist %curdrive%\cygwin pause >> "%temp%\lnk\cygwin.bat" 2> nul
echo if not exist %curdrive%\cygwin echo. >> "%temp%\lnk\cygwin.bat" 2> nul
echo if not exist %curdrive%\cygwin goto chkdisk >> "%temp%\lnk\cygwin.bat" 2> nul
echo cls >> "%temp%\lnk\cygwin.bat" 2> nul
%curdrive%\cygwin\bin\cp -f /usr/share/cygwin-easy/lnk/cygwin.bat /usr/share/cygwin-easy/lnk/X.bat 2> nul 
echo %curdrive%\cygwin\bin\bash --login -i >> "%temp%\lnk\cygwin.bat" 2> nul
if "%os%"=="Windows_NT" echo title Cygwin X Windows - Right click on X in the traybar and select exit to close >> "%temp%\lnk\X.bat" 2> nul
echo echo. >> "%temp%\lnk\X.bat" 2> nul
echo echo A prompt will not return to this window until you quit X Windows. >> "%temp%\lnk\X.bat" 2> nul
echo echo To quit X Windows, right click X in the traybar and select exit. >> "%temp%\lnk\X.bat" 2> nul
echo echo. >> "%temp%\lnk\X.bat" 2> nul
echo %curdrive%\cygwin\bin\bash --login -c /usr/X11R6/bin/startxwin.sh >> "%temp%\lnk\X.bat" 2> nul
echo @echo off > "%temp%\lnk\remove.bat" 2> nul
echo if "%%1"=="get" set unindrive=%curdrive%>> "%temp%\lnk\remove.bat" 2> nul
echo if "%%1"=="get" goto end >> "%temp%\lnk\remove.bat" 2> nul
%curdrive%\cygwin\bin\cp -f /bin/cygwin1.dll /bin/umount.exe "%temp%" 2> nul
if exist "%temp%\remount.bat" %curdrive%\cygwin\bin\cp -f /bin/mount.exe "%temp%" 2> nul
echo "%temp%\umount" -c >> "%temp%\lnk\remove.bat" 2> nul
echo "%temp%\umount" -A >> "%temp%\lnk\remove.bat" 2> nul
if exist "%temp%\remount.bat" echo call "%temp%\remount.bat" >> "%temp%\lnk\remove.bat" 2> nul
if exist "%temp%\dellnk.bat" echo call "%temp%\dellnk.bat" >> "%temp%\lnk\remove.bat" 2> nul
if "%os%"=="Windows_NT" echo rmdir /s /q "%temp%" >> "%temp%\lnk\remove.bat" 2> nul
if not "%os%"=="Windows_NT" echo deltree /y "%temp%" >> "%temp%\lnk\remove.bat" 2> nul
echo :end >> "%temp%\lnk\remove.bat" 2> nul
goto truetemp

:truetemp
rem Set the temporary directory for Cygwin
rem --------------------------------------
set ortemp=%temp%
set temp=%temp%\tmp
if not "%tmpdir%"=="" set oldtmpdir=%tmpdir%
set tmpdir=%temp%
goto shell

:shell
rem Start shell
rem -----------
cls
if "%1"=="x" goto xwin
if "%1"=="console" goto console
%curdrive%\cygwin\bin\bash --login -i
goto ask

:console
rem Start console
rem -------------
cls
%curdrive%\cygwin\bin\bash --login -i
goto varrest

:xwin
rem Start X Windows
rem ---------------
if "%os%"=="Windows_NT" title X Windows - Right click on X in the traybar and select exit to close 2> nul
echo.
echo A prompt will not return to this window until you quit X Windows.
echo To quit X Windows, right click X in the traybar and select exit.
echo.
%curdrive%\cygwin\bin\bash --login -c /usr/X11R6/bin/startxwin.sh
goto varrest

:ask
rem Ask to the user if an uninstallation is desired
rem -----------------------------------------------
if "%os%"=="Windows_NT" goto dellnk
choice /c:yn /n /t:y,8 Do you want to exit from Cygwin Easy now? [YES, no]
if errorlevel 1 goto dellnk
if errorlevel 2 goto varrest
if errorlevel 0 goto varrest
if errorlevel 255 goto dellnk
goto dellnk

:dellnk
rem Remove desktop shortcuts
rem ------------------------
call %ortemp%\dellnk.bat 2> nul
goto restore

:restore
rem Restoring pre-existing mount points
rem -----------------------------------
%curdrive%\cygwin\bin\umount -c > nul 2> "%ortemp%\umount.log"
%curdrive%\cygwin\bin\umount -A 2> nul
call "%ortemp%\remount.bat" 2> nul
goto deltemp

:deltemp
rem Remove the temporary directories
rem --------------------------------
set temp=%ortemp%
set ortemp=
if "%os%"=="Windows_NT" rmdir /s /q "%temp%" 
if not "%os%"=="Windows_NT" deltree /y "%temp%" 
goto varrest

:varrest
rem Restoring old variable values
rem -----------------------------
set curdrive=
if not "%oldtemp%"=="" set temp=%oldtemp%
if not "%oldtemp%"=="" set oldtemp=
if not "%oldtmpdir%"=="" set tmpdir=%oldtmpdir%
if not "%oldtmpdir%"=="" set oldtmpdir=
if "%oldhome%"=="" set home=
if not "%oldhome%"=="" set home=%oldhome%
if not "%oldhome%"=="" set oldhome=
goto end

:errtemp
rem Print an error message if there's some problem with TEMP variable
rem -----------------------------------------------------------------
echo There isn't any temp directory and there isn't any C drive.
echo Please set a TEMP variable with a writable directory.
echo set TEMP=X:\temp
echo where "X" is one of your drives.
echo.
goto end

:end
