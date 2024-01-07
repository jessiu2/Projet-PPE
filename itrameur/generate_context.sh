if  [[ $# -ne 2 ]]
then 
echo "Deux arguments attendus: <dossier> <langue>"
exit
fi

dossier=$1
langue_abr=$2   

echo "<lang=\"$langue_abr\">" > contexte.txt


for filepath in $(ls -Utr $dossier/$langue_abr-*.txt)
do
# filepath == dumps-text/fr-1.txt
#  == > pagename =fr-1
echo "$filepath"
pagename="$(basename -s .txt $filepath)"  #ch-1
echo "<page=\"$pagename\">" >> contexte.txt
echo "<text>"  >> contexte.txt

#on récupère les dumps ou contextes
# et on écrit à l'intérieur de la base text
content=$(cat $filepath)
# ordre important : & en premier
# sinon : < => < ; => &lt: 
content=$(echo "$content" | sed 's/&/&/g')
content=$(echo "$content" | sed 's/</</g')
content=$(echo "$content" | sed 's/>/>/g')  
echo "$content" >> contexte.txt
echo "</text>" >> contexte.txt
echo "</page> §" >> contexte.txt
done
echo "</lang>" >> contexte.txt
