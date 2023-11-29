
while read -r URL; 
   do lynx --dump -assume_charset=utf-8 --display_charset=utf-8 "$URL" > "/home/jing/Projet-PPE/dumps-text/$(basename "$URL" | tr '/' '_').txt"; done < chinois.txt

