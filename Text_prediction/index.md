---
title       : Text Prediction Using R
subtitle    : English text prediction using a simple statistical language model
author      : Mark Rodighiero
job         : 
framework   : revealjs        # {io2012, html5slides, shower, dzslides,n landslide, deck.js, slideous, beamer, showoff ...}
revealjs    : {theme: moon, transition: cube}
highlighter : highlight.js  # {highlight.js, prettify, highlight, Google Prettify,}
hitheme     : tomorrow      # tomorrow
widgets     : [mathjax]            # {mathjax, quiz, bootstrap}
mode        : standalone  # {standalone, selfcontained, draft}
knit        : slidify::knit2slides
---

## Simple text prediction
#### Mark Rodighiero
#### April 26, 2015
#### *Overview*

This project illustrates a 'next word' text prediction technique based on a simple statistical model of language. In this  model, the predicted 'next word' is the word with the highest probability of occurrence conditioned on the words that proceed it. Three source texts were used for estimating the conditional probabilities and for estimating the performance of the prediction algorithm. The same sources were used to build the final demonstration project, implemented in publicly accessible webpage at [data-dancer.com/langModel](http://data-dancer.com/langModel).

---

#### *What it does*

This algorithm predicts the most likely word that will immediately follow an input word or phrase. Actually, a set of up to 10 words is returned in decreasing likelihood as predicted by each of the source texts and for all source texts combined.  The probability of occurrence of each word in the set is illustrated graphically.

---

#### *Source texts and data cleaning*

The source texts comprise excerpts from on-line news sources, blogs, and twitter posts.  These three sources vary in terms of vocabulary, writing style, and word statistics.  The source texts were processed in the following way:

* Common contractions and abbreviations were expanded to complete words
* Money, dates, URLs, e-mail addresses and other numbers are predictive in a generic sense. Therefore, these elements were converted to _tags_ as \<money\>, \<date\>, \<URL\>, \<email\>, and \<number\> respectively.
* Recognizing that the words at the end of the sentence would not be good predictors for the first words of a following sentence, the source text files were reformatted as one sentence per line. 

---

#### *How the algorithm works*

The texts were then tokenized by word boundaries into 2-, 3-, and 4-grams on a line by line (i.e, sentence by sentence) basis.  The n-grams were split into "prefix" (first n-1 words in the n-gram) and "suffix" (last word in the n-gram). Finally, the relative frequencies of occurrence for each suffix for a given prefix in each document and for all three documents combined were calculated. 

Prediction works as follows: 

1. The last three words of an input phrase are used to index into the 4-gram token prefixes. 
2. The corresponding suffixes with the highest frequency of occurrence are returned as candidates. 
3. If the last three words do not match any 4-gram prefixes, then the last two words of the input phrase are used to index into the 3-gram token prefixes, and so on. 

---

#### *How to use the product*

1. Using a web browser, navigate to [data-dancer.com/langModel](http://data-dancer.com/langModel)
2. Enter a word or phrase in the text input box in the left side panel.
3. After a few moments, the most likely next word is shown to the right of the text input box. In addition, a set of words will appear for each of the source documents along with a bargraph showing the estimated conditional probability for each of the predicted words.  The label on the horizontal axis shows the final prefix that was used in the prediction.




