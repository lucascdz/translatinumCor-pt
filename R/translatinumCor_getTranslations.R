
GetTranslationFromMD <- function(translationFile){

   TranslationSource <- readLines(translationFile)
   TranslationSource <- TranslationSource[str_detect(TranslationSource,'^\\|')]
   TranslationSource <- gsub('^\\| ','',TranslationSource) %>%
      gsub(' \\|$','',.)
   TranslationSourceText <- paste(gsub('(.*) \\| (.*)','\\1',TranslationSource), collapse = ' ') %>%
      gsub('([\\.;:\\?\\!][’”]?[’”]?)','\\1\n',.)
   TranslationSourceTranslation <- paste(gsub('(.*) \\| (.*)','\\2',TranslationSource), collapse = ' ') %>%
      gsub('([\\.;:\\?\\!][’”]?[’”]?)','\\1\n',.)
   write(TranslationSourceText,paste0(gsub('\\.\\w+$','_sourcetext.txt',translationFile)))
   write(TranslationSourceTranslation,paste0(gsub('\\.\\w+$','_sourcetranslation.txt',translationFile)))

}




