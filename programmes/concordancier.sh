#!/usr/bin/env bash


if [[ $# -ne 4 ]]; then
	echo "Usage : ./concordancier.sh mot noline contexte lang"
    exit
fi

MOT=$1
lineno=$2
cont=$3
lang=$4

OUTPUT_FILE="../concordances/${lang}-${lineno}.html"

echo "<html>
<head>
    <meta charset=\"UTF-8\">
    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\">
    <style>
        .table-container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .has-background-rose {
            background-color: #FFE7FE;
        }
    </style>
</head>
<body>
    <div class=\"container\">
        <div class=\"table-container\">
            <table class=\"table is-bordered is-striped is-hoverable is-fullwidth\">
                <tr class=\"has-background-rose\">
                    <th>Gauche</th><th>Mot</th><th>Droite</th>
		</tr>" > $OUTPUT_FILE

		egrep -o "(\w+\W+){0,5} ($MOT) (\w+\W+){0,5}" $cont | sed -E "s/(.*)($MOT)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/" >> $OUTPUT_FILE


echo "            </table>
        </div>
    </div>
</body>
</html>" >> $OUTPUT_FILE

