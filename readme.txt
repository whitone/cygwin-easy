Cygwin Easy
-----------

Cygwin Easy is an autorun disk that let you work easily and quickly with Cygwin environment
in a Windows computer without install anything on your hard disk.

When you insert the disk in the drive the autorun start automatically, if nothing happens
it's necessary to run "autorun.bat" manually.

Your Cygwin work directory (home) is the "cygwin" directory placed on your desktop.

If in your computer there is already an installation of Cygwin when "autorun.bat" is properly
terminated (exiting from the environment with the exit command) or when you click on the link to
remove Cygwin Easy it will return back to the previous environment.

In the desktop there is also some links to start new shells or to start X Windows server.

If you want to start X Windows server when the disk is inserted you can run the command
"D:\autorun X" from Start -> Run (where "D" is the letter that indicate your optical drive).

At the end of the work with Cygwin Easy on your guest system there will be only your workdir.

If you want to change your home path is possible to create a configuration file called
"cygwineasy.ini" in your desktop with inside:

[Cygwin Easy]
HOME=C:\home\user

where "C:\home\user" is the path of your home

You can also specify this as second argument for "autorun.bat", for example:
"D:\autorun shell C:\home\user" (from Start -> Run).

If you want a more powerful console (with for example the tab) you can run "console.exe" that
is in the directory called "console". Console is an open source application that is compatible
with Windows 2000, XP, Vista and next version (http://www.sourceforge.net/projects/console).

A complete list of Cygwin Easy packages is inside the file "packages.txt". Licenses of packages
vary but most are under the GPL. Cygwin Easy scripts are under GPL.
 
General information about Cygwin licenses is available at http://www.cygwin.com/licensing.html.

Cygwin Easy requires Microsoft Windows 95/98/ME/2000/XP/Vista or next version.

For any other informations visit the project site: www.cygwineasy.tk.