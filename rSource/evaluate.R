library(caret)

# remove existing corpus and ngram data and tokens to free up memory
rm(dCorpus,Ngrams,NgramDocStats,tokens)
gc()



n <- 1
NFOLD <- 5
samplesSizes <- c(0.2,0.1,0.05,0.025,0.0125)
for(j in sampleSizes){
  for(i in 1:NFOLD){
    
    i <- 1
    j <- 0.00125
    testSelect <- lapply(nTexts,function(n) {runif(n)<1/NFOLD } )
    testTexts <- lapply(1:length(testSelect),function(i) texts[[i]][testSelect[[i]]])
    trainTexts <- lapply(1:length(testSelect),function(i) texts[[i]][!(testSelect[[i]])])
    
    # sample the training set for this run
    dCorpus <- 
      
    
   
    
    tokens <- lapply(1:nDocs,
                     function(t) lapply(1:NMAX, 
                                        function(i) getTokens(i,t)
                     )
    )
    
    Ngrams <- foreach(b=iter(tokens),.combine="rbind") %do% {
      foreach(c=iter(b),.combine="rbind") %do% c
    }
    
    Ngrams$pref <- exPref(Ngrams$tokens)
    Ngrams$suff <- exSuff(Ngrams$tokens)
    
    Ngrams <- Ngrams[,-which(names(Ngrams)=="tokens")]
    Ngrams <- Ngrams[order(Ngrams$count,decreasing=TRUE),]
    Ngrams <- Ngrams[order(Ngrams$N),]
    Ngrams <- Ngrams[order(Ngrams$doc),]
    Ngrams$n <- 1:dim(Ngrams)[1]
    
    NgramDocStats <- dcast(Ngrams, pref+suff~doc,value.var="count",sum)
    NgramDocStats$total <- rowSums(NgramDocStats[,c("1","2","3")], na.rm=TRUE)

   # use all the test samples
    testTokens <- makeTokens(sampleText(testTexts,1))
   
    # prepare the training token set
    trainNgrams <- makeNgramSets(trainTokens)
    testNgrams <- makeNgramSets(testTokens)

   
}