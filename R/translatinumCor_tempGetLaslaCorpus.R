

library(readtext)

test <- readtext::readtext('/Users/lucascdz/FILES/atomiclab/corpora/DezottiJD_traducoes/TRADUCOES_LASLA_Corpus/Cicero_InVerremActioPrima_Cic1Ver-FEITO.docx')
test2 <- readLines(textConnection(test$text))
head(test2)
test2 <- test2[which(test2=='sent_id'):length(test2)]

DataFrame <- data.frame(sentids=test2[seq(5,length(test2),by=4)],
                        latintext=test2[seq(7,length(test2),by=4)],
                        translation=test2[seq(8,length(test2),by=4)],
                        stringsAsFactors = F)


