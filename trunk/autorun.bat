@echo off

rem autorun.bat - Copyright 2007-2008 Stefano Cotta Ramusino.
rem =========================================================
rem Written by Stefano Cotta Ramusino, February 2007.
rem Modified by Stefano Cotta Ramusino, March 2007.
rem Modified by Stefano Cotta Ramusino, August 2007.
rem Modified by Stefano Cotta Ramusino, January 2008.
rem
rem Based on X.bat - Copyright 2004 Trustees of Indiana University under 
rem the GNU General Public License.
rem Written by Dick Repasky, February 2004.
rem Modified by Dick Repasky, August 2004.
rem 
rem This program is free software; you can redistribute it and/or modify it 
rem under the terms of the GNU General Public License as published by the 
rem Free Software Foundation; either version 3 of the License, or (at 
rem your option) any later version.
rem 
rem This program is distributed in the hope that it will be useful, but 
rem WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
rem or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
rem for more details.
rem 
rem You should have received a copy of the GNU General Public License along 
rem with this program. If not, see <http://www.gnu.org/licenses/>.

rem Set the Cygwin root directory
rem -----------------------------
set cygdir=\cygwin

rem Inform the user to wait
rem -----------------------
if not "%1"=="x" echo Starting Cygwin, please wait ... 2> nul
if "%1"=="x" echo Starting Cygwin X Windows, please wait ... 2> nul
echo. 2> nul

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
if not exist "%temp%" goto errtemp
set temp=%temp%\cygwin
if not exist "%temp%" mkdir "%temp%" 2> nul
if not exist "%temp%" goto errtemp
if not exist "%temp%\lnk" mkdir "%temp%\lnk" 2> nul
set writable=
if not "%curdrive%"=="" goto chkxwin
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
set curdrive=%curdrive%:
%curdrive%%cygdir%\bin\rm -f "%temp%\curdrive.bat" 2> nul
goto chkxwin

:winnt
rem Determine current drive on WinNT
rem --------------------------------
set curdrive=%~d0
if not "%1"=="x" title Cygwin Easy 2> nul
if "%1"=="x" title Cygwin X Windows Easy 2> nul
goto chkxwin

:chkxwin
rem Check if X Windows is present
rem -----------------------------
if exist %curdrive%%cygdir%\usr\X11R6\bin\startxwin.sh goto chkwrite
if "%1"=="x" goto errxwin
if "%writable%"=="" goto chkwrite
if exist "%temp%\lnk\X.bat" goto uninst
goto getprev

:chkwrite
rem Check if Cygwin Easy disk is writable
rem -------------------------------------
set writable=0
%curdrive%%cygdir%\bin\rm -f %curdrive%%cygdir%\tmp\testw 2> nul
if exist %curdrive%%cygdir%\tmp\testw goto runwhat
echo. > %curdrive%%cygdir%\tmp\testw 2> nul
if not exist %curdrive%%cygdir%\tmp\testw goto runwhat
%curdrive%%cygdir%\bin\rm -f %curdrive%%cygdir%\tmp\testw 2> nul
set writable=1
if not exist "%curdrive%\cygwineasy.ini" goto runwhat
%curdrive%%cygdir%\bin\sed -n "s, *\(WRITABLE.*\) *,@set \1,ip" "%curdrive%\cygwineasy.ini" > "%temp%\usrwrite.bat" 2> nul
call "%temp%\usrwrite.bat" 2> nul
%curdrive%%cygdir%\bin\rm -f "%temp%\usrwrite.bat" 2> nul
goto runwhat

:runwhat
rem Check if Cygwin Easy is already configured
rem ------------------------------------------
if not exist "%temp%\lnk\remove.bat" goto sethome
if not exist "%temp%\lnk\cygwin.bat" goto sethome
if not exist %curdrive%%cygdir%\usr\X11R6\bin\startxwin.sh goto chkxwin
if not exist "%temp%\lnk\X.bat" goto sethome
goto getprev

:getprev
rem Get previous Cygwin Easy configuration
rem --------------------------------------
call "%temp%\lnk\remove.bat" get 2> nul
if "%unindrive%"=="" goto sethome
if "%unindrive%"=="%curdrive%" goto cygbat
set unindrive=
goto uninst

