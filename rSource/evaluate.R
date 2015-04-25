
# remove existing corpus and ngram data and tokens to free up memory
rm(dCorpus,Ngrams,NgramDocStats,tokens)
gc()

# load the reduced full text sets so things fit into memory
if(!exists(texts)){
  # If already present just read in here to sample
  fileNames <- system(paste("dir ", dirSampleName),intern=TRUE)
  fileList <- strsplit(fileNames, "\\s+")[[1]]
  fullFileNames <- paste(dirSampleName,"/",fileList,sep="")
  
  texts <- lapply(fullFileNames, readLines)
  nTexts <- sapply(texts,function(t)length(t))
  nDocs <- length(nTexts)
  docNames <- fileList
}

n <- 1
NFOLD <- 5
samplesSizes <- c(0.05,0.025,0.0125,0.00625)
for(i in 1:NFOLD){
  testSelect <- lapply(nTexts,function(n) {runif(n)<1/NFOLD } )
  testTexts <- lapply(1:length(testSelect),function(i) texts[[i]][testSelect[[i]]])
  trainTexts <- lapply(1:length(testSelect),function(i) texts[[i]][!(testSelect[[i]])])
  
  # sample the training set for this run
  ntTexts <- sapply(trainTexts,function(t)length(t))
  ntDocs <- length(nTexts)
  
  # use all the test samples
  removeFiles(dirSampName)
  writeSamples(testTexts,dirSampName)
  dCorpus <- Corpus(DirSource(dirSampName))
  testTokens <- lapply(1:ntDocs,
                       function(t) lapply(2:NMAX, 
                                          function(i) getTokens(i,t)
                       )
  )
  
  testNgrams <- foreach(b=iter(testTokens),.combine="rbind") %do% {
    foreach(c=iter(b),.combine="rbind") %do% c
  }
  
  testNgrams$pref <- exPrefix(testNgrams$tokens)
  testNgrams$suff <- exSuffix(testNgrams$tokens)
  for(j in sampleSizes){
    
    i <- 1
    j <- 0.00125
    
    set.seed(1340)
    sampTexts <- lapply(1:length(trainTexts),function(i){
      texts[[i]][sample(1:ntTexts[i], j * ntTexts[i])]
    })
    removeFiles(dirSampName)
    writeSamples(sampTexts,dirSampName)
    
    dCorpus <- Corpus(DirSource(dirSampName))
        
    tokens <- lapply(1:ntDocs,
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
    #Ngrams <- Ngrams[-which(Ngrams$count<FILTERTHRESHOLD),]
    Ngrams$n <- 1:dim(Ngrams)[1]
    
    
    NgramDocStats <- dcast(Ngrams, pref+suff~doc,value.var="count",sum)
    NgramDocStats$total <- rowSums(NgramDocStats[,c(as.character(1:ntDocs))], na.rm=TRUE)
    NgramDocStats <- NgramDocStats[order(NgramDocStats$pref, -NgramDocStats$total),]
    
    subber <- function(n){
      function(df) df[1:min(n,dim(df)[1]),]
    }
    sub5 <- subber(5)
    sub10 <- subber(10)
    sub15 <- subber(15)
    
    sNDS <- ddply(NgramDocStats, .(pref), sub10)

   
   save.image()
   
  }
  
  
  # for each testNgram, is suff in predict(pref)
  inOut <- function(testPrefSuf){
    testPrefSuf$suff
  }
  }