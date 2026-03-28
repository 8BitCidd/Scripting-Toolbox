# This script was created to extract ZIP file names and export them to a text file.
# It can be adapted for any file type and is useful for quickly listing files or folders
# for use in other scripts—eliminating the need to manually copy names.

Get-ChildItem "H:\LaunchBox\Games\Nintendo Game Boy" -File |
Select-Object -ExpandProperty Name |
Out-File "C:\Users\Dark_\Desktop\New folder\folders.txt" -Encoding UTF8

