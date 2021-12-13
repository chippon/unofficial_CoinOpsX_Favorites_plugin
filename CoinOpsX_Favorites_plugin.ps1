#(Unoffical) CoinOpsX_favorites_plugin
Clear-Host
#todo list
#add gui elements
#add more logos and selector / download logo

#CoinOpsX_favorites_plugin vars
$CoinOpsX_favorites_plugin_path = "$cox_drive" + "\CoinOpsX_favorites_plugin\"
$CoinOpsX_favorites_plugin_path_backup = "$cox_drive" + "\CoinOpsX_favorites_plugin\backup\"
$local_temp_location = $env:TEMP + "\CoinOpsX_favorites_plugin\"
$logo_image = "$cox_drive" + "\CoinOpsX_favorites_plugin\star.png"
$logo_backup = "$cox_drive" + "\CoinOpsX_favorites_plugin\backup\"
$compress_list = $CoinOpsX_favorites_plugin_path + "files_to_compress.txt"

#CoinOpsX static Paths
$logo_dir = "$cox_drive" + "\cox\logo\"
$Fav_File = "$cox_drive" + "\cox\playlists\favorites.txt"
$f_type = ".png"
$output = "$cox_drive" + "\cox\logo\"

#watermark vars
$output = "$cox_drive" + "\cox\logo\"
#check current path
$cur_script_loc = $MyInvocation.MyCommand.Path

function Find_Fav_Files {
    param()
    $found_drives = $(Get-PSDrive -PSProvider 'FileSystem')
    $found_favs = [System.Collections.ArrayList]@()
    $root_fav_file = "\cox\playlists\favorites.txt"
    foreach ($cox_drive in $found_drives) {
        $test_path = "$cox_drive" + ':' + "$root_fav_file"
        $a = Test-Path -Path $test_path
        IF ($a -eq "True") { $found_favs.add("$cox_drive") | out-null }
    }
    if ( $found_favs.count -gt 1 ) {
        Write-Host "Multiple CoinOPsX instances found, Please select which drive you'd like to update."
        foreach ($fav in $found_favs) {
            $msg = "Found Favoriates file on Drive $fav`nContuine with Drive $fav ? [y/n]"
            $response = Read-Host -Prompt $msg
            if ($response -like "y*") {
                $cox_drive = "$fav" + ':'
                break
            }
            if ($response -like "n*") {
                $cox_drive = ""
            }
        }
    }
    if ( $found_favs.count -eq 1) {
        $found_favs_path = "$found_favs" + ':'
        Write-Host "CoinsOpx Found at Drive $found_favs_path"
        $cox_drive = "$fav" + ':'
    }
    #    if ( $global:cox_drive -eq ""){
    #        exit
    #    }
}
function Check_Image_Magik {
    param ()
    if (Get-Command magick -erroraction silentlycontinue) {
    }
    else {
        $magick_dl_page = Invoke-WebRequest -Uri https://imagemagick.org/script/download.php
        if ( [IntPtr]::size -eq 8 ) {
            $url = $magick_dl_page.Links.href | Where-Object { $_ -like “*-Q16-HDRI-x64-dll.exe” } | Get-Unique
        }
        if ( [IntPtr]::size -eq 4 ) {
            $url = $magick_dl_page.Links.href | Where-Object { $_ -like “*-Q16-HDRI-x86-dll.exe” } | Get-Unique
        }
        $dest = $env:TEMP + "ImageMagick-7.1.0-17-Q16-HDRI-x64-dll.exe"
        $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Description."
        $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Description."
        $cancel = New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel", "Description."
        $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $cancel)
        $title = "Application - Image Magick Not found. Preparing to download and install." 
        $message = "Note: after the download finishes, the installer will popup and run.`nDo you wish to continue?"
        $result = $host.ui.PromptForChoice($title, $message, $options, 1)
        switch ($result) {
            0 {
                $ProgressPreference = 'SilentlyContinue'
                Invoke-WebRequest -Uri $url -OutFile $dest
                $ProgressPreference = 'Continue' 
                start-process $dest /silent -Wait
            }1 {
                Write-Host "No"
            }2 {
                Write-Host "Cancel"
            }
        }
    }
}
Function Check_Folders {
    Param ($FolderToCreate)
    if (!(Test-Path $FolderToCreate -PathType Container)) {
        New-Item -ItemType Directory -Force -Path $FolderToCreate | Out-Null
    }
}
Function Find_logo {
    param()
    if (!(Test-Path $logo_image)) {
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri https://github.com/chippon/CoinOpsX_Favorites_plugin/raw/main/star.png -OutFile $logo_image
        $ProgressPreference = 'Continue' 
    }
}

