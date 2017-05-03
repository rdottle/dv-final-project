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





########################### LISTINGS ################################################



text_listings <- revslist_bynab %>% unnest_tokens(word, summary)

data("stop_words")

stop_words
cleaned_list <- anti_join(text_listings, stop_words, by = c("word" = "word"))

count_listing_words <- cleaned_list %>% group_by(ntacode) %>% summarise(n = n())

#memory.limit(size = 30000)

top_listing_words <- cleaned_list %>% group_by(ntaname) %>% count(word, sort = TRUE)

hipsterlist_words <- top_listing_words[grep("hipster", top_listing_words$word), ]
historiclist_words <- top_listing_words[grep("historic", top_listing_words$word), ]
diverselist_words <- top_listing_words[grep("diverse", top_listing_words$word), ]

cozylist_words <- top_listing_words[grep("cozy", top_listing_words$word), ]

modernlist_words <- top_listing_words[grep("modern", top_listing_words$word), ]

affordablelist_words <- top_listing_words[grep("affordable", top_listing_words$word), ]

luxurylist_words <- top_listing_words[grep("luxury", top_listing_words$word), ]

busylist_words <- top_listing_words[grep("busy", top_listing_words$word), ]
quietlist_words <- top_listing_words[grep("quiet", top_listing_words$word), ]

barlist_words <- top_listing_words[grep("bar", top_listing_words$word), ]
parklist_words <- top_listing_words[grep("park", top_listing_words$word), ]


hipsterlist <- hipsterlist_words %>% group_by(ntaname) %>% summarise(hipsterfreq = sum(n))

historiclist <- historiclist_words %>% group_by(ntaname) %>% summarise(historicfreq = sum(n))

diverselist <- diverselist_words %>% group_by(ntaname) %>% summarise(diversefreq = sum(n))

cozylist <- cozylist_words %>% group_by(ntaname) %>% summarise(cozyfreq = sum(n))

modernlist <- modernlist_words%>% group_by(ntaname) %>% summarise(modernfreq = sum(n))

affordablelist <- affordablelist_words %>% group_by(ntaname) %>% summarise(affordablefreq = sum(n))

luxurylist <- luxurylist_words %>% group_by(ntaname) %>% summarise(luxuryfreq = sum(n))

busylist <- busylist_words %>% group_by(ntaname) %>% summarise(busyfreq = sum(n))

quietlist <-  quietlist_words %>% group_by(ntaname) %>% summarise(quietfreq = sum(n))

barlist <- barlist_words %>% group_by(ntaname) %>% summarise(barfreq = sum(n))

parklist <- parklist_words %>% group_by(ntaname) %>% summarise(parkfreq = sum(n))


nta_joinlist <- nta %>% left_join(hipsterlist, by = "ntaname") %>% left_join(historiclist, by = "ntaname") %>% left_join(diverselist, by = "ntaname") %>%
  left_join(cozylist, by = "ntaname") %>% left_join(modernlist, by = "ntaname") %>% left_join(affordablelist, by = "ntaname") %>% left_join(luxurylist, by = "ntaname") %>%
  left_join(busylist, by = "ntaname") %>% left_join(quietlist, by = "ntaname") %>% left_join(barlist, by = "ntaname") %>% left_join(parklist, by = "ntaname")



nta_joinlist <- nta_joinlist %>% select(ntacode, county_fips, ntaname, hipsterfreq, historicfreq, diversefreq, 
                                  cozyfreq, modernfreq, affordablefreq, luxuryfreq, busyfreq, quietfreq, barfreq, parkfreq)


nta_joinlist[is.na(nta_joinlist)] <- 0
nta_joinlist <- left_join(nta_joinlist, count_listing_words, by = "ntacode")


nta_joinlist$hipsterlistfreq <- nta_joinlist$hipsterfreq/nta_joinlist$n
nta_joinlist$hipsterlistfreq <- nta_joinlist$hipsterlistfreq*100

nta_joinlist$historiclistfreq <- nta_joinlist$historicfreq/nta_joinlist$n * 100
nta_joinlist$diverselistfreq <- nta_joinlist$diversefreq/nta_joinlist$n * 100

nta_joinlist$cozylistfreq <- nta_joinlist$cozyfreq/nta_joinlist$n * 100
nta_joinlist$modernlistfreq <- nta_joinlist$modernfreq/nta_joinlist$n * 100

nta_joinlist$affordablelistfreq <- nta_joinlist$affordablefreq/nta_joinlist$n * 100
nta_joinlist$luxurylistfreq <- nta_joinlist$luxuryfreq/nta_joinlist$n * 100

nta_joinlist$busylistfreq <- nta_joinlist$busyfreq/nta_joinlist$n * 100
nta_joinlist$quietlistfreq <- nta_joinlist$quietfreq/nta_joinlist$n * 100

nta_joinlist$barlistfreq <- nta_joinlist$barfreq/nta_joinlist$n * 100
nta_joinlist$parklistfreq <- nta_joinlist$parkfreq/nta_joinlist$n * 100

nta_joinlist <- nta_joinlist %>% select(ntacode, county_fips, ntaname, hipsterlistfreq, historiclistfreq, diverselistfreq, 
                                               cozylistfreq, modernlistfreq, affordablelistfreq, luxurylistfreq, busylistfreq, quietlistfreq, barlistfreq, parklistfreq, n)

nta_joinlist[is.na(nta_joinlist)] <- 0


write.csv(nta_rev_list, "nta_updated_reviews_listings.csv")
getwd()


nta_rev_list <- left_join(nta_join_rel2, nta_joinlist, by = "ntacode")
