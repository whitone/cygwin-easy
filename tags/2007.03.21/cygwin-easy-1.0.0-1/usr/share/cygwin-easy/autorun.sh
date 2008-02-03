#!/bin/bash

# autorun.sh - Copyright 2007 Stefano Cotta Ramusino.
# ===================================================
# Written by Stefano Cotta Ramusino, March 2007.
# 
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License as published by the 
# Free Software Foundation; either version 2 of the License, or (at 
# your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
# for more details.
# 
# You should have received a copy of the GNU General Public License along 
# with this program; if not, write to the Free Software Foundation, Inc., 
# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

if [[ "$1" != "" && ! -e "$TEMP/etc/profile.cygwin-easy" ]]
then

   PATH=/usr/bin:/bin
   
   for file in $(find $1/cygwin/etc -mindepth 1 -maxdepth 1 ! -name profile ! -type d -printf "%f\n")
   do
      ln -f -s $1/cygwin/etc/$file "$TEMP/etc/$file" &> /dev/null
   done
   
   for directory in $(find $1/cygwin/etc -mindepth 1 -maxdepth 1 -type d -printf "%f\n")
   do
      mount -bfu "$(cygpath -w $1/cygwin/etc)/$directory" /etc/$directory &> /dev/null
   done
   
   cp $1/cygwin/etc/profile "$TEMP/etc/profile" &> /dev/null
   pushd "$TEMP/etc" &> /dev/null
   patch -p0 -b -z .cygwin-easy < /usr/share/cygwin-easy/profile.patch &> /dev/null
   popd &> /dev/null

   mount -bfu "$(cygpath -w $TEMP)/etc" /etc &> /dev/null

   if [ -e /etc/postinstall/base-files-mketc.sh.done ]
   then
      /etc/postinstall/base-files-mketc.sh.done &> /dev/null
   fi      

   mkgroup -l > /etc/group 2> /dev/null
   mkpasswd -l > /etc/passwd 2> /dev/null

   grep mount "$TEMP/remount.bat" &> /dev/null
   if [ $? -ne 0 ]
   then
      rm -f "$TEMP/remount.bat" &> /dev/null
   fi
   
   mount -bfu "$(cygpath -w $TEMP)/lnk" /usr/share/cygwin-easy/lnk &> /dev/null
   
   if [ ! -e "$(cygpath -D -u)/Cygwin Shell.lnk" ]
   then

      mkshortcut \
         -D \
         -i /usr/share/icons/cygwin.ico \
         -n "Cygwin Shell" \
         /usr/share/cygwin-easy/lnk/cygwin.bat &> /dev/null

      echo -e "del /q \"$(cygpath -D -w)\\Cygwin Shell.lnk\"\r" >> "$TEMP/dellnk.bat" 2> /dev/null
   
   fi

   if [ ! -e "$(cygpath -D -u)/Cygwin X Windows.lnk" ]
   then

      mkshortcut \
         -D \
         -i /usr/share/icons/cygwin.ico \
         -n "Cygwin X Windows" \
         -s min \
         /usr/share/cygwin-easy/lnk/X.bat &> /dev/null

      echo -e "del /q \"$(cygpath -D -w)\\Cygwin X Windows.lnk\"\r" >> "$TEMP/dellnk.bat" 2> /dev/null

   fi

   if [ ! -e "$(cygpath -D -u)/Remove Cygwin Easy.lnk" ]
   then

      mkshortcut \
         -D \
         -i /usr/share/icons/cygwin.ico \
         -n "Remove Cygwin Easy" \
         -s min \
         /usr/share/cygwin-easy/lnk/remove.bat &> /dev/null

      echo -e "del /q \"$(cygpath -D -w)\\Remove Cygwin Easy.lnk\"\r" >> "$TEMP/dellnk.bat" 2> /dev/null
   
   fi
   
fi
