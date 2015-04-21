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

DEBUGMODE <- FALSE
STARTUP <- FALSE
READDATA <- FALSE
SAMPLEDATA <- FALSE
MAKENGRAMS <- FALSE
SAMPLESIZE <- 1
RPTLEN <- 5
NMAX <- 4
FILTERTHRESHOLD <- 2

if(.Platform$OS.type == "unix") {
  source("rSource/clean.R")
} else{
  source("rSource\\clean.R")
}

if(!exists("NgramDocStats")) load(".RData")
docNames <- fileList
nDocs <- length(fileList)

if(.Platform$OS.type == "unix") {

  source("rSource/cleanText.R")
  source("rSource/helpers.R")
  source("rSource/getCandidates.R")
  source("rSource/predict.R")
  
} else {
  source("rSource\\cleanText.R")
  source("rSource\\helpers.R")
  source("rSource\\getCandidates.R")
  source("rSource\\predict.R")
}

set.seed(1340)

