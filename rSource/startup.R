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
STARTUP <- TRUE
READDATA <- FALSE
SAMPLEDATA <- TRUE
MAKENGRAMS <- TRUE
SAMPLESIZE <- 1
RPTLEN <- 5
GRAPHLEN <- 10
NMAX <- 4
FILTERTHRESHOLD <- 3

if(.Platform$OS.type == "unix") {
  source("rSource/helpers.R")
  source("rSource/cleanText.R")
  source("rSource/N_gram_tokenizer.R")
} else {
  source("rSource\\helpers.R")
  source("rSource\\cleanText.R")
  source("rSource\\N_gram_tokenizer.R")
}

if(.Platform$OS.type == "unix") {
  source("rSource/clean.R")
} else {
  source("rSource\\clean.R")
}

#if(!exists("sNDS")) load("shortNDS.RData")
#docNames <- fileList
#nDocs <- length(fileList)

if(.Platform$OS.type == "unix") {
  
  source("rSource/getCandidates.R")
  source("rSource/predict.R")
} else {
  
  source("rSource\\getCandidates.R")
  source("rSource\\predict.R")
}

set.seed(1340)

