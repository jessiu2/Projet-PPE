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

if [ "$lang" = "francais" ]; then
    MOT="voisin"

    tab="../tableaux/tableau_${lang}.html"
    echo "<html>
    <head>
        <meta charset=\"UTF-8\">
    </head>
    <body>
        <h1><b>Tableau</b></h1>
        <table border='1'>
            <tr>
                <th>Numero ligne</th><th>URL</th><th>Aspiration</th><th>Dump textuel</th><th>Code HTTP</th><th>Encodage</th><th>Nombre d'occurences</th><th>Contexte</th>
            </tr>" > "$tab"
    lineno=1

    while read -r URL; do
        reponse=$(curl -s -L -w "%{http_code}" -o "../aspirations/${lang}-${lineno}.html" "$URL")
        asp="../aspirations/${lang}-${lineno}.html"

        # Récupérer dump textuel
        dumptext=$(lynx -dump -nolist "../dumps-text/${lang}-${lineno}.html" "$URL")
        dump="../dumps-text/${lang}-${lineno}.html"

        # Encodage
        encoding=$(curl -s -I -L -w "%{content_type}" -o /dev/null "$URL" | egrep -E -o "charset=\S+" | cut -d"=" -f2 | tail -n 1)

        occurence=$(egrep -o "$MOT" <<< "$dumptext" | wc -l)

                # Extraire les contextes d'apparition du mot
        contextes=$(grep -i -C 2 "$MOT" <<< "$dumptext" > "../contextes/contexte_${lang}-${lineno}.txt")
        cont="../contextes/contexte_${lang}-${lineno}.txt"

        echo "<tr>

                <td>$lineno</td><td><a href="$URL">$URL</a></td><td><a href=\"$asp\">Aspiration</a></td><td><a href=\"$dump\">Dump</a></td><td>$reponse</td><td>$encoding</td><td>$occurence</td><td><a href=\"$cont\">Voir contexte</a></td></tr>" >> "$tab"

        lineno=$((lineno + 1))
    done < "$URLS"

    echo "        </table>
    </body>
    </html>" >> "$tab"
fi
