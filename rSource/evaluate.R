inOut <- function(testNgram){
  testNgram$suff %in%  predictFromTextFold(testNgram$pref)$uSAD
}

# remove existing corpus and ngram data and tokens to free up memory
rm(dCorpus,Ngrams,NgramDocStats,tokens)
gc()

NFOLD <- 5
samplesSizes <- c(0.5,0.25,0.125,0.0625)
perf <- matrix(rep(0,NFOLD*length(samplesSizes)),nrow=NFOLD)
# load the reduced full text sets so things fit into memory
if(!exists("texts")){
  # If already present just read in here to sample
  fileList <- paste(unlist(strsplit(system(paste("dir ", dirSampName),intern=TRUE),"\\s+")),sep=" ")
  fullFileNames <- paste(dirSampName,"/",fileList,sep="")
  
  texts <- lapply(fullFileNames, readLines)
  nTexts <- sapply(texts,function(t)length(t))
  nDocs <- length(nTexts)
  docNames <- fileList
}

for(i in 1:NFOLD){
  testSelect <- lapply(nTexts,function(n) {runif(n)<1/NFOLD } )
  testTexts <- lapply(1:length(testSelect),function(i) texts[[i]][testSelect[[i]]])
  trainTexts <- lapply(1:length(testSelect),function(i) texts[[i]][!(testSelect[[i]])])
  
  # sample the training set for this run
  ntTexts <- sapply(trainTexts,function(t)length(t))
  ntDocs <- length(nTexts)
  
  # use all the test samples
  removeFiles(dirTempName)
  writeSamples(testTexts,dirTempName)
  dCorpus <- Corpus(DirSource(dirTempName))
  testTokens <- lapply(1:ntDocs,
                       function(t) lapply(2:NMAX, 
                                          function(i) getTokens(i,t)
                       )
  )

  testNgrams <- foreach(b=iter(testTokens),.combine="rbind") %do% {
    foreach(c=iter(b),.combine="rbind") %do% c
  }
  testNgrams <- testNgrams[-which(testNgrams$doc==0),]
  
  testNgrams$pref <- exPrefix(testNgrams$tokens)
  testNgrams$suff <- exSuffix(testNgrams$tokens)
  
  for(j in 1:length(sampleSizes)){
    set.seed(1340)
    sampTexts <- lapply(1:length(trainTexts),function(i){
      texts[[i]][sample(1:ntTexts[i], sampleSizes[j] * ntTexts[i])]
    })
    removeFiles(dirTempName)
    writeSamples(sampTexts,dirTempName)
    
    dCorpus <- Corpus(DirSource(dirTempName))
        
    tokens <- lapply(1:ntDocs,
                     function(t) lapply(2:NMAX, 
                                        function(i) getTokens(i,t)
                     )
    )
    
    Ngrams <- foreach(b=iter(tokens),.combine="rbind") %do% {
      foreach(c=iter(b),.combine="rbind") %do% c
    }
    
    Ngrams$pref <- unlist(exPrefix(Ngrams$tokens))
    Ngrams$suff <- unlist(exSuffix(Ngrams$tokens))
    
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
    
    # for each testNgram, is suff in predict(pref)
    predictFromTextFold <- predictor(sNDS)
    for (k in  1: dim(testNgrams)[1]) {
      perf[i,j] <- perf[i,j] + inOut(testNgrams[k,])*1
    }
    perf[i,j] <- perf[i,j]/dim(testNgrams)[1]
  }
  
  
  
  
}