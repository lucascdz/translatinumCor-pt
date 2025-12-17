
library(udpipe)
library(tidyverse)

#outputfolder <- '/../../FILES/atomiclab/corpora/UD_Latin-PROIEL/'
#conlluFile <- '/../../FILES/atomiclab/corpora/UD_Latin-PROIEL/Hieronymus_Vulgata.conllu'

GetSentenceMetadata <- function(corpusname){
   SentMetadataDF <- read.delim2(paste0('./data/sentMetadata_',corpusname,'.tsv'))
   SentMetadataDF$sentence_id <- as.character(SentMetadataDF$sentence_id)
   SentMetadataDF$filename <- gsub('\\d+.*','',SentMetadataDF$ref) %>%
      gsub('\\.','_',.) %>%
      gsub('(.*)',paste0('\\1',corpusname),.)
   return(SentMetadataDF)
}

GetSentencesFromConllu <- function(conlluFile,corpusname,refstring,SentMetadataDF){

   conlluDF <- udpipe::udpipe_read_conllu(conlluFile)
   tokensDF <- left_join(conlluDF,SentMetadataDF)
   SentencesDF <- tokensDF[str_detect(tokensDF$ref,refstring),colnames(tokensDF) %in% c('sentence_id','sentence','ref','sent_order')]
   SentencesDF <- SentencesDF[!duplicated(SentencesDF),]

   outputfolder <- './data/0_sentences/'
   system(paste0('mkdir ',outputfolder))
   write_tsv(SentencesDF,paste0(outputfolder,gsub('\\.','_',refstring),'_',corpusname,'_sentences.tsv'))

   return(SentencesDF)

}


GetTranslationsFromDOC <- function(docfile,corpusname,refstring){

   doctext <- readLines(textConnection(antiword(docfile)))
   doctext <- doctext[str_detect(doctext,'^\\|')]
   doctext <- gsub('^\\|','',doctext) %>%
      gsub('\\|$','',.)
   LatinText <- readLines(textConnection(
      paste(gsub('(.*)\\|(.*)','\\1',doctext), collapse = ' ') %>%
         gsub(' +',' ',.) %>%
         gsub('([\\.;:\\?\\!][’”]?[’”]?) ?','\\1\n',.)
   ))
   Translation <- readLines(textConnection(
      paste(gsub('(.*)\\|(.*)','\\2',doctext), collapse = ' ') %>%
         gsub(' +',' ',.) %>%
         gsub('([\\.;:\\?\\!][’”]?[’”]?) ?','\\1\n',.)
   ))

   if(length(LatinText)>length(Translation)){
      Translation <- c(Translation,seq(1,(length(LatinText)-length(Translation))))
   } else {
      LatinText <- c(LatinText,seq(1,(length(Translation)-length(LatinText))))
   }

   TextTranslationDF <- data.frame(latintext=LatinText,
                                   translation=Translation,
                                   stringsAsFactors = F)

   outputfolder <- './data/1_align2check/'
   system(paste0('mkdir ',outputfolder))
   write_tsv(TextTranslationDF,paste0(outputfolder,gsub('\\.','_',refstring),'_',corpusname,'_align2check.tsv'))

   return(TextTranslationDF)
}


GetTranslationsFromMD <- function(mdfile,corpusname,refstring,translator){

   mdtext <- readLines(mdfile)
   mdtext <- mdtext[str_detect(mdtext,'^\\|')]
   mdtext <- gsub('^\\|','',mdtext) %>%
      gsub('\\|$','',.)

   LatinText <- paste(gsub('(.*)\\|(.*)','\\1',mdtext)) %>%
      gsub(' +',' ',.) %>%
      gsub('^ ','',.) %>%
      gsub(' $','',.)

   Translation <- paste(gsub('(.*)\\|(.*)','\\2',mdtext)) %>%
      gsub(' +',' ',.) %>%
      gsub('^ ','',.) %>%
      gsub(' $','',.)

   TextTranslationDF <- data.frame(latintext=LatinText,
                                   translation=Translation,
                                   translator=translator,
                                   stringsAsFactors = F)

   outputfolder <- './data/1_align2check/'
   system(paste0('mkdir ',outputfolder))
   write_tsv(TextTranslationDF,paste0(outputfolder,gsub('\\.','_',refstring),'_',corpusname,'_align2check.tsv'))

   return(TextTranslationDF)
}


CheckTranslationDiff <- function(alignedfile,refstring,corpusname){

   # check translation alignment
   CheckTranslationDF <- read.csv(alignedfile,sep='\t')
   CheckTranslationDF <- CheckTranslationDF[!is.na(CheckTranslationDF$sentence_id),]
   CheckTranslationDF$norm_sentence <- gsub('[^A-ω ]', '', CheckTranslationDF$sentence) %>%
      gsub(' +', ' ', .) %>%
      gsub(' que ', 'que ', .) %>%
      gsub(' c ', 'c ', .) %>%
      gsub('si s ', 'sis ', .) %>%
      gsub("(.*)", "\\L\\1", ., perl = T) %>%
      gsub('j', 'i', .) %>%
      gsub('v', 'u', .) %>%
      gsub('^ ?(.*) ?$','\\1',.)
   CheckTranslationDF$norm_text <- gsub('[^A-ω ]', '', CheckTranslationDF$latintext) %>%
      gsub(' +', ' ', .) %>%
      gsub(' que ', 'que ', .) %>%
      gsub(' c ', 'c ', .) %>%
      gsub('si s ', 'sis ', .) %>%
      gsub("(.*)", "\\L\\1", ., perl = T) %>%
      gsub('j', 'i', .) %>%
      gsub('v', 'u', .) %>%
      gsub('^ ?(.*) ?$','\\1',.)
   CheckTranslationDF$sameEdition <- unlist(lapply(seq_along(CheckTranslationDF[,1]), function(i) CheckTranslationDF$norm_sentence[i]==CheckTranslationDF$norm_text[i]))
   table(CheckTranslationDF$sameEdition)

   outputfolder <- './data/3_diff2check/'
   system(paste0('mkdir ',outputfolder))
   write_tsv(CheckTranslationDF,paste0(outputfolder,gsub('\\.','_',refstring),'_',corpusname,'_diff2check.tsv'))

   return(CheckTranslationDF)

}
