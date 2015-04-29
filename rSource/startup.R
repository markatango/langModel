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
RPTLEN <- 5
GRAPHLEN <- 10
NMAX <- 4
FILTERTHRESHOLD <- 1
TESTSUBSAMPLESIZE <- 1000

echoRDir <- function(dir){
  function(rfile) {
    fName <- paste0(dir,"/",rfile)
    source(fName, echo=TRUE) 
  }
}

stopExistsMod <- function(ch.rModule) {
  function(ch.obj) if (!exists(ch.obj)) stop(paste0(ch.rModule,": '",ch.obj,"' ","does not exist"))
}
  
echoSource <- echoRDir("rSource")

#==========================  START ================================

set.seed(1340)


echoSource("helpers.R")
echoSource("cleanText.R")

## set sample size for initial data input
# creates full, clean data files in the clean data directory
if(STARTUP){
  SAMPLESIZE <- 1
  echoSource("getSourceData.R")
}

if(SAMPLEDATA){
  SAMPLESIZE <- 0.2
  echoSource("sampleSourceData.R")
}
# creates a subset of clean data from "texts" which must be in memory

if(MAKENGRAMS){
  echoSource("makeNgrams.R")
}
echoSource("getCandidates.R")
echoSource("predict.R")



