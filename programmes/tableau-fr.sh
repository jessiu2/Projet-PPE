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
        <h1><b>Tableau</b></h1>
        <table border='1'>
            <tr>
                <th>Numero ligne</th><th>URL</th><th>Aspiration</th><th>Dump textuel</th><th>Code HTTP</th><th>Encodage</th><th>Nombre d'occurences</th><th>Contexte</th><th>Concordancier</th>
            </tr>" > "$tab"
    lineno=1

    while read -r URL; do
        reponse=$(curl -s -L -w "%{http_code}" -o "../aspirations/${lang}-${lineno}.html" "$URL")
        asp="../aspirations/${lang}-${lineno}.html"

        # Récupérer dump textuel
        # Changement ici : le fichier de dump sera maintenant un .txt
        dumptext=$(lynx -dump -nolist "$URL" > "../dumps-text/${lang}-${lineno}.txt")
        dump="../dumps-text/${lang}-${lineno}.txt"

        # Encodage
        encoding=$(curl -s -I -L -w "%{content_type}" -o /dev/null "$URL" | egrep -E -o "charset=\S+" | cut -d"=" -f2 | tail -n 1)

        # Calculer le nombre d'occurrences du mot
        occurence=$(grep -o "$MOT" "$dump" | wc -l)

        # Extraire les contextes d'apparition du mot
    # On utilise grep avec les options -i pour l'insensibilité à la casse, -o pour récupérer uniquement le mot,
    # -C 2 pour obtenir 2 lignes avant et après le mot, et -h pour ne pas afficher le nom du fichier dans le résultat.
    # Ensuite, on redirige la sortie vers le fichier de contexte.
        contextes=$(grep -i -C 2 "$MOT" "$dump" > "../contextes/${lang}-${lineno}.txt")
        cont="../contextes/${lang}-${lineno}.txt"


        ./concordancier.sh "$MOT" "$lineno" "$cont" "$lang"
		concordancier="../concordances/${lang}-${lineno}.html"

        echo "<tr>

                <td>$lineno</td><td><a href="$URL">$URL</a></td><td><a href=\"$asp\">Aspiration</a></td><td><a href=\"$dump\">Dump</a></td><td>$reponse</td><td>$encoding</td><td>$occurence</td><td><a href=\"$cont\">Voir contexte</a></td><td><a href='$concordancier'>Concordancier</a></td></tr>" >> "$tab"

        lineno=$((lineno + 1))
    done < "$URLS"

    echo "        </table>
    </body>
    </html>" >> "$tab"
fi
