
import glob
import nltk
import string
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.stem import WordNetLemmatizer
from wordcloud import WordCloud
import matplotlib.pyplot as plt

# Liste des langues pour lesquelles nous avons des stopwords

# Télécharger le corpus des stopwords si ce n'est pas déjà fait
nltk.download('stopwords')

# Accéder aux stopwords en arabe
STOPWORDS_AR = stopwords.words('arabic')
STOPWORDS_FR = stopwords.words('french')


# Fonction pour créer le nuage de mots
def create_word_cloud():
    # Utilisateur choisit une langue
    langue = input("Choisir une langue entre 'it', 'fr', 'gr' ou 'ar': ")
    while langue not in ['it', 'fr', 'gr', 'arabe']:
        langue = input("Choisir une langue entre 'it', 'fr', 'gr' ou 'arabe': ")
    
    # Lecture des fichiers de la langue choisie
    text_files = glob.glob(f"/dumps-text/{langue}*.txt")
    all_texts = ""
    for text_file in text_files:
        with open(text_file, 'r', encoding='utf-8') as file:
            all_texts += file.read().lower()

    # Tokenize et nettoyage du texte
    tokenizer = WordNetLemmatizer()
    tokens = word_tokenize(all_texts)
    tokens = [word for word in tokens if word not in string.punctuation]
    
    # Filtrage avec stopwords
    filtered_tokens = []
    if langue == "arabe":
        filtered_tokens = [word for word in tokens if word not in STOPWORDS_AR]
    elif langue == "fr":
        filtered_tokens = [word for word in tokens if word not in STOPWORDS_FR]
 
    # Lemmatisation
    lemmatized_tokens = [tokenizer.lemmatize(word) for word in filtered_tokens]
    cleaned_text = ' '.join(lemmatized_tokens)

    # Génération du nuage de mots
    font_path = '/usr/share/fonts/truetype/noto/NotoSansCJK-Regular.ttc' if langue in ['chubois', 'arabe'] else None
    wordcloud = WordCloud(
        font_path=font_path,  # Chemin vers la police qui supporte les caractères arabes et chinois
        background_color='white',
        max_words=200
    ).generate(cleaned_text)

    # Affichage du nuage de mots
    plt.imshow(wordcloud, interpolation='bilinear')
    plt.axis('off')
    plt.show()


create_word_cloud()
