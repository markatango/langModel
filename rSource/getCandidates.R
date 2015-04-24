
library(foreach)
library(iterators)

getCandidateNgrams <- function(text,ngramSet){
  # Clean search text the same way we cleaned the source documents
  cText <- strTrim(text)
  cText <- tolower(cText)
  cText <- cleanText(cText)
  cText <- removeWords(cText, "badWords.txt")
  cText <- strTrim(cText)

  # count words and separate for back-off process
  bText <- unlist(strsplit(cText,"[[:blank:]]+"))
  bLen <- length(bText)
  
  # only use the last Nmax-1 words
  if (bLen > (NMAX-1)){
    bText <- bText[(bLen-NMAX+2):bLen]
    bLen <- NMAX-1
  }
  
  # tLen is the backoff index
  tLen <- bLen
  
  u <- c()
  
  # back off
  if (tLen>0){
    repeat{
      # shrink search text from the front (add space at end)
      dText <- paste0("^",paste0(bText[(bLen-(tLen-1)):bLen],collapse=' '),collapse=" ")
      dText <- paste0(dText,'$')
      
      # get indices of matches
      u <- intersect(grep(dText , ngramSet$pref),which(ngramSet$suff!=""))
      
      # exit if a match occurs, or if we're down to the last word in the search text
      if(length(u) > 0 | tLen == 1) break
      tLen <- tLen - 1
    }
    
    if (tLen > 0 & length(u)>0){
      # result if at least a bigram is found
      cngramSet <- ngramSet[u,]
      docSums <- colSums(cngramSet[,c(as.character(1:nDocs),"total"),], na.rm=TRUE)
      probs <- foreach(b=iter(1:nDocs),.combine="cbind") %do% data.frame(cngramSet[,as.character(b)]/docSums[b])
      names(probs) <- paste0("p",1:nDocs)
#       probs <- ddply(cngramSet, .(pref), mutate,
#                      p1 = 1/sum(1),
#                      p2 = 2/sum(2),
#                      p3 = 3/sum(3),
#                      pt = total/sum(total))
      cngramSet <- cbind(cngramSet,probs)
      cngramSet$pt <- cngramSet$total/docSums[length(docSums)]

      cngramSet

    } else {
      data.frame()
    }
  } else { 
    data.frame()
  }
}
     
# # #NOT RUN
# text <- "give me some"
# 
# text
# getCandidateNgrams(text,NgramDocStats)
# noText <- 'fasaoer09'
# noText
# isempty(getCandidateNgrams(noText,Ngrams))

# # # ##end NOT RUN
