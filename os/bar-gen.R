input <- file('stdin', 'r')
row <- readLines(input, n=1)
barplot(row, horiz=TRUE)
