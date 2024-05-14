#!/bin/bash

# Usage: Use CURL to download all of the webpages at
# https://www.doesitplay.org/index?offline=No
# Then run this file in your directory with the html pages:
# ./script.sh > processed.csv

for file in *.html; do
  title=$(grep -Eso '<h1>([^<]*)' $file | cut -d \> -f2 | sed s/'["]'//g)
  publisher=$(pcregrep -Mso 'Publishers?:?</b>\s+<ul>\s+<li>([^<]*)' $file | tr '\n' ' ' | cut -d\> -f 4)
  genre=$(pcregrep -Mso 'genres">\s*(<li>[^<]+<\/li>\s+)+' $file | tr '\n' ' ' | sed -e s/'["]'//g | cut -d\> -f 2- | sed -e 's/  //g' -e 's/<li>//g' -e 's/<\/li>/ /g')
  pubdate=$(pcregrep -Mso 'release">([^<]+)' $file| tr '\n' ' ' | sed -e s/'["]'//g | cut -d\> -f2)
  normdate=$(date -d "$pubdate" +"%Y-%m-%d")
  offline=$(pcregrep -Mso 'Offline play</div>\s+<div class="[\w\s]+">(\w+)' $file | cut -d\> -f 2)
  dlrequired=$(pcregrep -Mso 'Download required</div>\s+<div class="[\w\s]+">(\w+)' $file | cut -d\> -f 2)
  console=$(grep -Eso "platform ([^']+)" $file | head -n1 | cut -d ' ' -f 2 )
  echo \"$title\",\"$publisher\",\"$genre\",\"$console\",,\"$normdate\",,,,,\"Imported from DIP. DL: $dlrequired. Offline: $offline\"
done
