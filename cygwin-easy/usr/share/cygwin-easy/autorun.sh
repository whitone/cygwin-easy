#!/bin/bash

# autorun.sh - Copyright 2007-2008 Stefano Cotta Ramusino.
# ========================================================
# Written by Stefano Cotta Ramusino, March 2007.
# Modified by Stefano Cotta Ramusino, January 2008.
# 
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License as published by the 
# Free Software Foundation; either version 3 of the License, or (at 
# your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
# for more details.
# 
# You should have received a copy of the GNU General Public License along 
# with this program. If not, see <http://www.gnu.org/licenses/>.

if [[ "$1" != "" && ! -e "$TEMP/etc/profile.cygwin-easy" ]]
then

   PATH=/usr/bin:/bin

   if [[ "$2" != "1" && "$3" != "" ]]
   then
   
      for file in $(find $1$3/etc -mindepth 1 -maxdepth 1 ! -name profile ! -type d -printf "%f\n")
      do
         ln -f -s $1$3/etc/$file "$TEMP/etc/$file" &> /dev/null
      done
   
      for directory in $(find $1$3/etc -mindepth 1 -maxdepth 1 -type d -printf "%f\n")
      do
         mount -bfu "$(cygpath -w $1$3/etc)/$directory" /etc/$directory &> /dev/null
      done
   
      cp $1$3/etc/profile "$TEMP/etc/profile" &> /dev/null
      pushd "$TEMP/etc" &> /dev/null
      patch -p0 -b -z .cygwin-easy < /usr/share/cygwin-easy/profile.patch &> /dev/null
      popd &> /dev/null

      mount -bfu "$(cygpath -w $TEMP)/etc" /etc &> /dev/null

   else

      if [ "$4" == "" ]
      then
         pushd "/etc" &> /dev/null
      else
         pushd "$1$3/etc" &> /dev/null
      fi
      [ -e profile.cygwin-easy ] && mv -f profile.cygwin-easy profile &> /dev/null
      [ -e profile.rej ] && rm -f profile.rej &> /dev/null
      if [ "$4" == "" ]
      then
         patch -p0 -b -z .cygwin-easy < /usr/share/cygwin-easy/profile.patch &> /dev/null
      else
         rm -f {hosts,networks,services,protocols,passwd,group} &> /dev/null
      fi
      popd &> /dev/null

   fi

   if [ "$4" == "" ]
   then

      if [ -e /etc/postinstall/base-files-mketc.sh.done ]
      then
         /etc/postinstall/base-files-mketc.sh.done &> /dev/null
      fi      

      if [ -e /etc/postinstall/passwd-grp.sh.done ]
      then
         /etc/postinstall/passwd-grp.sh.done &> /dev/null
      else
         mkgroup -l > /etc/group 2> /dev/null
         mkpasswd -l > /etc/passwd 2> /dev/null
      fi      

      grep mount "$TEMP/remount.bat" &> /dev/null
      if [ $? -ne 0 ]
      then
         rm -f "$TEMP/remount.bat" &> /dev/null
      fi
   
      mount -bfu "$(cygpath -w $TEMP)/lnk" /usr/share/cygwin-easy/lnk &> /dev/null

      [ "$OS" == "Windows_NT" ] && del_flag="/q "
   
      [ -e /usr/share/cygwin-easy/lnk/cygwin.bat ] &&
         if [[ ! -e "$(cygpath -D -u)/Cygwin Shell.lnk" || ! -e "$TEMP/dellnk.bat" ]]
         then

            mkshortcut \
               -D \
               -i /usr/share/icons/cygwin.ico \
               -n "Cygwin Shell" \
               /usr/share/cygwin-easy/lnk/cygwin.bat &> /dev/null

            echo -e "del $del_flag\"$(cygpath -D -w)\\Cygwin Shell.lnk\"\r" >> "$TEMP/dellnk.bat" 2> /dev/null
               
         fi

      if [[ -e /usr/X11R6/bin/startxwin.sh && ! -e "$(cygpath -D -u)/Cygwin X Windows.lnk" ]]
      then

         mkshortcut \
            -D \
            -i /usr/share/icons/cygwin.ico \
            -n "Cygwin X Windows" \
            -s min \
            /usr/share/cygwin-easy/lnk/X.bat &> /dev/null

         echo -e "del $del_flag\"$(cygpath -D -w)\\Cygwin X Windows.lnk\"\r" >> "$TEMP/dellnk.bat" 2> /dev/null
         
      fi

      if [ ! -e "$(cygpath -D -u)/Remove Cygwin Easy.lnk" ]
      then

         mkshortcut \
            -D \
            -i /usr/share/icons/cygwin.ico \
            -n "Remove Cygwin Easy" \
            -s min \
            /usr/share/cygwin-easy/lnk/remove.bat &> /dev/null

         echo -e "del $del_flag\"$(cygpath -D -w)\\Remove Cygwin Easy.lnk\"\r" >> "$TEMP/dellnk.bat" 2> /dev/null
           
      fi
   
   fi

fi