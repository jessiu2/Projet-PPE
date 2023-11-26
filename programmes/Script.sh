#!/usr/bin/env bash

URLS="../URLs/"
lineno=1

for file in "$URLS"*
do
    lang=$(basename "$file" .txt)
    while read -r URL
        do
            #reponse=$(curl -s -I -w "%{http_code}" -o "./aspirations/${lang}-${lineno}.html" "$URL")
            encoding=$(curl -s -I -L -w "%{content_type}" -o /dev/null $URL | grep -P -o "charset=\S+" | cut -d"=" -f2 | tail -n 1)
            echo -e "$lineno\t$URL\t$encoding"
            lineno=$((lineno + 1))
        done < "$file"
done
