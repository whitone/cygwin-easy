# Requirements #

  * a Microsoft Windows operating system (such as Windows XP)
  * a Cygwin installation with all you need

# First stage #

If you want to mantain the installed version of Cygwin you need to duplicate the installation directory. To correctly create a Cygwin Easy disk remember that Cygwin must be installed (or duplicated) in a directory such as **X:\cygwin**, where **X** is one of your drives.
Run a shell and from a writable directory (for example your home) download and execute the script [mkeasy.sh](http://cygwin-easy.googlecode.com/files/mkeasy.sh). When setup is started click always on **Next** button and select **cygwin-easy** from packages selection. Now you have to wait (it depends on the installation of Cygwin) for the postinstall script that have to recreate all symlinks, because not all type of these migrate properly to the ISO file system.

![http://sites.google.com/site/whitone/cygwin-easy-1.0.0.png](http://sites.google.com/site/whitone/cygwin-easy-1.0.0.png)

# Second stage #

Copy [autorun.bat](http://cygwin-easy.googlecode.com/svn/tags/2007.03.21/autorun.bat), [autorun.inf](http://cygwin-easy.googlecode.com/svn/tags/2007.03.21/autorun.inf), [readme.txt](http://cygwin-easy.googlecode.com/svn/tags/2007.03.21/readme.txt) and [license.txt](http://cygwin-easy.googlecode.com/svn/tags/2007.03.21/license.txt) in the drive **X**. You can try your Cygwin Easy disk with a double click on **autorun.bat**, a console would be appear. If all things are ok, now you can burn your Cygwin Easy disk.