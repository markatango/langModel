
# Davies, Mark. (2011) N-grams data from the Corpus of Contemporary American English (COCA). Downloaded from http://www.ngrams.info on April 7, 2015. 

dirOrigName <- 'data/final/en_US'
dirCleanName <- 'data/final/en_US_clean'
dirSampName <- 'data/final/en_US_sample'

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
  nTexts <- sapply(texts,function(t)length(t))
  nDocs <- length(nTexts)
  docNames <- fileList
  removeFiles(dirCleanName)
  writeSamples(texts,dirCleanName)

  save.image()
}

if (STARTUP & READDATA){
  # If already present just read in here to sample
  fileNames <- system(paste("dir ", dirCleanName),intern=TRUE)
  fileList <- strsplit(fileNames, "\\s+")[[1]]
  fullFileNames <- paste(dirCleanName,"/",fileList,sep="")
  
  texts <- lapply(fullFileNames, readLines)
  nTexts <- sapply(texts,function(t)length(t))
  nDocs <- length(nTexts)
  docNames <- fileList
  
  save.image()
}


####################  START HERE #################################
SAMPLESIZE <- 0.2
if (SAMPLEDATA){
  set.seed(1340)
  sampTexts <- lapply(1:length(texts),function(i){
    texts[[i]][sample(1:nTexts[i], SAMPLESIZE * nTexts[i])]
  })
  
  removeFiles(dirSampName)
  
  writeSamples(sampTexts,dirSampName)
  
  rm(texts,sampTexts)
  gc()
  
  dCorpus <- Corpus(DirSource(dirSampName))
}

if (MAKENGRAMS){
  
  
  tokens <- lapply(1:nDocs,
                   function(t) lapply(2:NMAX, 
                                      function(i) getTokens(i,t)
                   )
  )
  
  Ngrams <- foreach(b=iter(tokens),.combine="rbind") %do% {
    foreach(c=iter(b),.combine="rbind") %do% c
  }
  
  Ngrams$pref <- exPrefix(Ngrams$tokens)
  Ngrams$suff <- exSuffix(Ngrams$tokens)
  
  Ngrams <- Ngrams[,-which(names(Ngrams)=="tokens")]
  Ngrams <- Ngrams[order(-Ngrams$count, Ngrams$N, Ngrams$doc),]
  Ngrams <- Ngrams[which(Ngrams$suff!=""),]
  Ngrams <- Ngrams[which(Ngrams$count<FILTERTHRESHOLD),]
  Ngrams$n <- 1:dim(Ngrams)[1]
  
  
  NgramDocStats <- dcast(Ngrams, pref+suff~doc,value.var="count",sum)
  NgramDocStats$total <- rowSums(NgramDocStats[,c(as.character(1:nDocs))], na.rm=TRUE)
  NgramDocStats <- NgramDocStats[order(NgramDocStats$pref, -NgramDocStats$total),]
  
  subber <- function(n){
    function(df) df[1:min(n,dim(df)[1]),]
  }
  sub5 <- subber(5)
  sub10 <- subber(10)
  sub15 <- subber(15)
  
  sNDS <- ddply(NgramDocStats, .(pref), sub10)
#   dNDS <- sNDS[,c("pref","suff")]


#  save.image(".RData")
  save(sNDS,file="shortNDS.RData")
#  save(dNDS,file="predictors.RData")
  
}


      