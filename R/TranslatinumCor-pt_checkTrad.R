library(tidyverse)

#Filepath <- '/Users/lucascdz/FILES/doutorado/atomiclab/corpora/LASLA/sents_traddiff/LASLA_CicCael.tsv'

CheckTrad <- function(Filepath){
   CorpusDF <- read.csv(Filepath,sep = '\t')
   CorpusDF$norm_text <- gsub('\\d', '', CorpusDF$text) %>%
      gsub("(.*)", "\\L\\1", ., perl = T) %>%
      gsub('j', 'i', .) %>%
      gsub('v', 'u', .) %>%
      gsub('[\\.\\,\\?\\!\\:\\;\\)\\(“‘”’]', '', .) %>%
      gsub(' que ', 'que ', .) %>%
      gsub('  ', ' ', .) %>%
      gsub(' $', '', .)


   CorpusDF$norm_text_JDD <- gsub('\\d', '', CorpusDF$text_JDD) %>%
      gsub("(.*)", "\\L\\1", ., perl = T) %>%
      gsub('j', 'i', .) %>%
      gsub('v', 'u', .) %>%
      gsub('[\\.\\,\\?\\!\\:\\;\\)\\(“‘”’]', '', .)
   CorpusDF$DIFF <- unlist(lapply(seq_along(CorpusDF$text), function(i) identical(CorpusDF$norm_text[i],CorpusDF$norm_text_JDD[i])))
   write_tsv(CorpusDF,gsub('.tsv$', '_diff.tsv', Filepath))
}

CheckTrad('/Users/lucascdz/FILES/doutorado/atomiclab/corpora/Proiel_UD/sents_traddiff/Cicero_de_Officiis-la_proiel-ud-SENTS.tsv')
