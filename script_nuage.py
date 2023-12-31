#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Dec 31 13:42:42 2023

@author: zina
"""

# -*- coding: utf-8 -*-

import glob
import string
import nltk
from nltk.corpus import stopwords
from wordcloud import WordCloud

# Assurez-vous que les stopwords sont téléchargés
nltk.download('stopwords')

# Définissez les stopwords pour le français et ajoutez manuellement pour le chinois et l'arabe
STOPWORDS_FR = set(stopwords.words('french'))
# STOPWORDS_ZH et STOPWORDS_AR doivent être définis manuellement ou importés d'une source externe

def create_word_cloud():
    langue = input("Choisir une langue entre 'fr', 'zh' ou 'ar'")
    while langue not in ['fr', 'zh', 'ar']:
        langue = input("Choisir une langue entre 'fr', 'zh' ou 'ar'")
    
    text_files = glob.glob(f"./DUMPS-TEXT/{langue}.txt")
    all_texts = ""
    for text in text_files:
        try:
            with open(text, "r", encoding='utf-8') as doc:
                all_texts += doc.read()
        except:
            continue

    # Tokenization et nettoyage du texte
    if langue == 'fr':
        tokenizer = nltk.tokenize.word_tokenize
        stopwords_lang = STOPWORDS_FR
    elif langue == 'zh':
        # Vous devez configurer un tokenizer pour le chinois ici
        stopwords_lang = {}  # Ajoutez vos stopwords pour le chinois ici
    elif langue == 'ar':
        # Vous devez configurer un tokenizer pour l'arabe ici
        stopwords_lang = {}  # Ajoutez vos stopwords pour l'arabe ici

    tokenized_doc = tokenizer(all_texts.lower())
    cleaned_tokenized_doc = [word for word in tokenized_doc if word not in stopwords_lang and word not in string.punctuation]

    # Pas de lemmatisation pour le chinois et l'arabe à moins que vous n'ayez des outils appropriés
    joined_cleaned_doc = " ".join(cleaned_tokenized_doc)
    
    # Génération du nuage de mots
    wordcloud = WordCloud(background_color='white', max_words=200).generate(joined_cleaned_doc)
    
    # Affichage du nuage de mots
    # plt.imshow(wordcloud, interpolation='bilinear')
    # plt.axis('off')
    # plt.show()

create_word_cloud()
