- Margot Arnt  https://github.com/margot-a42/Projet-PPE
- Zineb Charikh
- Jing LIU

Nous avons choisi le mot "voisin" car il s'agit d'un mot simple utilsé assez couramment. De plus, ce mot a de multiples sens dans la langue française, il désigne quelqu'un qui habite dans le même immeuble/quartier, mais il fait également référence à tout ce qui est à une distance relativement petite.

En français : voisin
En arabe : الجار
En mandarin : 邻居

# Séance 1 :
Nous avons commencé le travail sur les différents fichiers dans premier.sh en testant quelques scripts. Puis tenté d'appliquer sur tab.sh en affichant le résultant dans un tableau créé dans le dossier tableaux. AU début, on avait eu de bons résultats, mais par la suite, rien au niveau du tableau.
ON a pensé à un souci dans les variables mais nous n'avons pas su comment corriger le problème

# Séance 2 :
Nous avons pu générer les différents tableaux avec trois scripts, mais nous avons rencontré certains problèmes par rapport aux liens
Le fait d'avoir créé des variables pour les chemins m'a facilité la tâche.
Toutefois, nous avons encore des erreurs avec les liens chinois
Quant au travail sur iTrameur, nous n'avons pas bien compris les premières consignes, mais nous allons travailler dessus d'inousci le cours du 06/12.

Zineb :
J'ai finalisé les tableaux en corrigeant le nombre d'occurence dans les différentes langues ainsi que les dumps textuels (j'ai fait en sorte que ce soit des fichierx txt)
Pas de problème pour l'arabe et le chinois, mais j'ai toujours cette erreur pour le français:

Alerte ! : Schèma d’URL non supporté !

lynx : fichier de départ introuvable ou n’est pas de type text/html ou text/plain
      Sortie…
J'ai essayé de créer un nouveau fichier texte (le premier était sous mac) et y coller les liens FR, mais pareil

# Suite

Zineb :
j'ai ajouté le mot جيران (pluriel de voisin en arabe) et adapté le script du tableau arabe aux deux mots (càd au contexte + nombre d'occurences)
J'ai modifié le css du tableau
J'ai pu corriger le problème d'encodage des caractères arabes sur les liens du tableau avec la fonction urldecode trouvé sur Stackoverflow https://stackoverflow.com/questions/6250698/how-to-decode-url-encoded-string-in-shell
J'ai trouvé les stopwords chinois sur le git : https://github.com/stopwords-iso/stopwords-zh/blob/master/stopwords-zh.txt
j'ai essayé différentes méthodes, y compris le changement de la police, la conversion et https://amueller.github.io/word_cloud/auto_examples/arabic.html, je rencontre encore des problèmes d'encodage en arabe dans le wordcloud
Même souci pour le chinois quant à l'affichage des liens sur le tableau, et je l'ai également résolu avec la fonction citée plus haut (urldecode)
Quant au nuage de mots, je n'ai rencontré aucun problème avec le français, contrairement aux autres langues
