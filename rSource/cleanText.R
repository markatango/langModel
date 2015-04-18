
DEBUGMODE <- FALSE

cleanText <- function(text){
  
  txt.c.1 <- text
  
  # get rid of emoticons!
  reEmo <- "(:\\)+|:\\(+)"
# emoTest <- c(":))",":(")
# grep(reEmo, emoTest)
  txt.c.1 <- gsub(reEmo, " ", txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")

# ge3t rid of all <> symbols (to be used later as tags)
  reTags <- "[<>]"
# tagTest <- "< money> has >>> t < was considered he > a sp<n>g<<Es"
# gsub(reTags," ",tagTest)
  txt.c.1 <- gsub(reTags," ",txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")

#eliminate any repeated text
  reRepText <- "\\s(\\S+)\\s\\1[[:punct:]| ]"
#   repTextTest <- " He is very very 0 0 0 handsome. we were I'll be very very."
#   repTextTest <- gsub(reRepText," \\1 ",repTextTest)
#   gsub(reRepText," \\1 ",repTextTest)
  txt.c.1 <- gsub(reRepText," \\1 ", txt.c.1)
  # expand contractions
  txt.c.1 <- gsub("'ll"," will",txt.c.1)
  txt.c.1 <- gsub("'d"," would",txt.c.1)
  txt.c.1 <- gsub("'ve"," have",txt.c.1)
  txt.c.1 <- gsub("can't"," can not",txt.c.1)
  txt.c.1 <- gsub("won't"," will not",txt.c.1)
  txt.c.1 <- gsub("shan't"," shall not",txt.c.1)
  txt.c.1 <- gsub("'tis"," it is",txt.c.1)
  txt.c.1 <- gsub("it's"," it is",txt.c.1)
  txt.c.1 <- gsub("n't"," not",txt.c.1)
  txt.c.1 <- gsub("'re"," are",txt.c.1)
  txt.c.1 <- gsub("i'm"," i am",txt.c.1)
  txt.c.1 <- gsub("\\sn'( |[[:punct:]])"," and\\1",txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")

# treat some special cases of abbrevs
  reIE <- "i\\.e\\."
  reEG <- "e\\.g\\."
  reEA <- "(et\\.al\\.)|(etc)"
  txt.c.1 <- gsub(reIE,"that is",txt.c.1)
  txt.c.1 <- gsub(reEG,"for example",txt.c.1)
  txt.c.1 <- gsub(reEA," and others ",txt.c.1)

  
  # eliminate possessives
  rePos <- "(\\S)'s"
# epTest <- c("Mark's ", "Keiko's")
# gsub(rePos,"\\1 ",epTest)
  txt.c.1 <- gsub(rePos, "\\1", txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")
  
  # replace money with <money>
  reM1 <- "(\\$\\s?\\d{1,3}(\\s|\\.\\s|\\n))"
  reM2 <- "(\\$\\s?\\d{1,3}(\\,\\d{3})+(\\s|\\.\\s|\\n))"
  reM3 <- "(\\$\\s?\\d{1,3}(\\,\\d{3})*(\\.\\d{2})?(\\s|\\.\\s|\\n))"
  reMoneyUSD <- paste0(reM1,"|",reM2,"|",reM3)
# moneyTest <- c("$ 5 ","$1.00 ","alpha","2.34 ","$25,004,005,909.25 ","$ 25,250 ","$  ,20 ","$2500,2500 ","$25.23.23.23 ","$25.203 ","$9.00\n")
# #                  1      2        3       4           5                   6         7          8              9            10       11     
# grep(reMoneyUSD,moneyTest,fixed=FALSE)
  txt.c.1 <- gsub(reMoneyUSD," <money> ",txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")

  # replace URLS with <URL> and e-mails with <email>
  reEmail <- "( ([a-zA-Z0-9.-]+@){1}[[:alnum:]]+([.][[:alnum:]]+)+( |[[:punct:]] ))"
  reURL <- "((https?|ftp)://)([a-zA-Z0-9-]+\\.)+[a-zA-Z0-9-]+((/[^ .]+)*(.[[:alpha:]]+)?)?"

  txt.c.1 <- gsub(reURL," <URL> ",txt.c.1)
  txt.c.1 <- gsub(reEmail," <email> ",txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")


  month <- "(([JFMASOND][[:alpha:]]{2,}\\s)|([[:digit:]]{1,2}/))"
  day <- "(([[:digit:]]{1,2},\\s)|([[:digit:]]{1,2}/))"
  year <- "(([[:digit:]]{2,2}\\s)|([[:digit:]]{4,4}\\s))"
  reDate <- paste0(month,day,year)
#   dateTest <- c(" May 8, 1954 "," November 21, 1953 "," xerox2419559 "," 3/15/54 "," 12/23/234 "," 12/13/1954 ", " 2011 ")
#   grep(reDate,dateTest)
  txt.c.1 <- gsub(reDate," <date> ",txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")
  
  shortTime <- "([[:digit:]]{1,2}\\s*([aApP](\\.?)[mM](\\.?)) )"
  normTime <- "([[:digit:]]{1,2}(:[012345][[:digit:]]{1,1}){1,2}([aApP](\\.?)[mM](\\.?))? )"
  milTime <- "([012][[:digit:]][012345][[:digit:]] )"
  reTime <- paste0(normTime,"|",shortTime)
#   timeTest <- c(" 0859 "," 1263 "," 08:53 p.m. "," 12 Am "," 4 "," 6:53 ")
#   grep(reTime,timeTest)
  txt.c.1 <- gsub(reTime," <time> ",txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")

  # change hyphens to spaces
  txt.c.1 <- gsub("[-_]+"," ",txt.c.1 )
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")

# replace remaining numbers  with <number>
  reN1 <- "(\\s?\\d+(\\s|\\.\\s|\\n))"
  reN2 <- "(\\s?\\d+(\\,\\d+)+(\\s|\\.\\s|\\n))"
  reN3 <- "(\\s?\\d+(\\,\\d*)*(\\.\\d*)*(\\s|\\.\\s|\\n))"
  reNumber <- paste0(reN1,"|",reN2,"|",reN3)
#   numberTest <- c(" 5 ","1.00 ","alpha","2.34 ","25,004,005,909.25 "," 25,250 "," ,20 ","2500,2500 ","25.23.23.23 ","25.203 ","9.00\n")                 
#   gsub(reNumber," <number> ",numberTest,fixed=FALSE)
  txt.c.1 <- gsub(reNumber," <number> ",txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")

  # eliminate all remaining numbers 
  txt.c.1 <- gsub("[[:digit:]]"," ",txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")
  
  # Eliminate remaining punctuations that do not end a complete thought
  nonSentTermPunc <- "[][\"/+&$%^=\'@#~{()&}|`,*]"
#  puncTest <- 'She said, " fun#gu@s is <number> t>>>o (n+o!t [\'th=r{e|a;t}i%n`gi^^n/g?\'] ~ [ba&rf]." )an;d $9*'
#  gsub(nonSentTermPunc," +p+ ",puncTest)

  txt.c.1 <- gsub(nonSentTermPunc, " ",txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")

  # eliminate single letters not 'I' or 'a'
  reSL <- "([[:space:]]|[][(.?!:;)])[^IiAa]([[:space:]]|[][(.?!:;)])"
# slTest <- "u I'm in a little m league s."
# gsub(reSL,"\\1\\2 ", slTest)
  txt.c.1 <- gsub(reSL,"\\1\\2 ",txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")


# eliminate single letters not 'I' or 'a' begining a line
  reSL <- "^[^IiAa]([[:space:]]|[][(.?!:;)])"
# slTest <- "u I'm in a little m league s."
# gsub(reSL,"\\1 ", slTest)
  txt.c.1 <- gsub(reSL,"\\1 ",txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")

# elimionate repeated periods abnd things
reRepPun <- "([A-Za-z0-9]*[.?!:-_/\\;@+=~`])[.?!:-_/\\;@+=~`]+"
#   repPunTest <- "OMG!!!!!.. Soawesum::sposnge "
#   gsub(reRepPun," \\1 ",repPunTest)
txt.c.1 <- gsub(reRepPun," \\1 ",txt.c.1)
if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")


  # eliminate repeating thought-ending punctuation
  repPunc <- "([][(.?!:;)]+)\\1"
  repsp <- "[][(.?!:;)] [][(.?!:;)]"
#   repPunctTest <- c(", ", ", ", ". ", "!! ", "??? ", "... ", "...... ", "!!!", "[][][][]]]][[[", "[?]")
#   grep(repPunc,repPunctTest)
#   r <- gsub(repPunc,". ",repPunctTest)
#   show(r)
#   gsub(repsp,".",r)
  txt.c.1 <- gsub(repPunc,". ",txt.c.1)
  txt.c.1 <- gsub(repsp,".",txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")

  # ensure thougth-ending punctuation is tokenized as '.' by putting spaces around it
  reTEP <- "[][(.?!:;)]+"
  txt.c.1 <- gsub(reTEP," . ",txt.c.1)

  # eliminate all punctuation
# puncTest <- 'She said, " fun#gu@s is <> to (n+o!t [\'th=r{e|a;t}i%n`gi^^n/g?\'] ~ [ba&rf]." )an;d $9*'
# gsub("[[:punct:]]"," +p+ ",puncTest)
#  txt.c.1 <- gsub("[[:punct:]]"," ",txt.c.1)

  # eliminate more than one space
  txt.c.1 <- gsub("\\s+"," ",txt.c.1)
  if (DEBUGMODE) writeLines(txt.c.1, "txt.c.1.txt")

# Just sentences, please
    
  txt.c.1 <- iconv(txt.c.1,from="latin1",to="ASCII",sub="")
  txt.c.1 <- unlist(strsplit(txt.c.1, " . ",fixed=TRUE))
  longEnough <- unlist(sapply(txt.c.1,function(s){
    nC <- nchar(s)>0
  }))

  txt.c.1[longEnough]
  
}


