import jieba

#jieba.load_userdict('userdict.txt') mais marche pas
def stopwordslist(filepath):
    stopwords = [line.strip() for line in open(filepath, 'r', encoding='utf-8').readlines()]
    return stopwords

# pour segmenter
def seg_sentence(sentence):
    sentence_seged = jieba.cut(sentence.strip())
    stopwords = stopwordslist('stop_words.txt')
    outstr = ''
    for word in sentence_seged:
        if word not in stopwords:
            if word != '\t':
                outstr += word
                outstr += " "
    return outstr

# enfin
inputs = open('contexte-chinois.txt', 'r', encoding='utf-8')
outputs = open('corpus-ch_itrameur_final.txt', 'w')
for line in inputs:
    line_seg = seg_sentence(line)
    outputs.write(line_seg + '\n')
outputs.close()
inputs.close()
