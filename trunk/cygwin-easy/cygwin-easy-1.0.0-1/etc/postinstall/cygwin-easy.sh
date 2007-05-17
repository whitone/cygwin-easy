#! /bin/sh

# cygwin-easy.sh - Copyright 2007 Stefano Cotta Ramusino.
# =======================================================
# Written by Stefano Cotta Ramusino, March 2007.
#
# Based on lnk.update.sh posted to the Cygwin mailing list by Fergus 
# http://www.cygwin.com/ml.cygwin/2003-07/msg01117.html.
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

if [[ ! -e /etc/postinstall/cygwin-easy.sh.done ]]
then

   if [ -e /cygwin.ico ]
   then

      cp -f /cygwin.ico /usr/share/icons/cygwin.ico
      
   fi

   rm -f /etc/{hosts,networks,services,protocols,passwd,group}

   pushd /tmp
   find / -type l > tmpf.0
   sed 's/^\/usr\/bin\/.*$//;s/^\/usr\/lib.*$//;/^$/d' tmpf.0 > tmpf.1
   sed 's/^/\/bin\/ls -al /' tmpf.1 > tmpf.2
   source tmpf.2 > tmpf.3
   sed 's/^[^\/]*\//\//' tmpf.3 > tmpf.4
   sed 's/^/\/bin\/rm /' tmpf.1 > tmpf.5
   sed 's/^\(.*\) -> \(.*\)$/\/bin\/ln -s \2 \1/' tmpf.4 > tmpf.6
   source tmpf.5
   source tmpf.6
   rm -f tmpf.*
   popd

fi