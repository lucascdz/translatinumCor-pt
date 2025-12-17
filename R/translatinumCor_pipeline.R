library(tidyverse)
library(antiword)

## ARGUMENTS 1
conlluFile <- '../../FILES/atomiclab/corpora/UD_Latin-PROIEL/Cicero_Epistulae_ad_Atticum.conllu'
corpusname <- 'proiel'
docfile <- './data/translations/Cic-b06-Ad Att-LIBER VI (feito).doc'

## FUNCTIONS
source('./R/translatinumCor_functions.R')

## GET sentences already aligned
TranslatinumCorDF <- read.delim2('./translatinumCor-pt_v.1.0.tsv')

## GET sentence metadata
# NB: needs 'SentMetadata_corpusname.tsv' in data folder
SentMetadataDF <- GetSentenceMetadata(corpusname)
SentMetadataNewDF <- SentMetadataDF[!SentMetadataDF$sent_id %in% TranslatinumCorDF$sent_id,]

## ARGUMENTS 2
unique(SentMetadataDF$filename)
filename <- 'Cic_Att_proiel'
table(gsub('(\\w+\\.[\\w+\\.]?\\d+).*','\\1',SentMetadataNewDF$ref[SentMetadataNewDF$filename==filename]))
refstring <- 'Cic.Att.6'

## GET sentences from conllu file
SentencesDF <- GetSentencesFromConllu(conlluFile,corpusname,refstring,SentMetadataDF)

## GET translations from doc file
TextTranslationDF <- GetTranslationsFromDOC(docfile,SentencesDF,refstring)

########################################
#  DO TRANSLATION ALIGNMENT MANUALLY   #
# join SentencesDF | TextTranslationDF #
########################################




