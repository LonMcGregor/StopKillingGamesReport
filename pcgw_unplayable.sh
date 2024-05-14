#!/bin/bash

# Usage: Use CURL to download all of the webpages at
# https://www.pcgamingwiki.com/wiki/Category:Unplayable_games
# Then run this file in your directory with the html pages:
# ./script.sh > processed.csv

for file in *.html; do
  title=$(grep -Eso '<h1 class="article-title">([^<]*)' $file | cut -d \> -f2 | cut -d \& -f1)
  publisher=$(pcregrep -Mso 'Publishers?</th>\s+</tr>\s+<tr>\s+<td class="template-infobox-type"></td>\s+<td class="template-infobox-info"><a href="([^"]*)' $file| tr '\n' ' ' | cut -d: -f 2 | cut -d \& -f1)
  genre=$(pcregrep -Mso 'Genres?</td>\s+<td class="template-infobox-info">\s+<a href="/wiki/Category:([^"]*)' $file| tr '\n' ' ' | sed s/'["]'//g | cut -d: -f 2 | cut -d \& -f1)
  money=$(pcregrep -Mso 'Monetization</td>\s+<td class="template-infobox-info"><a href="/wiki/Category:([^"]+)' $file | tr '\n' ' ' | sed s/'["]'//g | cut -d: -f2 | cut -d \& -f1)
  igp=$(pcregrep -Mso 'Microtransactions</td>\s+<td class="template-infobox-info"><a href="/wiki/Category:([^"]+)' $file| tr '\n' ' ' | sed s/'["]'//g | cut -d: -f 2 | cut -d \& -f1)
  pubdate=$(pcregrep -Mso 'Windows</td>\s+<td class="template-infobox-info">([^<]+)' $file| tr '\n' ' ' | sed s/'["]'//g | cut -d \> -f 3 | cut -d \& -f1)
  normdate=$(date -d "$pubdate" +"%Y-%m-%d")
  money=$(echo $money | sed -e 's/Freeware/F2P/g' -e 's/Free-to-play/F2P/g' -e 's/One-time_game_purchase/Paid/g')
  if [[ "$igp" && "$igp" != "No_microtransactions" ]]; then
    igp=",IGP"
  fi
  echo \"$title\",\"$publisher\",\"$genre\",\"PC\",\"$money $igp\",\"$normdate\",,Unplayable,,,
done
