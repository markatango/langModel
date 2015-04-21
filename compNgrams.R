# compress NgramDocStats
# compute overall statistics, then subset to 15 max for every entry

# split on prefix
# compute status
# subset top 15
# re-combine 

# dcast supplies a set of prefixes and freqencies and totals to a function that computes probabilities

mNGDS <- melt(NgramDocStats, id.vars=c("pref"), measure.vars=c("suff","1","2","3","total"))
dNGDS <- dcast(mNGDS,pref~1+2+3,summarize,
            d
               