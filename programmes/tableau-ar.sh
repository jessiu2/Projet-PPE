#!/usr/bin/env bash

urldecode() {
  local url_encoded="${1//+/ }"
  printf '%b' "${url_encoded//%/\\x}"
}

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
    <title>Tableau arabe</title>
      <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            background-color: #eeeeee; /* Fond du tableau */
        }
        th {
            background-color: #dcdcdc; /* Fond plus clair pour les en-têtes */
            color: black; /* Texte en noir pour les en-têtes */
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        .url-column {
            width: 5%; /* Largeur encore plus réduite pour la colonne URL */
            word-break: break-all;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
    </style>
    </head>
    <body>
        <table>
            <tr>
                <th>N° ligne</th><th>URL</th><th>Aspiration</th><th>Dump textuel</th><th>Code HTTP</th><th>Encodage</th><th>Nombre total d'occurences</th><th>Contexte</th>
            </tr>" > "$tab"
    lineno=1

  while IFS= read -r URL; do
        # Decodage de l'URL
        decoded_url=$(urldecode "$URL")

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
                <td>$lineno</td><td><a href=\"$URL\">$decoded_url</a></td><td><a href=\"$asp\">Aspiration</a></td><td><a href=\"$dump\">Dump</a></td><td>$reponse</td><td>$encoding</td><td>$total_occurences</td><td><a href=\"$cont\">Voir contexte</a></td></tr>" >> "$tab"

        lineno=$(expr $lineno + 1)
    done < "$URLS"

    echo "        </table>
    </body>
    </html>" >> "$tab"
fi
