### SET FOLDER (Surveys) TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = "\\winfiles.co.lincoln.loc\data\dept\surveyor\OCEScans\FINAL\to_images" # only watching one folder right now
    $watcher.Filter = "*.tif*" # only monitoring .tif files (not case sensitive)
    $watcher.IncludeSubdirectories = $false # not including subdirectories (adding .tif to tmp folder won't prompt it)
    $watcher.EnableRaisingEvents = $true  

### SET FOLDER (Plats) TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
# Create new watcher variable to monitor plats folder
    $watcher2 = New-Object System.IO.FileSystemWatcher
    $watcher2.Path = "\\winfiles.co.lincoln.loc\data\dept\surveyor\OCEScans\FINAL\to_images_plats" # only watching one folder right now
    $watcher2.Filter = "*.tif*" # only monitoring .tif files (not case sensitive)
    $watcher2.IncludeSubdirectories = $false # not including subdirectories (adding .tif to tmp folder won't prompt it action)
    $watcher2.EnableRaisingEvents = $true  

### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
    $action = { $path = $Event.SourceEventArgs.FullPath
                $changeType = $Event.SourceEventArgs.ChangeType
                C:\"Program Files\R\R-3.5.1\bin\Rscript.exe" "\\appserver2016.co.lincoln.loc\Script_Runner\PDF_Conversion.R" >> "\\winfiles.co.lincoln.loc\data\dept\gis\Programming\PDF_Conversion.log" 2>&1 # Direct R output/warnings/errors to logfile
              }    # Action happens each time an event is detected; if 5 tif's are added, script will run 5 times
### DECIDE WHICH EVENTS SHOULD BE WATCHED 
    Register-ObjectEvent $watcher "Created" -Action $action  # monitors creation within surveys
    Register-ObjectEvent $watcher2 "Created" -Action $action # monitors creation within plats
    while ($true) {sleep 5} # delay in seconds between detection of event and action (set to give more time for files to be added before they are processed)

