
# Davies, Mark. (2011) N-grams data from the Corpus of Contemporary American English (COCA). Downloaded from http://www.ngrams.info on April 7, 2015. 
if(!ONSURFACE){
  dirOrigName <- 'data/final/en_US'
  dirCleanName <- 'data/final/en_US_clean'
  dirSampName <- 'data/final/en_US_sample'
  dirTempName <- 'data/final/en_US_temp'
} else {
  dirOrigName <- 'D:/Capstone-language-analysis/Coursera-SwiftKey/final/en_US'
  dirCleanName <- 'D:/Capstone-language-analysis/Coursera-SwiftKey/final/en_US_clean'
  dirSampName <- 'D:/Capstone-language-analysis/Coursera-SwiftKey/final/en_US_sample'
  dirTempName <- 'D:/Capstone-language-analysis/Coursera-SwiftKey/final/en_US_temp'
}

readAndLower <- function(f,dirName){
  t <- readLines(paste0(dirName,"/",f,collapse=" "),skipNul=TRUE,encoding='latin1')
  t <- iconv(t,from="latin1",to="ASCII",sub="")
  tolower(t)
}

removeFiles <- function(dirName){
  dirName <- gsub("\\\\","/",dirName)
  system(paste0("rm ",dirName,"/*.*",collapse=""))
}

writeSamples <- function(x,dirName){
  n <- length(x)
  for (i in 1:n){
    outFile <- gsub(".txt","",fileList[i])
    outFile <- gsub("_sample_\\d\\.?\\d*","",outFile)
    outFile <- paste0(outFile,"_sample_",SAMPLESIZE,".txt")
    writeLines(x[[i]],paste0(dirName,"/",outFile))
  }
}

#==========================  START ================================

stopExists <- stopExistsMod("getSourceData.R")

# Get the lower case full data initially, clean, one line per sentence
if (STARTUP & !READDATA){
  fileNames <- system(paste("dir ", dirOrigName),intern=TRUE)
  fileList <- strsplit(fileNames, "\\s+")[[1]]
  
  texts <- lapply(fileList, readAndLower, dirOrigName)
  if (SAMPLESIZE < 1.0){
      nTexts <- sapply(texts,length)
      set.seed(1340)
      texts <- lapply(1:length(texts),function(i){
        texts[[i]][sample(1:nTexts[i], SAMPLESIZE * nTexts[i])]
      })
  }

  # delay cleaning until sample is selected (cleaning is slow)
  texts <- lapply(texts,cleanText)

  removeFiles(dirCleanName)
  writeSamples(texts,dirCleanName)
}

if (STARTUP & READDATA){
  # If clean data is already present just read in here to sample
  fileNames <- system(paste("dir ", dirCleanName),intern=TRUE)
  fileList <- strsplit(fileNames, "\\s+")[[1]]
  fullFileNames <- paste(dirCleanName,"/",fileList,sep="")
  
  texts <- lapply(fullFileNames, readLines)
}

stopExists("texts")
stopExists("fileList")
stopExists("fullFileNames")

nTexts <- sapply(texts,function(t)length(t))
nDocs <- length(nTexts)
save.image()


