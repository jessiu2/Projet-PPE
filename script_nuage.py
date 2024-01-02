import nltk
from nltk.corpus import stopwords

# Télécharger le corpus des stopwords si ce n'est pas déjà fait
nltk.download('stopwords')

# Accéder aux stopwords en arabe
arabic_stopwords = stopwords.words('arabic')

# Afficher les premiers stopwords en arabe pour vérification
print(arabic_stopwords[:10])
