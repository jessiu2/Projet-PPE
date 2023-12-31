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

if [ "$lang" = "arabe" ]; then
    MOT1="جار"
    MOT2="جيران"

    tab="../tableaux/tableau_${lang}.html"
    echo "<html>
    <head>
        <meta charset=\"UTF-8\">
    </head>
    <body>
        <h1><b>Tableau</b></h1>
        <table border=\"1\">
            <tr>
                <th>Numero ligne</th><th>URL</th><th>Aspiration</th><th>Dump textuel</th><th>Code HTTP</th><th>Encodage</th><th>Nombre total d'occurences</th><th>Contexte</th>
            </tr>" > "$tab"
    lineno=1

    while read -r URL; do
        reponse=$(curl -s -L -w "%{http_code}" -o "../aspirations/${lang}-${lineno}.html" "$URL")
        asp="../aspirations/${lang}-${lineno}.html"

        # Récupérer dump textuel
        dumptext=$(lynx -dump -nolist "$URL" > "../dumps-text/${lang}-${lineno}.txt")
        dump="../dumps-text/${lang}-${lineno}.txt"

        # Encodage
        encoding=$(curl -s -I -L -w "%{content_type}" -o /dev/null "$URL" | egrep -E -o "charset=\S+" | cut -d"=" -f2 | tail -n 1)

        # Calculer le nombre d'occurrences de chaque mot et leur somme
        occurence1=$(grep -o "$MOT1" "$dump" | wc -l)
        occurence2=$(grep -o "$MOT2" "$dump" | wc -l)
        total_occurences=$(($occurence1 + $occurence2))

        # Extraire les contextes d'apparition des deux mots dans le même fichier
        grep -i -C 2 "$MOT1" "$dump" > "../contextes/contexte_${lang}-${lineno}.txt"
        echo "-----" >> "../contextes/contexte_${lang}-${lineno}.txt"  # Un séparateur
        grep -i -C 2 "$MOT2" "$dump" >> "../contextes/contexte_${lang}-${lineno}.txt"
        cont="../contextes/contexte_${lang}-${lineno}.txt"

        echo "<tr>
                <td>$lineno</td><td><a href=\"$URL\">$URL</a></td><td><a href=\"$asp\">Aspiration</a></td><td><a href=\"$dump\">Dump</a></td><td>$reponse</td><td>$encoding</td><td>$total_occurences</td><td><a href=\"$cont\">Voir contexte</a></td></tr>" >> "$tab"

        lineno=$(expr $lineno + 1)
    done < "$URLS"

    echo "        </table>
    </body>
    </html>" >> "$tab"
fi
