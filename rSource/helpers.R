

# Tokenizer <- function(min, max){ # function closure from 'Advanced R', Hadley Wickham
#   function(x) NGramTokenizer(x, Weka_control(min = min, max = max))
# }

# splitGram <- function(x) {
#   s <- unlist(strsplit(x," "))
#   len <- length(s)
#   data.frame(pref=ifelse(len<2,"",paste0(s[1:len-1],collapse="")), suf=s[len], stringsAsFactors=FALSE)
# }
# 
# splitWord <- function(w, pos){
#   pos <- list(pos)
#   ww <- list(w)
#   out <- lapply(unlist(pos),function(p){
#     res <- sapply(unlist(ww),function(x){
#       if(nchar(x) > 1){
#         chars <- unlist(strsplit(x,""))
#         nLets <- length(chars)
#         if(pos < nLets){
#           pref <- paste0(chars[1:p],collapse="")
#           suf <- paste0(chars[(p+1):nLets],collapse="")
#         } else {
#           pref <- x
#           suf <- ""
#         }
#       } else {
#         pref <- x
#         suf <- ""
#       }
#       c(pref=pref, suf=suf)
#      })
#     res
#   })
#   data.frame(out,stringsAsFactors=FALSE)
# }

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



  