:uninst
rem Remove previous Cygwin Easy configuration
rem -----------------------------------------
call "%temp%\lnk\remove.bat" 2> nul
goto maketemp

:cygbat
rem Call an already configured Cygwin Easy
rem --------------------------------------
cls 2> nul
if not "%1"=="x" "%temp%\lnk\cygwin.bat" %2
if "%1"=="x" "%temp%\lnk\X.bat" %2
goto end

:sethome
rem Set home directory
rem ------------------
if not "%home%"=="" set oldhome=%home%
if not "%home%"=="" set home=
echo @echo off > "%temp%\lnk\cygwin.bat" 2> nul
if not "%2"=="" set home=%2
if not "%2"=="" goto homepass
if exist "%curdrive%\cygwineasy.ini" goto mainset
goto defhome

:defhome
rem Search for the desktop directory of current user
rem ------------------------------------------------
%curdrive%%cygdir%\bin\cygpath -D -w | %curdrive%%cygdir%\bin\sed "s,\(.*\),set home=\1\r," >> "%temp%\lnk\cygwin.bat" 2> nul
call "%temp%\lnk\cygwin.bat" 2> nul
if exist "%home%" goto localset
cls 2> nul
if not "%1"=="x" echo Starting Cygwin, please wait ... 2> nul
if "%1"=="x" echo Starting Cygwin X Windows, please wait ... 2> nul
echo. 2> nul
if not "%userprofile%"=="" set home=%userprofile%\Desktop
if exist "%home%" goto localset
if not "%homedrive%"=="" set home=%homedrive%
if not "%homepath%"=="" set home=%home%%homepath%\Desktop
if "%homepath%"=="" set home=
if exist "%home%" goto localset
if not "%username%"=="" set home=%homedrive%\Users\%username%\Desktop
if exist "%home%" goto localset
if not "%username%"=="" set home=%homedrive%\Documents and Settings\%username%\Desktop
if exist "%home%" goto localset
echo @echo off > "%temp%\lnk\cygwin.bat" 2> nul
if "%writable%"=="1" set home=
if "%writable%"=="1" goto startcyg
if exist C:\. set home=C:\home
if not exist "%home%" mkdir "%home%" 2> nul
if not exist "%home%" goto errhome
goto homepass

:truehome
rem Set Cygwin work directory
rem -------------------------
echo @echo off > "%temp%\lnk\cygwin.bat" 2> nul
echo %home%| %curdrive%%cygdir%\bin\sed "s,^\(.*\),set home=\1/cygwin\r," >> "%temp%\lnk\cygwin.bat" 2> nul
call "%temp%\lnk\cygwin.bat" 2> nul
if exist "%home%\cygwineasy.ini" goto localset
goto startcyg

:mainset
rem Parse main settings file
rem ------------------------
%curdrive%%cygdir%\bin\sed -n "s, *\(HOME.*\) *,set \1,ip" "%curdrive%\cygwineasy.ini" >> "%temp%\lnk\cygwin.bat" 2> nul
call "%temp%\lnk\cygwin.bat" 2> nul
if "%home%"=="" goto defhome
if not exist "%home%\cygwineasy.ini" echo @echo off > "%temp%\lnk\cygwin.bat" 2> nul
if not exist "%home%\cygwineasy.ini" goto homepass
goto localset

:localset
rem Parse local settings file
rem -------------------------
if not exist "%home%\cygwineasy.ini" goto truehome
%curdrive%%cygdir%\bin\sed -n "s, *\(WRITABLE.*\) *,@set \1,ip" "%home%\cygwineasy.ini" > "%temp%\lnk\cygwin.bat" 2> nul
call "%temp%\lnk\cygwin.bat" 2> nul
%curdrive%%cygdir%\bin\sed -n "s, *\(HOME.*\) *,@set \1,ip" "%home%\cygwineasy.ini" > "%temp%\lnk\cygwin.bat" 2> nul
call "%temp%\lnk\cygwin.bat" 2> nul
echo @echo off > "%temp%\lnk\cygwin.bat" 2> nul
goto homepass

