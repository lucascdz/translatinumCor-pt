
library(dplyr)
library(stringr)
library(readtext)

currentversion <- './translatinumCor-pt_v.1.1.tsv'
laslanew <- '/Users/lucascdz/FILES/atomiclab/corpora/DezottiJD_traducoes/TRADUCOES_LASLA_Corpus/'
translator <- 'José Dejalma Dezotti'


GetLaslaTranslations <- function(laslanew,filename){

   docx <- readtext::readtext(paste0(laslanew,filename))
   docx_content <- readLines(textConnection(docx$text))

   indices_start <- which(str_detect(docx_content,gsub('.*_(\\w+).docx','\\1',filename)))
   indices_stop <- indices_start-1
   indices_stop <- c(indices_stop[2:length(indices_stop)],length(docx_content))

   contentLIST <- lapply(seq_along(indices_start),
                         function(i) c(docx_content[indices_start[i]:indices_stop[i]]))

   DataFrame <- data.frame(sentence_id=unlist(lapply(seq_along(contentLIST),
                                                     function(i) contentLIST[[i]][1])),
                           #latintext=unlist(lapply(seq_along(contentLIST),
                           #                        function(i) contentLIST[[i]][3])),
                           translation=unlist(lapply(seq_along(contentLIST),
                                                     function(i) contentLIST[[i]][4])),
                           stringsAsFactors = F)

   DataFrame <- DataFrame[!is.na(DataFrame$translation),]

   return(DataFrame)

}

filenames <- dir(laslanew,pattern = '\\.docx$')
NewTranslationsLIST <- lapply(seq_along(filenames), function(i) GetLaslaTranslations(laslanew,filenames[i]))
NewTranslationsDF <- do.call(rbind,NewTranslationsLIST)
NewTranslationsDF$translator <- translator
NewTranslationsDF$sameEdition <- T


## remove old versions of translated sentences
TranslatinumCorDF <- read.delim2(currentversion)
TranslatinumCorDF <- TranslatinumCorDF[!TranslatinumCorDF$sentence_id %in% NewTranslationsDF$sentence_id & TranslatinumCorDF$translator==translator,]
TranslatinumCorDF <- rbind(TranslatinumCorDF,NewTranslationsDF)

TranslatinumCorDF$translation <- gsub('^\\d+\\.?\\s?','',TranslatinumCorDF$translation) %>%
   gsub('^\\d+\\.?\\s?','',.) %>%
   gsub('^\\d+\\.?\\s?','',.)
TranslatinumCorDF$translation <- gsub('^ ','',TranslatinumCorDF$translation)
TranslatinumCorDF <- TranslatinumCorDF[TranslatinumCorDF$translation!='',]
write_tsv(TranslatinumCorDF,'./translatinumCor-pt_v.1.2.tsv')

