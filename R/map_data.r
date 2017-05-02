library(tm)
library(wordcloud)
library(qdap)
library(topicmodels)
library(dplyr)
library(Rgraphviz)
library(yaml)
library(readr)
library(magrittr)
library(wesanderson)
library(ggplot2)
library(cluster)
library(fpc)
library(tidytext)


x <- revslist_bynab %>% group_by(ntaname) 
x_1 <- split(x, x$ntacode)

list2env(x_1,envir=.GlobalEnv)

doc_sum <- Corpus(VectorSource(listings$summary)) %>%
  tm_map(removePunctuation) %>% tm_map(removeNumbers) %>% tm_map(tolower) %>%
  tm_map(removeWords, stopwords("english")) %>% tm_map(PlainTextDocument) 



listtest <- lapply(x_1, droplevels.data.frame)
wordALL <- lapply(listtest, "[[", "summary")
corpus <- Corpus(VectorSource(wordALL), readerControl = list(language = "en")) 
wordALLrevs <- lapply(listtest, "[[", "comments")
corpusrevs <- Corpus(VectorSource(wordALLrevs), readerControl = list(language = "en")) 


docsum <- corpus %>% tm_map(removePunctuation) %>% tm_map(removeNumbers) %>% tm_map(tolower) %>%
  tm_map(removeWords, stopwords("english")) %>% tm_map(PlainTextDocument) 

docsumrevs <- corpusrevs %>% tm_map(removePunctuation) %>% tm_map(removeNumbers) %>% tm_map(tolower) %>%
  tm_map(removeWords, stopwords("english")) %>% tm_map(PlainTextDocument) 



tdm_sum<- docsum%>% TermDocumentMatrix()

tidy_tx <- tidy(docsumrevs)
tidy_tx$text

tidy_tdm <- cast_tdm(tidy_tx$text)

library(quanteda)
corpus1 <- VCorpus(VectorSource(wordALL), readerControl = list(language = "en")) 

docsum1 <- corpus1 %>% tm_map(removePunctuation) %>% tm_map(removeNumbers) %>% tm_map(tolower) %>%
  tm_map(removeWords, stopwords("english")) %>% tm_map(PlainTextDocument) 

d <- quanteda::dfm(docsum1)





orignrevs <- revslist_bynab %>%
  group_by(ntaname)


text_revs <- revslist_bynab %>% unnest_tokens(word, comments)

data("stop_words")

stop_words
cleaned_revs <- anti_join(text_revs, stop_words, by = c("word" = "word"))

count_words <- cleaned_revs %>% group_by(ntacode) %>% summarise(n = n())


topwords <- cleaned_revs %>% group_by(ntaname) %>% count(words, sort = TRUE)

hipsterrevs_words <- topwords[grep("hipster", topwords$words), ]

historicrevs_words <- topwords[grep("historic", topwords$words), ]

diverserevs_words <- topwords[grep("diverse", topwords$words), ]
cozyrevs_words <- topwords[grep("cozy", topwords$words), ]
modernevs_words <- topwords[grep("modern", topwords$words), ]
affordablerevs_words <- topwords[grep("affordable", topwords$words), ]
luxuryrevs_words <- topwords[grep("luxury", topwords$words), ]
busyrevs_words <- topwords[grep("busy", topwords$words), ]
quietrevs_words <- topwords[grep("quiet", topwords$words), ]
barrevs_words <- topwords[grep("bar", topwords$words), ]
parkrevs_words <- topwords[grep("park", topwords$words), ]


hipster <- hipsterrevs_words %>% group_by(ntaname) %>% summarise(hipsterfreq = sum(n))
historic <- historicrevs_words %>% group_by(ntaname) %>% summarise(historicfreq = sum(n))
diverse <- diverserevs_words %>% group_by(ntaname) %>% summarise(diversefreq = sum(n))
cozy <- cozyrevs_words %>% group_by(ntaname) %>% summarise(cozyfreq = sum(n))
modern <- modernevs_words%>% group_by(ntaname) %>% summarise(modernfreq = sum(n))
affordable <- affordablerevs_words%>% group_by(ntaname) %>% summarise(affordablefreq = sum(n))
luxury <- luxuryrevs_words %>% group_by(ntaname) %>% summarise(luxuryfreq = sum(n))
busy <- busyrevs_words %>% group_by(ntaname) %>% summarise(busyfreq = sum(n))
quiet <-  quietrevs_words %>% group_by(ntaname) %>% summarise(quietfreq = sum(n))
bar <- barrevs_words %>% group_by(ntaname) %>% summarise(barfreq = sum(n))
park <- parkrevs_words%>% group_by(ntaname) %>% summarise(parkfreq = sum(n))


nta_join1 <- nta %>% left_join(hipster, by = "ntaname") %>% left_join(historic, by = "ntaname") %>% left_join(diverse, by = "ntaname") %>%
  left_join(cozy, by = "ntaname") %>% left_join(modern, by = "ntaname") %>% left_join(affordable, by = "ntaname") %>% left_join(luxury, by = "ntaname") %>%
  left_join(busy, by = "ntaname") %>% left_join(quiet, by = "ntaname") %>% left_join(bar, by = "ntaname") %>% left_join(park, by = "ntaname")


nta_join2[is.na(nta_join2)] <- 0

nta_join1 <- nta_join1 %>% select(ntacode, county_fips, ntaname, hipsterfreq, historicfreq, diversefreq, 
                                  cozyfreq, modernfreq, affordablefreq, luxuryfreq, busyfreq, quietfreq, barfreq, parkfreq)

write.csv(nta_join2, "nta_join2.csv")
getwd()


nta_join2 <- left_join(nta_join1, count_words, by = "ntacode")


nta_join2$hipsterfreq <- nta_join2$hipsterfreq/nta_join2$n
nta_join2$hipsterfreq <- nta_join2$hipsterfreq*100

nta_join2$historicfreq <- nta_join2$historicfreq/nta_join2$n * 100
nta_join2$diversefreq <- nta_join2$diversefreq/nta_join2$n * 100
nta_join2$cozyfreq <- nta_join2$cozyfreq/nta_join2$n * 100
nta_join2$modernfreq <- nta_join2$modernfreq/nta_join2$n * 100
nta_join2$affordablefreq <- nta_join2$affordablefreq/nta_join2$n * 100
nta_join2$luxuryfreq <- nta_join2$luxuryfreq/nta_join2$n * 100
nta_join2$busyfreq <- nta_join2$busyfreq/nta_join2$n * 100
nta_join2$quietfreq <- nta_join2$quietfreq/nta_join2$n * 100
nta_join2$barfreq <- nta_join2$barfreq/nta_join2$n * 100
nta_join2$parkfreq <- nta_join2$parkfreq/nta_join2$n * 100


