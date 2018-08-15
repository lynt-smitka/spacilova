# original: Petr Kajzar
#https://blog.root.cz/ehealth-v-cr/jak-je-to-s-tou-mirkou-spacilovou-a-jejimi-60/

# load packages
library(tidyverse)  # data cleaning
library(rvest)      # web crawler

# set basic variables
max.pages <- 42         # number of pages
filmnames <- NULL       # vector of film names
filmratings <- NULL     # vector of film ratings
filmurl <- NULL         # vector of film reviews urls

# go to web and get all 42 pages with links to reviews
for(i in 1:max.pages) {

  # get every page
  page <- paste("https://kultura.zpravy.idnes.cz/recenze-mirky-spacilove.aspx?strana=", i, sep="")
  page.html <- read_html(page)

  # film names

  # ......... find names of films
  tmp.filmnames <- page.html %>%
    html_nodes(".rec-box") %>%
    html_text(trim = TRUE)

  # ......... delete rating from the film name
  tmp.filmnames <- gsub("[[:digit:]]{1,3}[[:blank:]]%[[:blank:]]", "", tmp.filmnames)

  # film ratings

  # ......... find film ratings
  tmp.filmratings <- page.html %>%
    html_nodes(".rating") %>%
    html_text(trim = TRUE)

  # ......... and make them numeric
  tmp.filmratings <- gsub("[[:blank:]]%", "", tmp.filmratings) %>%
    as.numeric()

  # film reviews url
  tmp.filmurl <- page.html %>%
    html_nodes(".art>a") %>%
    html_attr("href")

  # save the results
  filmnames <- c(filmnames, tmp.filmnames)
  filmratings <- c(filmratings, tmp.filmratings)
  filmurl <- c(filmurl, tmp.filmurl)

  # print some info
  print(paste("Page ready:", i))

}

# make data frame
reviews <- data.frame(film   = filmnames,
                      rating = filmratings,
                      url    = filmurl)

# create basic histogram
hist(reviews$rating,
     main   = "Jak hodnotí Mirka Spáčilová",
     xlab   = "Hodnocení filmu (v %)",
     ylab   = "Četnost",
     labels = TRUE)

# write CSV
write.csv(reviews, "reviews.csv",
          row.names    = FALSE,
          fileEncoding = "UTF-8")

## table(reviews$rating)
## summary(reviews$rating)