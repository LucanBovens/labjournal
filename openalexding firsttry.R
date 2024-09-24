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


options(openalexR.mailto = "lucan.bovens@home.nl")  #please Please replace with your own emailadress

url <- "https://api.openalex.org/authors?search=Jochem Tolsma"

# based on what you have learned so far, you would probably first try:
jt <- read_html("https://api.openalex.org/authors?search=Jochem+Tolsma") %>%
  html_text2()

substr(jt, 1, 100)

jt_json <- fromJSON("https://api.openalex.org/authors?search=Jochem+Tolsma", simplifyVector = FALSE)
glimpse(jt_json, max.level = 1)

jt_json[["results"]][[1]][["display_name"]]

df_jt <- jt_json %>%
  .$results %>%
  .[[1]] %>%
  discard(is_empty)

df <- oa_fetch(entity = "author", search = "Jochem Tolsma")
fshowdf(df)

df_papers <- oa_fetch(entity = "works", author.id = df$id)
df_papers$author[1]

df <- oa_fetch(entity = "author", search = "Jochem Tolsma")
fshowdf(df)
