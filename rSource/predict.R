library(caret)
# work owith tokens

# predictFromNgrams <- function(ngramSet){
#   predictFromTextFull <- function(text)
# }

predictFromTextLarge <- function(text){
  candidates <- getCandidateNgrams(text,NgramDocStats)
  if(!isempty(candidates)){
    candidates <- candidates[order(candidates$pt,decreasing=TRUE),]
    n <- min(RPTLEN, length(candidates$suff))
    topOverAllList <- candidates$suff[1:n]
    topDocsList <- lapply(1:nDocs, function(d){
      include <- candidates[paste0("p",d)]>0
      ci <- candidates[include,]
      ci$suff[order(ci[paste0("p",d)], decreasing=TRUE)]
    })
  }
  
  candidates <- if(!isempty(candidates)) { candidates } else { data.frame() }
  topDocsList <- if(!isempty(candidates)){ topDocsList } else { list('','','') }
  
  
  
  topOverAllList <- if(!isempty(candidates)){ topOverAllList } else { '' }
  list(adNgrams=candidates, uSAD=topOverAllList, tdl=topDocsList, totalNumPred=dim(candidates)[1])
}

predictFromTextSmall <- function(text){
  candidates <- getCandidateNgrams(text,sNDS)
  if(!isempty(candidates)){
    candidates <- candidates[order(candidates$pt,decreasing=TRUE),]
    n <- min(RPTLEN, length(candidates$suff))
    topOverAllList <- candidates$suff[1:n]
    topDocsList <- lapply(1:nDocs, function(d){
      include <- candidates[paste0("p",d)]>0
      ci <- candidates[include,]
      ci$suff[order(ci[paste0("p",d)], decreasing=TRUE)]
    })
  }
  
  candidates <- if(!isempty(candidates)) { candidates } else { data.frame() }
  topDocsList <- if(!isempty(candidates)){ topDocsList } else { list('','','') }
  
  
  
  topOverAllList <- if(!isempty(candidates)){ topOverAllList } else { '' }
  list(adNgrams=candidates, uSAD=topOverAllList, tdl=topDocsList, totalNumPred=dim(candidates)[1])
}

predictFromTextd <- function(text){
  if(!exists("sNDS")) load("shortNDS.RData")
  if(!exists("dNDS")) load("predictors.RData")
  dNDS[which(dNDS$pref==text)]
}


mostLikelyNWords <- function(N,stWd){
  temp <- stWd
  v <- c()
  N<-min(N,5)
  for(i in 1:N){
    nw <- predictFromText(temp)
    if(!isempty(nw$adNgrams)){
      nw1 <- nw$uSAD[[sample(1:floor(length(nw$uSAD)/2),1)]]
      v <- c(v,nw1)
      temp <-paste(temp,nw1,collapse=" ")
    } else { break}
  }
  paste(v,collapse=" ")
}


plotTop <- function(inCand){
  if(!isempty(inCand)){
    palette(rainbow(15))
    n <- min(15,dim(inCand)[1])
    c <- inCand[order(inCand$pt,decreasing=TRUE),][1:n,]
    
    # get the document names (round about way)
    cNames <- names(c)
    u <- grep("p\\d",cNames)
    nums <- unlist(strsplit(cNames[u],""))
    u <- grep("\\d+",nums)
    docs <- as.numeric(nums[u])
    docNames <- sapply(docs,function(d)fileList[d])
    
    c.m <- melt(c,id.vars=c("pref","suff"),measure.vars=paste0("p",1:nDocs))
    c.m <- c.m[order(c.m$value),]
    
    g <- ggplot(c.m,aes(x=suff,y=value,group=variable))
    g <- g + geom_bar(stat="identity",aes(fill=factor(variable)), color="black", width=0.3, position="dodge")
    g <- g + scale_fill_discrete(name="Source File",labels=docNames) + coord_flip()
    g
  }
}

plotAll <- function(inCand){
  if(!isempty(inCand)){
    palette(rainbow(15))
    n <- min(15,dim(inCand)[1])
    c <- inCand[order(inCand$pt,decreasing=TRUE),][1:n,]
    g <- ggplot(c,aes(x=factor(suff,levels=as.character(suff),ordered=TRUE),y=pt))
    g <- g + geom_bar(stat="identity",fill="skyblue", color="black", width=0.3)
    g <- g + ggtitle("Top word predictions from all texts")
    g <- g + scale_y_continuous(name=paste('Probability conditioned on prefix:  ','"',c$pref[1],'"',sep=''))
    g <- g + scale_x_discrete(name="Predicted words")
    g <- g + coord_flip()
    g
  }
}

## Tests ###

# text <- "no frog gigantic"
# inCand <- predictFromText(text)
# 
# plotAll(inCand$adNgrams)
# #plotTop(inCand)
# 
# # # getCandidates returns:list of Ngrams)
# texta <- "i.e., don't suggest anything to do with the fact that i am not sure what it meant to me. he"
# 
# text <- "i.e., don't xpietiaone "
# predictFromText(texta)
# 
# mostLikelyNWords(10,texta)
# 
# candidates
# sugsAllDocs
# uSAD
# topThreePerDoc
# topOverAllList


# sapply(1:3, function(i) {  sum(is.na(inCand$tdl[[i]])*1)==0  })