Function Check_Previous_Backup {
    Param ()
    $compress_loc = $logo_backup + "backup.zip"
    $compress_logo_dir_list = $logo_dir + "files_to_compress.txt"
    if (Test-Path $compress_loc) {
        $ProgressPreference = 'SilentlyContinue'
        Expand-Archive -Force -LiteralPath $compress_loc -DestinationPath $logo_dir
        Remove-Item $compress_loc
        Remove-Item $compress_logo_dir_list
        $ProgressPreference = 'Continue'
    }
}
Function Create_Compress_List {
    Param ()
    ForEach ($i in (Get-Content $Fav_File)) {
        $files_to_compress = $logo_dir + $i + $f_type
        $files_to_compress | Out-File -Append $compress_list
    }
}

#store files to user temp (locally) then compress and store zip back to flash drive
#I found this to be faster then updating in place with my flash drive
Function Create_Backup {
    Param ()
    foreach ($filename in Get-Content $compress_list) {
        Copy-Item $filename $local_temp_location
    }
    $ProgressPreference = 'SilentlyContinue'
    Compress-Archive $local_temp_location* $local_temp_location"backup.zip"
    Compress-Archive $compress_list -Update $local_temp_location"backup.zip"
    Move-Item $local_temp_location"backup.zip" $logo_backup
    $ProgressPreference = 'Continue'
    #
}

#read list of favoriates and create the watermark
Function Create_Watermark {
    Param ()
    ForEach ($name in Get-Content $compress_list) {
        $pos = $name.IndexOf("\")
        $folder = $name.Substring(0, $pos)
        #I don't think this is the best way, as it should be 7 but 10 works
        $file = $name.Substring($pos + 10)
        $output = $local_temp_location + $file
        magick composite -gravity northeast $logo_image $name $output
    }
}

Function Apply_Watermark {
    Param ()
    Move-Item -Force $local_temp_location* $logo_dir
}

Function Clean_Up {
    param ()
    Remove-Item $compress_list
    Remove-Item $local_temp_location*.*
}

#step1
Write-Host "[1/13] Looking for drives with CoinOpX favoriate files"
Find_Fav_Files
#step2
write-host "[2/13] verifying image magik is installed"
Check_Image_Magik
#step3
Write-Host "[3/13] finding/creating CoinOpsX_favorites_plugin program path at" $CoinOpsX_favorites_plugin_path
Check_Folders $CoinOpsX_favorites_plugin_path
#step4
Write-Host "[4/13] finding/creating CoinOpsX_favorites_plugin backup" $CoinOpsX_favorites_plugin_path_backup
Check_Folders $CoinOpsX_favorites_plugin_path_backup
#step4.5
write-host "[5/13] finding star logo, downloading if not found"
Find_logo
#step5
Write-Host "[6/13] finding/creating fav logoer local temp location" $local_temp_location
Check_Folders $local_temp_location
#step6
write-host "[7/13] copying script to CoinOpsX_favorites_plugin_path"
copy-item $cur_script_loc $CoinOpsX_favorites_plugin_path
#step7
Write-Host "[8/13] Checking for backups and importing to original location" $logo_dir
Check_Previous_Backup
#step8
Write-Host "[9/13] reading list of favorates to compress"
Create_Compress_List
#step9
Write-Host "[10/13] Creating Backups"
Create_Backup
#step10
Write-Host "[11/13] Creating Watermark logos"
Create_Watermark
#step11
Write-Host "[12/13] Moving WaterMarked logos"
Apply_Watermark
#step12
write-host "[13/13] cleaining up --- removing compress list file and fav logoer local temp location"
Clean_Up
Write-Host "Complete`nthis script has been copied to $CoinOpsX_favorites_plugin_path"
$reverse_msg = "To reverse the actions of this script copy files locationed in $logo_backup"+"backup.zip to $logo_dir"
Write-Host $reverse_msg