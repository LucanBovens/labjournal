# start with clean workspace
rm(list = ls())

require(RSelenium)
require(tidyverse)
require(openalexR)
require(jsonlite)
require(xml2)
require(rvest)
require (kableExtra)

fshowdf <- function(x, ...) {
  knitr::kable(x, digits = 2, "html", ...) %>%
    kableExtra::kable_styling(bootstrap_options = c("striped", "hover")) %>%
    kableExtra::scroll_box(width = "100%", height = "300px")
}

?RSelenium
?jsonlite
??openalexR

######

options(openalexR.mailto = "lucan.bovens@home.nl")  #please Please replace with your own emailadress

url <- "https://api.openalex.org/authors?search=J+Tolsma"

# based on what you have learned so far, you would probably first try:
jt <- read_html("https://api.openalex.org/authors?search=J+Tolsma") %>%
  html_text2()

substr(jt, 1, 100)

jt_json <- fromJSON("https://api.openalex.org/authors?search=J+Tolsma", simplifyVector = FALSE)
glimpse(jt_json, max.level = 1)

jt_json[["results"]][[1]][["display_name"]]

df_jt <- jt_json %>%
  .$results %>%
  .[[1]] %>%
  discard(is_empty)

?oa_fetch

df <- oa_fetch(entity = "author", search = "J Tolsma")
fshowdf(df)

df_papers <- oa_fetch(entity = "works", author.id = df$id)
df_papers$author[1]

df_institutions_RU <- oa_fetch(entity = "institutions", search = "Radboud University Nijmegen")
df_institutions_RU[1]

df_institutions_UVA <- oa_fetch(entity = "institutions", search = "University of Amsterdam")
df_institutions_UVA[1]

df_institutions_TWU <- oa_fetch(entity = "institutions", search = "University of Twente")
df_institutions_TWU[1]

df <- oa_fetch(entity = "author", search = "Tom van der Meer")
fshowdf(df)

JTo <- oa_fetch(entity = "author", search = "Jochem Tolsma", affiliations.institution.id = "I145872427")
fshowdf(JTo)

TvdMe <- oa_fetch(entity = "author", search = "Tom van der Meer", affiliations.institution.id = "I94624287")
fshowdf(TvdMe)

MGe <- oa_fetch(entity = "author", search = "Maurice Gesthuizen", affiliations.institution.id = "I145872427")
fshowdf(MGe)

MSa <- oa_fetch(entity = "author", search = "Michael Savelkoul", affiliations.institution.id = "I145872427")
fshowdf(MSa)

authors <- c(JTo, TvdMe, MGe, MSa)
authors

### adjacency matrix

require("igraph")

matrixtes1 <- c(0,0,0,0,
                0,0,0,0,
                0,0,0,0,
                0,0,0,0)

wave1 <- matrix(matrixtes1, nrow = 4, ncol = 4)
wave1

matrixtes2 <- c(0,0,0,0,
                0,0,0,0,
                0,0,0,0,
                0,0,0,0)

wave2 <- matrix(matrixtes2, nrow = 4, ncol = 4)
wave2
row.names(wave2)

matrixtes3 <- c(0,0,0,0,
                0,0,0,0,
                0,0,0,0,
                0,0,0,0)

wave3 <- matrix(matrixtes3, nrow = 4, ncol = 4)
wave3
row.names(wave3)

matrixtes4 <- c(0,0,0,0,
                0,0,0,0,
                0,0,0,0,
                0,0,0,0)

wave4 <- matrix(matrixtes4, nrow = 4, ncol = 4)
wave4
row.names(wave4)

row.names(wave1) <- c(JTo$id, MGe$id, MSa$id, TvdMe$id[1])
colnames(wave1) <- c(JTo$id, MGe$id, MSa$id, TvdMe$id[1])

view(wave1)

################

graph <- graph_from_adjacency_matrix(AM1_empty, mode = c("directed"))
triad_census(graph)


matrix_graph <- triad_census(graph)
matrix_graph