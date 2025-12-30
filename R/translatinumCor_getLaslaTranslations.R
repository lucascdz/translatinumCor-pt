
library(stringr)
library(readtext)

corpuspath <- '/Users/lucascdz/FILES/atomiclab/corpora/DezottiJD_traducoes/TRADUCOES_LASLA_Corpus/'
#filename <- 'Caesar_BellumCivile_CaesBC2.docx'

GetLaslaTranslations <- function(corpuspath,filename){

   docx <- readtext::readtext(paste0(corpuspath,filename))
   docx_content <- readLines(textConnection(docx$text))

   indices_start <- which(str_detect(docx_content,gsub('.*_(\\w+).docx','\\1',filename)))
   indices_stop <- indices_start-1
   indices_stop <- c(indices_stop[2:length(indices_stop)],length(docx_content))

   contentLIST <- lapply(seq_along(indices_start),
                         function(i) c(docx_content[indices_start[i]:indices_stop[i]]))

   DataFrame <- data.frame(sentids=unlist(lapply(seq_along(contentLIST),
                                                 function(i) contentLIST[[i]][1])),
                           latintext=unlist(lapply(seq_along(contentLIST),
                                                   function(i) contentLIST[[i]][3])),
                           translation=unlist(lapply(seq_along(contentLIST),
                                                     function(i) contentLIST[[i]][4])),
                           stringsAsFactors = F)

   DataFrame <- DataFrame[!is.na(DataFrame$translation),]

   return(DataFrame)

}

filenames <- dir(corpuspath,pattern = '\\.docx$')
contentLIST <- lapply(seq_along(filenames), function(i) GetLaslaTranslations(corpuspath,filenames[i]))

contentDF <- do.call(rbind,testLIST)

