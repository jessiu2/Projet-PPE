#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
    echo "Usage : ./script.sh fichier"
    exit
fi

URLS=$1

if [ ! -f "$URLS" ]; then
    echo "On attend un fichier, pas un dossier."
    exit
fi

lang=$(basename -s .txt "$URLS")

if [ lang = "chinois" ]; then
    MOT=".."

    tab="../tableaux/tableau_${lang}.html"
    echo "<html>
    <head>
        <meta charset=\"UTF-8\">
    </head>
    <body>
        <h1><b>Tableau</b></h1>
        <table>
            <tr>
                <th>Numero ligne</th><th>URL</th><th>Aspiration</th><th>Dump textuel</th><th>Code HTTP</th><th>Encodage</th><th>Nombre d'occurences</th>
            </tr>" > "$tab"
    lineno=1

    while read -r URL; do
        reponse=$(curl -s -I -w "%{http_code}" -o "../aspirations/${lang}-${lineno}.html" "$URL")

        # Récupérer dump textuel
        dumptext=$(lynx -dump -nolist "../dumps-text/${lang}-${lineno}.html" "$URL")

        # Encodage
        encoding=$(curl -s -I -L -w "%{content_type}" -o /dev/null "$URL" | egrep -E -o "charset=\S+" | cut -d"=" -f2 | tail -n 1)

        occurence=$(egrep -o "$MOT" <<< "$dumptext" | wc -l)

        echo "<tr>
                <td>$lineno</td><td>$URL</td><td><a href=\"$reponse\">Aspiration</a></td><td><a href=\"$dumptext\">Dump</a></td><td>$reponse</td><td>$encoding</td><td>$occurence</td>
            </tr>" >> "$tab"

        lineno=$(expr $lineno + 1)
    done < "$URLS"

    echo "        </table>
    </body>
    </html>" >> "$tab"
fi
