


library(tm)
library(reshape2)
library(ggplot2)
library(slam)
library(pryr)
library(pracma)
library(stringi)


N1 <- Ngrams[which(Ngrams$N==1 & Ngrams$doc==2),]
N2 <- Ngrams[which(Ngrams$N==3 & Ngrams$doc==2),]

labs <- N1[15:1,"pref"]
y <- barplot(N1$count[15:1], horiz=TRUE,col="skyblue",yaxt="n",main="Most frequenct single word prefixes")
text(cex=1, x=-300, y=y, labels=as.character(labs), srt=25, xpd=TRUE, pos=2, col="black")

labs <- N2[15:1,"pref"]
y <- barplot(N2$count[15:1], horiz=TRUE,col="skyblue",yaxt="n",main="Most frequenct bi-gram prefixes")
text(cex=1, x=-2, y=y, labels=as.character(labs), srt=20, xpd=TRUE, pos=2, col="black")

palette(rainbow(NMAX))
g <- ggplot(Ngrams,aes(x=n, y=count))
g <- g+ geom_point(aes(col=as.factor(N)))
g <- g + scale_y_log10(name="Term count")
g <- g + scale_x_continuous(name="Term index")
g <- g + scale_color_discrete(name="N")
g

Ngrams <- Ngrams[order(Ngrams$pref),]
Ngrams$n <- n

source("rSources/getCandidates.R")

text <- "i.e., don't suggest anything to do with the fact that i am not sure what it meant to me. he"

candidates <- getCandidateNgrams(text)


h <- ggplot(candidates,aes())


palette(rainbow(NMAX))
g <- ggplot(Ngrams,aes(x=n,y=count,group=N))
g <- g+geom_point(shape=21,aes(color=factor(N)))+scale_y_continuous(trans="log10") 
g <- g+guides(color=guide_legend("N")) + ggtitle("Distribution of N-gram counts")
g
png("Distribution_of_N-gram_counts.png")
g
dev.off()


h <- ggplot(NgramCounts.df,aes(x=N,y=counts))
h <- h + geom_bar(stat="identity", color="black", fill='deepskyblue',width=0.4)
h <- h + ggtitle("Number of N-grams vs N")
h
png("Number_of_N_grams_vs_N.png")
h
dev.off()
