#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 5 23:51:42 2024
@author: zina
"""

import glob
import jieba
import matplotlib.pyplot as plt
from wordcloud import WordCloud
from nltk.corpus import stopwords
from os.path import isfile

# Définissez le chemin des stopwords et des polices
stopwords_path = '/media/zina/Commun/Studies/Programmation et projet encadré PPE/Projet-PPE/programmes'
fonts_path = '/usr/share/fonts/truetype/noto/'

# Chargez les stopwords pour chaque langue
francais_stopwords = set(stopwords.words('french'))
nouveaux_stopwords = ["c'est", "ça","a","si","qu'il"]
francais_stopwords.update(nouveaux_stopwords)
arabe_stopwords = set(stopwords.words('arabic'))
with open(f'{stopwords_path}stopwords-zh.txt', 'r', encoding='utf-8') as file:
    chinois_stopwords = set(file.read().splitlines())

# Définissez le chemin des polices pour chaque langue
font_paths = {
    'francais': f'{fonts_path}NotoSans-Regular.ttf',
    'chinois': f'{fonts_path}NotoSansSC-Regular.otf',
    'arabe': f'{fonts_path}NotoNaskhArabic-Regular.ttf'
}

def generate_wordcloud(langue, stopwords_set, font_path):
    text_files = glob.glob(f"../dumps-text/{langue}*.txt")
    all_texts = ""

    for text_file in text_files:
        with open(text_file, 'r', encoding='utf-8', errors='ignore') as file:
            all_texts += ' ' + file.read().lower()

    if langue == 'chinois':
        all_texts = ' '.join(jieba.cut(all_texts))

    width = 1600
    height = 800
    wordcloud = WordCloud(
        background_color='black',
        stopwords=stopwords_set,
        max_words=100,
        font_path=font_path,
        width=width,  # Largeur de l'image
        height=height  # Hauteur de l'image
    ).generate(all_texts)

    plt.figure(figsize=(width / 100, height / 100), dpi=100)
    plt.imshow(wordcloud, interpolation='bilinear')
    plt.axis("off")
    plt.savefig(f"{stopwords_path}wordcloud_{langue}.png", dpi=300)
    plt.show()


def main():
    langue = input("Choisir une langue entre 'francais', 'chinois' ou 'arabe': ")

    if langue not in font_paths:
        raise ValueError("Langue non prise en charge.")

    if not isfile(font_paths[langue]):
        raise FileNotFoundError(f"Le fichier de police pour {langue} est introuvable à {font_paths[langue]}")

    stopwords_set = {
        'francais': francais_stopwords,
        'chinois': chinois_stopwords,
        'arabe': arabe_stopwords
    }.get(langue)

    wordcloud=generate_wordcloud(langue, stopwords_set, font_paths[langue])

if __name__ == "__main__":
    main()