:homepass
rem Use home directory passed as argument
rem -------------------------------------
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
%curdrive%%cygdir%\bin\mount -m | %curdrive%%cygdir%\bin\sed -e "s,mount,\"%%cygtemp%%\\\\mount\",gi" >> "%temp%\remount.bat" 2> nul
%curdrive%%cygdir%\bin\u2d "%temp%/remount.bat" 2> nul
%curdrive%%cygdir%\bin\umount -c > nul 2> "%temp%\umount.log"
%curdrive%%cygdir%\bin\rm -f "%temp%\umount.log" 2> nul
%curdrive%%cygdir%\bin\umount -A 2> nul
%curdrive%%cygdir%\bin\mount -bfu %curdrive%%cygdir% / 2> nul
%curdrive%%cygdir%\bin\mount -bfu %curdrive%%cygdir%/bin /usr/bin 2> nul
%curdrive%%cygdir%\bin\mount -bfu %curdrive%%cygdir%/lib /usr/lib 2> nul
if "%writable%"=="1" goto mklink
if not exist "%temp%\etc" mkdir "%temp%\etc" 2> nul
if not exist "%temp%\etc\passwd" echo. > "%temp%\etc\passwd" 2> nul
if not exist "%temp%\etc\group" echo. > "%temp%\etc\group" 2> nul
if not exist "%temp%\tmp" mkdir "%temp%\tmp" 2> nul
%curdrive%%cygdir%\bin\mount -bfu "%temp%/tmp" /tmp 2> nul
if not exist "%temp%\var" mkdir "%temp%\var" 2> nul
%curdrive%%cygdir%\bin\cp -fa %curdrive%%cygdir%/var/log "%temp%/var" 2> nul
%curdrive%%cygdir%\bin\mount -bfu "%temp%/var/log" /var/log 2> nul
if not exist "%temp%\var\tmp" mkdir "%temp%\var\tmp" 2> nul
%curdrive%%cygdir%\bin\mount -bfu "%temp%/var/tmp" /var/tmp 2> nul
goto mklink

:mklink
rem Create link on the desktop
rem --------------------------
%curdrive%%cygdir%\bin\mount -t --change-cygdrive-prefix /cygdrive 2> nul
%curdrive%%cygdir%\bin\cygpath ".%cygdir%"| %curdrive%%cygdir%\bin\sed "s,\.\(.*\),@set ucygdir=\1\r," >> "%temp%\lnk\ucygdir.bat" 2> nul
call "%temp%\lnk\ucygdir.bat" 2> nul
%curdrive%%cygdir%\bin\rm -f "%temp%\lnk\ucygdir.bat" 2> nul
%curdrive%%cygdir%\bin\bash -c "/usr/share/cygwin-easy/autorun.sh %curdrive% %writable% %ucygdir%" 2> nul
goto makebat

