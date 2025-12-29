
library(stringr)
library(readtext)

test <- readtext::readtext('/Users/lucascdz/FILES/atomiclab/corpora/DezottiJD_traducoes/TRADUCOES_LASLA_Corpus/Caesar_BellumCivile_CaesBC2.docx')
test2 <- readLines(textConnection(test$text))

filename <- 'Caesar_BellumCivile_CaesBC2.docx'
indices_start <- which(str_detect(test2,gsub('.*_(\\w+).docx','\\1',filename)))
indices_stop <- indices_start-1
indices_stop <- c(indices_stop[2:length(indices_stop)],length(test2))

testLIST <- lapply(seq_along(indices_start),
                   function(i) c(test2[indices_start[i]:indices_stop[i]]))

DataFrame <- data.frame(sentids=unlist(lapply(seq_along(testLIST),
                                              function(i) testLIST[[i]][1])),
                        latintext=unlist(lapply(seq_along(testLIST),
                                                function(i) testLIST[[i]][3])),
                        translation=unlist(lapply(seq_along(testLIST),
                                                  function(i) testLIST[[i]][4])),
                        stringsAsFactors = F)

DataFrame <- DataFrame[!is.na(DataFrame$translation),]
