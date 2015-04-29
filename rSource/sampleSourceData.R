stopExists <- stopExistsMod("sampleSourceData.R")
stopExists("texts")

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
  nDocs <- length(dCorpus)
  nTexts <- sapply(lapply(dCorpus,content),length)
  save.image()
}

