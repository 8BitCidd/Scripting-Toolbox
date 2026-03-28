#This script was initially created to get a list of zip files names and export them to a text file.
#You can use this script to do the same thing with just about any file, but it was used specifically to grab the names of things like folders for use with other scripts or for whatever you could possibly need it for without having to manually copy each and every file name files names.

Get-ChildItem "H:\LaunchBox\Games\Nintendo Game Boy" -File |
Select-Object -ExpandProperty Name |
Out-File "C:\Users\Dark_\Desktop\New folder\folders.txt" -Encoding UTF8

