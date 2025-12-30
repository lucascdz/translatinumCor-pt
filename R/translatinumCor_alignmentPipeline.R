library(tidyverse)

## FUNCTIONS
source('./R/translatinumCor_functions.R')

## ARGUMENTS
currentversion <- './translatinumCor-pt_v.1.1.tsv'
conlluFile <- '../../FILES/atomiclab/corpora/UD_Latin-PROIEL/Cicero_De_officiis.conllu'
corpusname <- 'proiel'
mdfile <- './data/0_translations/Cic-b08-Ad Att-LIBER VIII.doc.md'
translator <- 'José Dejalma Dezotti'

## GET sentences already aligned
TranslatinumCorDF <- read.delim2(currentversion)

## GET sentence metadata
# NB: needs 'SentMetadata_corpusname.tsv' in data folder
SentMetadataDF <- GetSentenceMetadata(corpusname)
SentMetadataDF <- SentMetadataDF[!SentMetadataDF$sentence_id %in% TranslatinumCorDF$sentence_id,]

## ARGUMENTS 2
unique(SentMetadataDF$filename)
filename <- 'Cic_Off_proiel'
table(gsub('(\\w+\\.[\\w+\\.]?\\d+).*','\\1',SentMetadataDF$ref[SentMetadataDF$filename==filename]))
refstring <- 'Cic.Off.1'

## GET sentences from conllu file
SentencesDF <- GetSentencesFromConllu(conlluFile,corpusname,refstring,SentMetadataDF)

## GET translations from doc.md file
# NB: for bulk conversion from legacy msword doc to markdown, use this Google Apps Script:
# <https://script.google.com/home/projects/1H_1bsIgNe5C1Pz9TIsqdQRkSV0YsVJLL5b2Nxw5uxV0ERG7pMyJTNiXB/edit>
TextTranslationDF <- GetTranslationsFromMD(mdfile,corpusname,refstring,translator)

########################################
#   DO TRANSLATION ALIGNMENT MANUALLY  #
# sentences + align2check = align4diff #
########################################

alignedfile <- paste0('./data/3_align4diff/',gsub('\\.','_',refstring),'_',corpusname,'_align4diff.tsv')

## GET alignment for checking Latin Text
CheckTranslationDF <- CheckTranslationDiff(alignedfile,refstring,corpusname)



## GET final aligments and clean translation
## NB exclude sentence_ids in TranslatinumCorDF
inputfolder <- './data/5_alignments_ok/'
TranslationsDF <- read.delim2()



#### DUMP ####
#TranslatinumCorDF <- read.delim2('./translatinumCor-pt_v.1.0.tsv')
#TranslatinumCorDF$translator <- 'José Dejalma Dezotti'
#TranslatinumCorDF$sameLatinText <- T
#TranslatinumCorDF$sameLatinText[TranslatinumCorDF$DIFF!=''] <- F
#TranslatinumCorDF <- TranslatinumCorDF[,colnames(TranslatinumCorDF)!='DIFF']
#colnames(TranslatinumCorDF)[1:2] <- c('sentence_id','translation')
#TranslatinumCorDF$sentence_id <- gsub('proiel_','',TranslatinumCorDF$sentence_id)
#write_tsv(TranslatinumCorDF,'./translatinumCor-pt_v.1.1.tsv')