:makebat
rem Create Cygwin Easy batch scripts
rem --------------------------------
echo @echo off > "%temp%\lnk\remove.bat" 2> nul
echo if "%%1"=="get" set unindrive=%curdrive%>> "%temp%\lnk\remove.bat" 2> nul
echo if "%%1"=="get" goto end >> "%temp%\lnk\remove.bat" 2> nul
%curdrive%%cygdir%\bin\cp -f /bin/cygwin1.dll /bin/umount.exe "%temp%" 2> nul
if exist "%temp%\remount.bat" %curdrive%%cygdir%\bin\cp -f /bin/mount.exe "%temp%" 2> nul
if "%writable%"=="1" echo %curdrive%%cygdir%\bin\bash -c "/usr/share/cygwin-easy/autorun.sh %curdrive% %writable% %ucygdir% clean" >> "%temp%\lnk\remove.bat" 2> nul
echo "%temp%\umount" -c >> "%temp%\lnk\remove.bat" 2> nul
echo "%temp%\umount" -A >> "%temp%\lnk\remove.bat" 2> nul
if exist "%temp%\dellnk.bat" echo call "%temp%\dellnk.bat" >> "%temp%\lnk\remove.bat" 2> nul
if exist "%temp%\remount.bat" echo call "%temp%\remount.bat" >> "%temp%\lnk\remove.bat" 2> nul
if "%os%"=="Windows_NT" echo rmdir /s /q "%temp%" >> "%temp%\lnk\remove.bat" 2> nul
if not "%os%"=="Windows_NT" echo deltree /y "%temp%" >> "%temp%\lnk\remove.bat" 2> nul
echo :end >> "%temp%\lnk\remove.bat" 2> nul
echo if not "%%1"=="" set home=%%1>> "%temp%\lnk\cygwin.bat" 2> nul
if "%writable%"=="1" echo set temp=%curdrive%%cygdir%\tmp>> "%temp%\lnk\cygwin.bat" 2> nul
if not "%writable%"=="1" echo set temp=%temp%\tmp>> "%temp%\lnk\cygwin.bat" 2> nul
echo set tmpdir=%%temp%%>> "%temp%\lnk\cygwin.bat" 2> nul
echo :chkdisk >> "%temp%\lnk\cygwin.bat" 2> nul
echo if not exist %curdrive%%cygdir%\. echo Please insert "Cygwin Easy disk" as volume %curdrive%>> "%temp%\lnk\cygwin.bat" 2> nul
echo if not exist %curdrive%%cygdir%\. pause >> "%temp%\lnk\cygwin.bat" 2> nul
echo if not exist %curdrive%%cygdir%\. echo. >> "%temp%\lnk\cygwin.bat" 2> nul
echo if not exist %curdrive%%cygdir%\. goto chkdisk >> "%temp%\lnk\cygwin.bat" 2> nul
echo cls >> "%temp%\lnk\cygwin.bat" 2> nul
if exist %curdrive%%cygdir%\usr\X11R6\bin\startxwin.sh %curdrive%%cygdir%\bin\cp -f /usr/share/cygwin-easy/lnk/cygwin.bat /usr/share/cygwin-easy/lnk/X.bat 2> nul
echo %curdrive%%cygdir%\bin\bash --login -i >> "%temp%\lnk\cygwin.bat" 2> nul
if not exist %curdrive%%cygdir%\usr\X11R6\bin\startxwin.sh goto truetemp
echo if not exist %curdrive%%cygdir%\usr\X11R6\bin\startxwin.sh goto errxwin >> "%temp%\lnk\X.bat" 2> nul
if "%os%"=="Windows_NT" echo title Cygwin X Windows - Right click on X in the traybar and select exit to close >> "%temp%\lnk\X.bat" 2> nul
echo echo. >> "%temp%\lnk\X.bat" 2> nul
echo echo A prompt will not return to this window until you quit X Windows. >> "%temp%\lnk\X.bat" 2> nul
echo echo To quit X Windows, right click X in the traybar and select exit. >> "%temp%\lnk\X.bat" 2> nul
echo echo. >> "%temp%\lnk\X.bat" 2> nul
echo %curdrive%%cygdir%\bin\bash --login -c /usr/X11R6/bin/startxwin.sh >> "%temp%\lnk\X.bat" 2> nul
echo goto end >> "%temp%\lnk\X.bat" 2> nul
echo :errxwin >> "%temp%\lnk\X.bat" 2> nul
echo echo X Windows cannot be launched because X-startup-scripts package >> "%temp%\lnk\X.bat" 2> nul
echo echo is missing. >> "%temp%\lnk\X.bat" 2> nul
if "%writable%"=="1" echo echo Please install X-startup-scripts with easy-update. >> "%temp%\lnk\X.bat" 2> nul
echo echo. >> "%temp%\lnk\X.bat" 2> nul
echo pause >> "%temp%\lnk\X.bat" 2> nul
echo goto end >> "%temp%\lnk\X.bat" 2> nul
echo :end >> "%temp%\lnk\X.bat" 2> nul
goto truetemp

:truetemp
rem Set the temporary directory for Cygwin
rem --------------------------------------
set origtmp=%temp%
if "%writable%"=="1" set temp=%curdrive%%cygdir%\tmp
if not "%writable%"=="1" set temp=%temp%\tmp
if not "%tmpdir%"=="" set oldtmpdir=%tmpdir%
set tmpdir=%temp%
goto shell

:shell
rem Start shell
rem -----------
cls 2> nul
if "%1"=="x" goto xwin
if "%1"=="console" goto console
%curdrive%%cygdir%\bin\bash --login -i
goto ask

