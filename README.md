# CoinOpsX_Favorites_plugin
  Powershell Script that will watermark the logos of games in your favorite file.
  example
  ![alt text](https://github.com/chippon/CoinOpsX_Favorites_plugin/raw/main/example_Athena.png?raw=true)
  
  - The main reason I made this script was to highlight games I already had favoriated without having to flip back to the favoraite page or risk removing it from the list.
  Requires application "Image Magick" (https://imagemagick.org/index.php) which will be downloaded and installed if not found.
  Also requires a watermark which I have named star.png (also will download if not found)
  
  ![alt text](https://github.com/chippon/CoinOpsX_Favorites_plugin/raw/main/star.png?raw=true)
  
  Once ran it will scan for the favoirate file in the corerct location on all drives. (ex. F:\cox\playlists\favorites.txt) 
  
  If the script finds more then 1 suitable location it will prompt you which drive to use.
  
  After it has been ran once the script will backup the star.png and the CoinOpsX_Favorites_plugin.ps1 powershell script to the folder \CoinOPsX_favorites_plugin\ on the drive that was worked on (ex. F:\CoinOPsX_favorites_plugin) 

 Backups of unaltered logos are stored in the zip file located at \CoinOPsX_favorites_plugin\backup\backup.zip
  
  Final note: If you change your fav list, just run the script again and it will restore all the non-edited logos removing all watermarks and then watermark the files from your new favoriates file. 

  Final final note: I did not include a restore function as of right now. (maybe if someone asks) But you can simply copy the files from inside the zip backup that is taken located at \CoinOPsX_favorites_plugin\backup\backup.zip to your \cox\logo\ directory. Then for final cleanup delete the \CoinOPsX_favorites_plugin\ folder.



Steps taken
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
