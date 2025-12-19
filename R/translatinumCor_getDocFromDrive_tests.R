

library(pandoc)
library(tidyverse)

View(pandoc::pandoc_list_formats())

Mateustest <- pandoc_convert('/Users/lucascdz/Downloads/Mateus.doc',from='rtf',to='markdown')
Mateustestx <- gsub('\\a\\a\\a','\\\n',paste(Mateustest,collapse = ' ')) %>%
   gsub('\\a\\a','\\\n',.) %>%
   gsub('\\a','\\\t',.)

Marcustest <- pandoc_convert('/Users/lucascdz/Downloads/Marcus.doc',from='rtf',to='markdown')
Marcustestx <- gsub('\\a\\a\\a','\\\n',paste(Marcustest,collapse = ' ')) %>%
   gsub('\\a\\a','\\\n',.) %>%
   gsub('\\a','\\\t',.)
write(Marcustestx,'~/Downloads/Marcus_pandoc_rtf.txt')

Geliotest <- pandoc_convert('/Users/lucascdz/FILES/atomiclab/corpora/DezottiJD_traducoes/TRADUÇÕES LADO A LADO/A Gellius N-A 05 (feito).doc',from='rtf',to='markdown')
Geliotestx <- gsub('\\a\\a\\a','\\\n',paste(Geliotest,collapse = ' ')) %>%
   gsub('\\a\\a','\\\n',.) %>%
   gsub('\\a','\\\t',.)
Geliotestx <- str_remove(Geliotestx,'^.{10}')
write(Geliotestx,'~/Downloads/Gelio_pandoc_rtf.txt')

Geliotest2 <- pandoc_convert('/Users/lucascdz/FILES/atomiclab/corpora/DezottiJD_traducoes/TRADUÇÕES LADO A LADO/A Gellius N-A 05 (feito).doc',from='rtf',to='markdown')
Geliotest2x <- paste(Geliotest2,collapse = ' ')
Geliotest2xs <- str_split_1(Geliotest2x,'\\a\\a')
Geliotest2df <- data.frame(latintext=gsub('^(.*)\\a(.*)','\\1',Geliotest2xs),
                           translation=gsub('^(.*)\\a(.*)','\\2',Geliotest2xs),
                           translator='JDD',
                           stringsAsFactors = F)

library(antiword)
docfile <- '/Users/lucascdz/FILES/atomiclab/corpora/DezottiJD_traducoes/TRADUÇÕES LADO A LADO/A Gellius N-A 05 (feito).doc'
doctext <- readLines(textConnection(antiword(docfile,format = T)))



## GOOGLE DRIVE
install.packages("/Users/lucascdz/Downloads/googledrive_2.1.1.tar.gz") # downloaded from https://rpkg.net/package/googledrive
library(googledrive)
googledrive::drive_auth()
googledrive::drive_ls(path = 'My Drive')
## errado... usar o Google Apps Script: https://script.google.com/home/projects/1H_1bsIgNe5C1Pz9TIsqdQRkSV0YsVJLL5b2Nxw5uxV0ERG7pMyJTNiXB/edit?hl=pt-br
