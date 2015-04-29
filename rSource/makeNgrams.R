
exPrefix <- function(tokens){
  sapply(tokens,function(t){
    w <- unlist(strsplit(t," "))
    n <- length(w)
    if (n>1){
      paste0(w[1:(n-1)],collapse=" ")
    } else {
      w
    }
  })
} 

exSuffix <- function(tokens){
  sapply(tokens,function(t){
    w <- unlist(strsplit(t," "))
    n <- length(w)
    if (n>1){
      w[n]
    } else {
      ""
    }
  })
}

subber <- function(min,max){
  function(df) {
    m <- dim(df)[1]
    if(m>=min) {
      df[1:min(max,m),]
    } else {
      data.frame(stringsAsFactors=FALSE)
    }
  }
    
}


#==========================  START ================================

echoSource("N_gram_tokenizer.R")
stopExists <- stopExistsMod("makeNgrams.R")

stopExists("dCorpus")
stopExists("nDocs")

sNDS <- data.frame()
for (i in 2:NMAX) {
   for (t in 1:nDocs) {
     ng <- getTokens(i,t)
     ng <- ng[which(ng$count>FILTERTHRESHOLD),]
     ng$pref <- exPrefix(ng$tokens)
     ng$suff <- exSuffix(ng$tokens)
     ng <- ng[,-which(names(ng)=="tokens")]
     ng <- ng[union(which(ng$suff!=""),which(ng$suff!=" ")),]
     sNDS <- rbind(sNDS,ng)
     rm(ng)
   }
}
sNDS <-melt(sNDS,id=c("pref","suff","N","doc"),measure="count")
sNDS <- dcast(sNDS,pref+suff+N~doc,sum)
sNDS$total <- rowSums(sNDS[,c(as.character(1:nDocs))], na.rm=TRUE)
sNDS <- sNDS[order(sNDS$pref,sNDS$N, -sNDS$total),]

save(sNDS,file="shortNDS.RData")

