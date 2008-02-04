#! /bin/sh

# cygwin-easy.sh - Copyright 2007-2008 Stefano Cotta Ramusino.
# ============================================================
# Written by Stefano Cotta Ramusino, March 2007.
# Modified by Stefano Cotta Ramusino, February 2008.
#
# Based on lnk.update.sh posted to the Cygwin mailing list by Fergus 
# http://www.cygwin.com/ml.cygwin/2003-07/msg01117.html.
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

if [[ "$1" == "--force" || ! -e /etc/postinstall/cygwin-easy.sh.done ]]
then

   if [[ ! -e /usr/share/icons/cygwin.ico && -e /cygwin.ico ]]
   then

      [ ! -e /usr/share/icons ] && mkdir -p /usr/share/icons
      cp -f /cygwin.ico /usr/share/icons/cygwin.ico
      
   fi

   [ ! -e /tmp ] && mkdir /tmp

   find / -mount \( -path /usr/lib -o -path /usr/bin \) -prune -o -type l \
      ! \( -path /etc/hosts -o -path /etc/protocols -o -path /etc/services -o -path /etc/networks \) \
      -printf "/bin/rm %p\n/bin/ln -s %l %p\n" > /tmp/cygrelnk

   source /tmp/cygrelnk

   rm -f /tmp/cygrelnk

fi