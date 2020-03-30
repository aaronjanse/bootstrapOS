#!/usr/bin/env Rscript

png(file = "loc-stats.png", width=6.25,height=6.25,units="in",res=500)

input <- file('stdin', 'r')
data <- readLines(input)
data <- rev(data)
tmp <- strsplit(data, " ")

loc <- sapply(tmp, function(x) x[1])
loc <- as.numeric(loc)
# loc <- as.matrix(loc)

# loc <- c(loc)
# loc <- matrix(loc, byrow=TRUE)
# cat(loc)
fnames <- sapply(tmp, function(x) x[2])
# cat(fnames)

par(oma=c(0,13,0,0))

barplot(loc, names.arg = fnames, las=1, horiz=TRUE)

# dev.off()
