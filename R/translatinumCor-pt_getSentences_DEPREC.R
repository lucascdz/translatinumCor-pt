library(tidyverse)

#set paths
corporaPath <- '/Users/lucascdz/FILES/atomiclab/corpora/'
targetFolder <- 'DezottiJD_traducoes/'
tradFolder <- 'sents_trad_ok/'
#set folders
CircseLibFolder <-  'CIRCSELatinLibrary/'
LaslaCorpusFolder <- 'LaslaCorpus/'
PerseusLdtFolder <- 'Perseus_LDT2.1/'
ProielUdFolder <- 'Proiel_UD/'

## get filepaths list
CircseLibFilepaths <- dir(paste0(corporaPath,CircseLibFolder,tradFolder)) %>%
   gsub('(.*)',paste0(corporaPath,CircseLibFolder,tradFolder,'\\1'),.)
LaslaCorpusFilepaths <- dir(paste0(corporaPath,LaslaCorpusFolder,tradFolder)) %>%
   gsub('(.*)',paste0(corporaPath,LaslaCorpusFolder,tradFolder,'\\1'),.)
PerseusLdtFilepaths <- dir(paste0(corporaPath,PerseusLdtFolder,tradFolder)) %>%
   gsub('(.*)',paste0(corporaPath,PerseusLdtFolder,tradFolder,'\\1'),.)
ProielUdFilepaths <- dir(paste0(corporaPath,ProielUdFolder,tradFolder)) %>%
   gsub('(.*)',paste0(corporaPath,ProielUdFolder,tradFolder,'\\1'),.)

#### GET CONTENTS ####
# Circse Latin Library
CircseLibList <- lapply(seq_along(CircseLibFilepaths), function(i) read.csv(CircseLibFilepaths[i],sep='\t'))
for (i in seq_along(CircseLibList)){
   CircseLibList[[i]] <- CircseLibList[[i]][,colnames(CircseLibList[[i]]) %in% c('sent_id','translation_JDD','DIFF')]
   if (!'DIFF' %in% colnames(CircseLibList[[i]])){
      CircseLibList[[i]]$DIFF <- NA
   }
}
CircseLibDF <- do.call(rbind,CircseLibList)

# Lasla Corpus
LaslaCorpusList <- lapply(seq_along(LaslaCorpusFilepaths), function(i) read.csv(LaslaCorpusFilepaths[i],sep='\t'))
for (i in seq_along(LaslaCorpusList)){
   LaslaCorpusList[[i]] <- LaslaCorpusList[[i]][,colnames(LaslaCorpusList[[i]]) %in% c('sent_id','translation_JDD','DIFF')]
   if (!'DIFF' %in% colnames(LaslaCorpusList[[i]])){
      LaslaCorpusList[[i]]$DIFF <- NA
   }
}
LaslaCorpusDF <- do.call(rbind,LaslaCorpusList)

# Perseus LDT
PerseusLdtList <- lapply(seq_along(PerseusLdtFilepaths), function(i) read.csv(PerseusLdtFilepaths[i],sep='\t'))
for (i in seq_along(PerseusLdtList)){
   PerseusLdtList[[i]] <- PerseusLdtList[[i]][,colnames(PerseusLdtList[[i]]) %in% c('sent_id','translation_JDD','DIFF')]
   if (!'DIFF' %in% colnames(PerseusLdtList[[i]])){
      PerseusLdtList[[i]]$DIFF <- NA
   }
}
PerseusLdtDF <- do.call(rbind,PerseusLdtList)

# Proiel UD
ProielUdList <- lapply(seq_along(ProielUdFilepaths), function(i) read.csv(ProielUdFilepaths[i],sep='\t'))
for (i in seq_along(ProielUdList)){
   ProielUdList[[i]] <- ProielUdList[[i]][,colnames(ProielUdList[[i]]) %in% c('sent_id','translation_JDD','DIFF')]
   if (!'DIFF' %in% colnames(ProielUdList[[i]])){
      ProielUdList[[i]]$DIFF <- NA
   }
}
ProielUdDF <- do.call(rbind,ProielUdList)
ProielUdDF$sent_id <- gsub('(.*)','proiel_\\1',ProielUdDF$sent_id)

#### GET ALL TRANSLATED SENTENCES ####
translatinumCor_ptDF <- rbind(CircseLibDF,LaslaCorpusDF,PerseusLdtDF,ProielUdDF)
translatinumCor_ptDF[is.na(translatinumCor_ptDF)] <- ''
translatinumCor_ptDF$DIFF[translatinumCor_ptDF$DIFF=='TRUE'] <- ''
translatinumCor_ptDF$DIFF[translatinumCor_ptDF$DIFF!=''] <- '*'
translatinumCor_ptDF <- translatinumCor_ptDF[translatinumCor_ptDF$translation_JDD!='',]
write_tsv(translatinumCor_ptDF,'./data/translatinumCor_pt.tsv')

