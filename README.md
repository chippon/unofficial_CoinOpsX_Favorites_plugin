# UNOFFICAL CoinOpsX_Favorites_plugin
  - I am in no way affiliated with the CoinOpsX crew or any party involved. Just like writing scripts :)
  - This Powershell Script will watermark the logos of games in your favorite file. Figured i'd share in case anyone could use it.
  ![alt text](https://github.com/chippon/CoinOpsX_Favorites_plugin/raw/main/example.gif?raw=true)
  
  example
# Requires application "Image Magick" 
  (https://imagemagick.org/index.php) which will be downloaded and installed if not found.
# Also requires a watermark which I have named star.png 
  (also will download if not found)
# To start just run the .ps1 file itself.
 
  Once ran it will scan for image magick and prompt you if you would like to proceed with installing the software if not found. Then will the script will scan for the favorite file in the corerct location on all drives. (ex. F:\cox\playlists\favorites.txt) 
  
  (see notes below for when you update your fav file)
  
  - If the script finds more then 1 suitable location it will prompt you which drive to use.

  The script should then run and finish up on its own. Once done you can just plug the flash card into the Legends Ultimate and your logos will be updated.
  
  note: After it has been ran once the script will backup the star.png and the CoinOpsX_Favorites_plugin.ps1 powershell script to the folder \CoinOPsX_favorites_plugin\ on the drive that was worked on (ex. F:\CoinOPsX_favorites_plugin). So next run you can find the script on your flash card and use it on other computers. Backups of unaltered logos are stored in the zip file located at \CoinOPsX_favorites_plugin\backup\backup.zip.
  
  Final note: If you change your fav list, just run the script again and it will restore all the non-edited logos removing all watermarks and then watermark the files from your updated favoriates file. 

  Final final note: I did not include a restore function as of right now. (maybe if someone asks) But you can simply copy the files from inside the zip backup that is taken located at \CoinOPsX_favorites_plugin\backup\backup.zip to your \cox\logo\ directory. Then for final cleanup delete the \CoinOPsX_favorites_plugin\ folder and uninstall image magick from windows like you would other programs.

  

Steps taken by the script
- [1/13] Looking for drives with CoinOpX favoriate files
- [2/13] verifying image magik is installed
- [3/13] finding/creating CoinOpsX_favorites_plugin program path at \CoinOpsX_favorites_plugin\
- [4/13] finding/creating CoinOpsX_favorites_plugin backup \CoinOpsX_favorites_plugin\backup\
- [5/13] finding star logo, downloading if not found
- [6/13] finding/creating fav logoer local temp location \Local\Temp\CoinOpsX_favorites_plugin\
- [7/13] copying script to CoinOpsX_favorites_plugin_path
- [8/13] Checking for backups and importing to original location \cox\logo\
- [9/13] reading list of favorites to compress
- [10/13] Creating Backups
- [11/13] Creating Watermark logos
- [12/13] Moving WaterMarked logos
- [13/13] cleaining up --- removing compress list file and fav logoer local temp location

(i bet this would of been easier in bash)
