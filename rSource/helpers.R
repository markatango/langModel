

# Tokenizer <- function(min, max){ # function closure from 'Advanced R', Hadley Wickham
#   function(x) NGramTokenizer(x, Weka_control(min = min, max = max))
# }

splitGram <- function(x) {
  s <- unlist(strsplit(x," "))
  len <- length(s)
  data.frame(pref=ifelse(len<2,"",paste0(s[1:len-1],collapse="")), suf=s[len], stringsAsFactors=FALSE)
}

splitWord <- function(w, pos){
  pos <- list(pos)
  ww <- list(w)
  out <- lapply(unlist(pos),function(p){
    res <- sapply(unlist(ww),function(x){
      if(nchar(x) > 1){
        chars <- unlist(strsplit(x,""))
        nLets <- length(chars)
        if(pos < nLets){
          pref <- paste0(chars[1:p],collapse="")
          suf <- paste0(chars[(p+1):nLets],collapse="")
        } else {
          pref <- x
          suf <- ""
        }
      } else {
        pref <- x
        suf <- ""
      }
      c(pref=pref, suf=suf)
     })
    res
  })
  data.frame(out,stringsAsFactors=FALSE)
}

# ## Not run:
#   ss <- splitWord(splitWordTest,splitWordPosTest)
#   tester <- "d"
#   tryCatch(ss[tester], error=function(e) {
#     out <- data.frame(x=c("",""))
#     rownames(out) <- c("pref", "suf")
#     colnames(out) <- tester
#     out
#   })
# ## End(Not run)

readAndLower <- function(f,dirName){
  t <- readLines(paste0(dirName,"/",f,collapse=" "),skipNul=TRUE,encoding='latin1')
  t <- iconv(t,from="latin1",to="ASCII",sub="")
  tolower(t)
}

readCleanAndSample <- function(f,dirName) {
  t <- readLines(paste0(dirName,"/",f,collapse=" "),skipNul=TRUE,encoding='latin1')
  t <- iconv(t,from="latin1",to="ASCII",sub="")
  t <- tolower(t)
  t <- cleanText(t)
  t <- removeWords(t, "badWords.txt")
  n <- length(t)
  set.seed(1340)
  t[sample(1:n, SAMPLESIZE * n)]
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
  

inOut <- function(testNgram){
  testNgram$suff %in%  predictFromTextFold(testNgram$pref)$uSAD
}

subber <- function(n){
  function(df) df[1:min(n,dim(df)[1]),]
}

