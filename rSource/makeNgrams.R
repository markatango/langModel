
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


subber <- function(n){
  function(df) df[1:min(n,dim(df)[1]),]
}

#==========================  START ================================

echoSource("N_gram_tokenizer.R")
stopExists <- stopExistsMod("makeNgrams.R")

stopExists("dCorpus")
stopExists("nDocs")

# This method manages memory during tokenization to handle the most data
# one document is tokenized at one 'n' level each pass.
# intermediate data is removed
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

# reshape and add totals
sNDS <-melt(sNDS,id=c("pref","suff","N","doc"),measure="count")
sNDS <- dcast(sNDS,pref+suff+N~doc,sum)
sNDS$total <- rowSums(sNDS[,c(as.character(1:nDocs))], na.rm=TRUE)

# decrease size of dataset since we only need to predict and graph the top few of each prefix
sNDS <- sNDS[order(sNDS$pref, -sNDS$total),]
sub10 <- subber(10)
sNDS <- ddply(sNDS, .(pref), sub10)

save(sNDS,file="shortNDS.RData")

