#!/usr/bin/env bash

URLS="../URLs/"
lineno=1

for file in "$URLS"*
do
    while read -r URL
        do
            lang=$(basename "$file" .txt)
            #curl
            reponse=$(curl -s -I -w "%{http_code}" -o "../aspirations/${lang}-${lineno}.html" "$URL")

            #récupérer dump textuel
            dumptext=$(lynx -dump -nolist "../dumps-text/${lang}-${lineno}.html" "$URL")

            #encodage
            encoding=$(curl -s -I -L -w "%{content_type}" -o /dev/null "$URL" | egrep -E -o "charset=\S+" | cut -d"=" -f2 | tail -n 1)

            lineno=$(expr $lineno + 1)
        done < "$file"
done


