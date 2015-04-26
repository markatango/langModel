library(tm)
library(reshape2)
library(ggplot2)
library(slam)
library(pryr)
library(pracma)
library(stringi)
library(foreach)
library(iterators)
library(shiny)
library(plyr)
library(caret)

ONSURFACE <- FALSE
DEBUGMODE <- FALSE
STARTUP <- FALSE
READDATA <- FALSE
SAMPLEDATA <- FALSE
MAKENGRAMS <- FALSE
SAMPLESIZE <- 1
RPTLEN <- 5
GRAPHLEN <- 10
NMAX <- 4
FILTERTHRESHOLD <- 1
TESTSUBSAMPLESIZE <- 1000

source("rSource/helpers.R", echo=TRUE)
source("rSource/cleanText.R", echo=TRUE)
source("rSource/N_gram_tokenizer.R", echo=TRUE)
source("rSource/clean.R", echo=TRUE)

source("rSource/getCandidates.R", echo=TRUE)
source("rSource/predict.R", echo=TRUE)

set.seed(1340)

