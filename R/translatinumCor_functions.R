
library(udpipe)
library(tidyverse)

#outputFolder <- '/../../FILES/atomiclab/corpora/UD_Latin-PROIEL/'
#conlluFile <- '/../../FILES/atomiclab/corpora/UD_Latin-PROIEL/Hieronymus_Vulgata.conllu'

GetSentenceMetadata <- function(corpusname){
   SentMetadataDF <- read.delim2(paste0('./data/sentMetadata_',corpusname,'.tsv'))
   SentMetadataDF$sentence_id <- gsub('proiel_','',SentMetadataDF$sent_id)
   SentMetadataDF$filename <- gsub('\\d+.*','',SentMetadataDF$ref) %>%
      gsub('\\.','_',.) %>%
      gsub('(.*)',paste0('\\1',corpusname),.)
   return(SentMetadataDF)
}

GetSentencesFromConllu <- function(conlluFile,corpusname,refstring,SentMetadataDF){

   conlluDF <- udpipe::udpipe_read_conllu(conlluFile)
   tokensDF <- left_join(conlluDF,SentMetadataDF)
   SentencesDF <- tokensDF[str_detect(tokensDF$ref,refstring),colnames(tokensDF) %in% c('sentence_id','sentence','ref')]
   SentencesDF <- SentencesDF[!duplicated(SentencesDF),]

   outputFolder <- './data/sentences/'
   system(paste0('mkdir ',outputFolder))
   write_tsv(SentencesDF,paste0(outputFolder,gsub('\\.','_',refstring),'_sentences.tsv'))

   return(SentencesDF)

}


GetTranslationsFromDOC <- function(docfile,SentencesDF,refstring){

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

   outputfolder <- './data/align2check/'
   system(paste0('mkdir ',outputfolder))
   write_tsv(TextTranslationDF,paste0(outputfolder,gsub('\\.','_',refstring),'_align2check.tsv'))

   return(TextTranslationDF)
}


CheckTranslationDiff <- function(){

   # check translation alignment
   translatedSentencesDF <- read.csv('/Users/lucascdz/FILES/atomiclab/corpora/Proiel_UD/ProielSentTranslationsJDD.tsv',sep='\t')
   translatedSentencesDF$sentence_id <- gsub('proiel_','',translatedSentencesDF$sent_id)

   checkTranslationAlignment <- left_join(VulgataMattDF[,colnames(VulgataMattDF) %in% c('sentence_id','sentence')],translatedSentencesDF)
   checkTranslationAlignment <- checkTranslationAlignment[!duplicated(checkTranslationAlignment),]
   write_tsv(checkTranslationAlignment,paste0(outputFolder,'VulgataMatt_sentences.tsv'))

   translationAlignment_raw <- read.csv('/Users/lucascdz/FILES/atomiclab/corpora/UD_Latin-PROIEL/VulgataMatt_translAlignment_raw.tsv',sep='\t')

   CheckTranslation <- function(Filepath){
      #Filepath <- '/Users/lucascdz/FILES/atomiclab/corpora/UD_Latin-PROIEL/VulgataMatt_translAlignment.tsv'
      CorpusDF <- read.csv(Filepath,sep = '\t')
      CorpusDF$norm_sentence <- gsub('\\d', '', CorpusDF$sentence) %>%
         gsub("(.*)", "\\L\\1", ., perl = T) %>%
         gsub('j', 'i', .) %>%
         gsub('v', 'u', .) %>%
         gsub('[\\.\\,\\?\\!\\:\\;\\)\\(“‘”’]', '', .) %>%
         gsub(' que ', 'que ', .) %>%
         gsub('  ', ' ', .) %>%
         gsub(' $', '', .)
      CorpusDF$norm_text <- gsub('\\d', '', CorpusDF$text) %>%
         gsub("(.*)", "\\L\\1", ., perl = T) %>%
         gsub('j', 'i', .) %>%
         gsub('v', 'u', .) %>%
         gsub('[\\.\\,\\?\\!\\:\\;\\)\\(“‘”’]', '', .) %>%
         gsub(' +',' ',.) %>%
         gsub('^ ','',.) %>%
         gsub(' $','',.)
      CorpusDF$sameText <- unlist(lapply(seq_along(CorpusDF[,1]), function(i) CorpusDF$norm_sentence[i]==CorpusDF$norm_text[i]))
      write_tsv(CorpusDF,gsub('.tsv$', '_diff.tsv', Filepath))
   }
   CheckTranslation('/Users/lucascdz/FILES/atomiclab/corpora/UD_Latin-PROIEL/VulgataMatt_translAlignment.tsv')

}
