if [[ $# -ne 2 ]]
then
    echo "Deux arguments sont attendus : <dossier> <langue>"
    exit
fi

folder=$1
basename=$2

echo "<lang=\"$basename\">" > "ITRAMEUR/$folder-$basename.txt"

for filename in $(ls ${folder}/${basename}-*.txt);
do
    page=$(basename -s .txt "$filename")
    content=$(cat $filename)


    cleaned=$(echo "$content" | sed 's/&/&amp;/g')
    cleaned=$(echo "$cleaned" | sed 's/</&lt;/g')
    cleaned=$(echo "$cleaned" | sed 's/>/&gt;/g')

 	echo "<page=\"$page\">" >> "ITRAMEUR/$folder-$basename.txt"

    echo "<text>" >> "ITRAMEUR/$folder-$basename.txt"
    
    echo "$cleaned" >> "ITRAMEUR/$folder-$basename.txt"

    echo "</text>" >> "ITRAMEUR/$folder-$basename.txt"
    echo "</page> §" >> "ITRAMEUR/$folder-$basename.txt"
    
done

echo "</lang>" >> "ITRAMEUR/$folder-$basename.txt"
