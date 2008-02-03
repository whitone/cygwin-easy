#!/bin/bash

# mkeasy.sh - Copyright 2007 Stefano Cotta Ramusino.
# ==================================================
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

if [[ -e /usr/bin/wget ]]
then

   if [[ ! -e ./setup.exe ]]
   then

      echo -n "Download of Cygwin setup . . . "
      wget -q -c http://www.cygwin.com/setup.exe
      if [[ $? -eq 0 ]]
      then
         echo ok!
      else
	 echo some errors occurred. >&2
	 exit 1
      fi
 
   fi
   
   for file in timestamp last-mirror last-action
   do
   
      mv -f /etc/setup/$file /etc/setup/$file.cygwin-easy
   
   done
   
   echo http://cygwin-easy.googlecode.com/svn/trunk/cygwin > /etc/setup/last-mirror
   echo Download,Install > /etc/setup/last-action
   echo @setup.exe > ./setup.bat

   chmod +x ./setup.bat
   ./setup.bat
   
   exit 0
   
else

   echo Missing wget package. Please install it. >&2
   
fi
