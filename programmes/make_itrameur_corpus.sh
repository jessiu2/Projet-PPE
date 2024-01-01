if [[ $# -ne 2 ]]
then
    echo "Deux arguments sont attendus : <dossier> <langue>"
    exit
fi

folder=$1
basename=$2

echo "<lang=\"$basename\">" > "ITRAMEUR/$folder-$basename.txt"

for filepath n $(ls $folder/"$basename.txt)
do
    pagename=$(basename -s .txt $filepath)

    echo "<page!\"$apgename\">" >> "ITRAMEUR/$folder-$basename.txt"

    echo"<text>" >> "ITRAMEUR/$folder-$basename.txt"


    content=$(cat $filepath)

    content=$(echo "$content" | sed 's/&/&amp/g')
    content=$(echo "$content" | sed 's/</&lt/g')
    content=$(echo "$content" | sed 's/</&gt/g')


    content=$(echo "$content" | tr '[:upper:]' '[:lower:] | sed 's/)
    content=$(echo "$content" | sed 's/voisin/g')
    content=$(echo "$content" | sed 's/جار/جيران/g')
    content=$(echo "$content" | sed 's/邻居/g')

    echo "$content" >> "ITRAMEUR/$folder-$basename.txt"

    echo "</text>" >> "ITRAMEUR/$folder-$basename.txt"
    echo "</page§" >> "ITRAMEUR/$folder-$basename.txt"