:console
rem Start console
rem -------------
cls 2> nul
%curdrive%%cygdir%\bin\bash --login -i
goto varrest

:xwin
rem Start X Windows
rem ---------------
if "%os%"=="Windows_NT" title X Windows - Right click on X in the traybar and select exit to close 2> nul
echo. 2> nul
echo A prompt will not return to this window until you quit X Windows. 2> nul
echo To quit X Windows, right click X in the traybar and select exit. 2> nul
echo. 2> nul
%curdrive%%cygdir%\bin\bash --login -c /usr/X11R6/bin/startxwin.sh
goto varrest

:ask
rem Ask to the user if an uninstallation is desired
rem -----------------------------------------------
if "%os%"=="Windows_NT" goto cleandsk
choice /c:yn /n /t:y,8 Do you want to exit from Cygwin Easy now? [YES, no]
if errorlevel 1 goto cleandsk
if errorlevel 2 goto varrest
if errorlevel 0 goto varrest
if errorlevel 255 goto cleandsk
goto cleandsk

:cleandsk
rem Return to original Cygwin Easy disk
rem -----------------------------------
if "%writable%"=="1" %curdrive%%cygdir%\bin\bash -c "/usr/share/cygwin-easy/autorun.sh %curdrive% %writable% %ucygdir% clean" 2> nul

rem Remove desktop shortcuts
rem ------------------------
call %origtmp%\dellnk.bat 2> nul

rem Restoring pre-existing mount points
rem -----------------------------------
%curdrive%%cygdir%\bin\umount -c > nul 2> "%origtmp%\umount.log"
%curdrive%%cygdir%\bin\umount -A 2> nul
call "%origtmp%\remount.bat" 2> nul

rem Remove the temporary directories
rem --------------------------------
set temp=%origtmp%
set origtmp=
if "%os%"=="Windows_NT" rmdir /s /q "%temp%" 2> nul
if not "%os%"=="Windows_NT" deltree /y "%temp%" 2> nul
goto varrest

:varrest
rem Restoring old variable values
rem -----------------------------
set curdrive=
set cygdir=
set ucygdir=
set writable=
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
echo There isn't any writable temp directory and there isn't any
echo C: drive or you cannot write in C: drive. 2> nul
echo Please set a TEMP variable with a writable directory. 2> nul
echo. 2> nul
echo set TEMP=X:\temp 2> nul
echo where "X" is one of your drives. 2> nul
echo. 2> nul
set cygdir=
if not "%oldtemp%"=="" set temp=%oldtemp%
if not "%oldtemp%"=="" set oldtemp=
pause 2> nul
goto end

:errhome
rem Print an error message if there's some problem with HOME variable
rem -----------------------------------------------------------------
echo I cannot determine your desktop directory where your home will 2> nul
echo be placed and there isn't any C drive or you cannot write in C 2> nul
echo drive. 2> nul
echo Please specify your Cygwin work directory as second argument. 2> nul
echo. 2> nul
echo autorun shell X:\home\user 2> nul
echo where "X" is one of your drives. 2> nul
echo. 2> nul
set curdrive=
set cygdir=
set writable=
if "%os%"=="Windows_NT" rmdir /s /q "%temp%" 2> nul
if not "%os%"=="Windows_NT" deltree /y "%temp%" 2> nul
if not "%oldtemp%"=="" set temp=%oldtemp%
if not "%oldtemp%"=="" set oldtemp=
if "%oldhome%"=="" set home=
if not "%oldhome%"=="" set home=%oldhome%
if not "%oldhome%"=="" set oldhome=
pause 2> nul
goto end

:errxwin
rem Print an error message if X Windows is not present
rem --------------------------------------------------
echo X Windows cannot be launched because X-startup-scripts package 2> nul
echo is missing. 2> nul
echo. 2> nul
set curdrive=
set cygdir=
set writable=
if "%os%"=="Windows_NT" rmdir /s /q "%temp%" 2> nul
if not "%os%"=="Windows_NT" deltree /y "%temp%" 2> nul
if not "%oldtemp%"=="" set temp=%oldtemp%
if not "%oldtemp%"=="" set oldtemp=
pause 2> nul

:end
