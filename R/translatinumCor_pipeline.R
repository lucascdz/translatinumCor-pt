library(tidyverse)
library(antiword)

## ARGUMENTS 1
conlluFile <- '../../FILES/atomiclab/corpora/UD_Latin-PROIEL/Cicero_Epistulae_ad_Atticum.conllu'
corpusname <- 'proiel'
docfile <- './data/0_translations/Cic-b06-Ad Att-LIBER VI (feito).doc'
mdfile <- './data/0_translations/Cic-b06-Ad Att-LIBER VI (feito).doc.md'
translator <- 'José Dejalma Dezotti'

## FUNCTIONS
source('./R/translatinumCor_functions.R')

## GET sentences already aligned
#TranslatinumCorDF <- read.delim2('./translatinumCor-pt_v.1.0.tsv')
#TranslatinumCorDF$translator <- 'José Dejalma Dezotti'
#TranslatinumCorDF$sameLatinText <- T
#TranslatinumCorDF$sameLatinText[TranslatinumCorDF$DIFF!=''] <- F
#TranslatinumCorDF <- TranslatinumCorDF[,colnames(TranslatinumCorDF)!='DIFF']
#colnames(TranslatinumCorDF)[1:2] <- c('sentence_id','translation')
#TranslatinumCorDF$sentence_id <- gsub('proiel_','',TranslatinumCorDF$sentence_id)
#write_tsv(TranslatinumCorDF,'./translatinumCor-pt_v.1.1.tsv')
TranslatinumCorDF <- read.delim2('./translatinumCor-pt_v.1.1.tsv')

## GET sentence metadata
# NB: needs 'SentMetadata_corpusname.tsv' in data folder
SentMetadataDF <- GetSentenceMetadata(corpusname)
SentMetadataNewDF <- SentMetadataDF[!SentMetadataDF$sentence_id %in% TranslatinumCorDF$sentence_id,]

## ARGUMENTS 2
unique(SentMetadataDF$filename)
filename <- 'Cic_Att_proiel'
table(gsub('(\\w+\\.[\\w+\\.]?\\d+).*','\\1',SentMetadataNewDF$ref[SentMetadataNewDF$filename==filename]))
refstring <- 'Cic.Att.6'

## GET sentences from conllu file
SentencesDF <- GetSentencesFromConllu(conlluFile,corpusname,refstring,SentMetadataDF)

## GET translations from doc file
TextTranslationDF <- GetTranslationsFromMD(mdfile,corpusname,refstring,translator)

########################################
#   DO TRANSLATION ALIGNMENT MANUALLY  #
# sentences + align2check = align4diff #
########################################

alignedfile <- paste0('./data/2_align4diff/',gsub('\\.','_',refstring),'_',corpusname,'_align4diff.tsv')

## GET final alignment
CheckTranslationDF <- CheckTranslationDiff(alignedfile,refstring,corpusname)


