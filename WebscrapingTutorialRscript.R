######################################### Title: Webscraping in R Author: Bas Hofstra Version:
######################################### 29-07-2021

# start with clean workspace
rm(list = ls())

# install.packages('data.table')
library(data.table)  # mainly for faster data handling
library(tidyverse)  # I assume you already installed this one!
# install.packages('httr') # we don't need this for now require(httr)
#install.packages("xml2")
require(xml2)
#install.packages("rvest")
require(rvest)
#install.packages("devtools")
require(devtools)
# Note we're doing something different here. We're installing a *latest* version directly from
# GitHub This is because the released version of this packages contains some errors!
devtools::install_github("jkeirstead/scholar")

require(scholar)

# define workdirectory, note the double *backslashes* if you're on windows setwd('/yourpathhere)'
setwd("~/Desktop/Map Sociologie/RworkspaceSNA")

# Let's first get the staff page read_html is a function that simply extracts html webpages and
# puts them in xml format

soc_staff <- read_html("https://web.archive.org/web/20230528153336/https://www.ru.nl/sociology/research/staff/")
soc_staff

head(soc_staff)

class(soc_staff)

soc_staff_1 <- read_html("https://web.archive.org/web/20230528153336/https://www.ru.nl/sociology/research/staff/")
soc_staff_1

head(soc_staff_1)

class(soc_staff_1)

# so we need to find WHERE the table is located in the html 'inspect element' in mozilla firefox or
# 'view page source' and you see that everything AFTER /td in the 'body' of the page seems to be
# the table we do need
#soc_staff <- soc_staff %>%
 # rvest::html_nodes("body") %>%
#  xml2::xml_find_all("//td") %>%
 # rvest::html_text()

?rvest
?xml2

?xml_find_all

soc_staff <- soc_staff %>%
  rvest::html_nodes("body") %>%
  rvest::html_elements("td") %>%
  rvest::html_text()

soc_staff

soc_staff_1 <- soc_staff_1 %>%
  rvest::html_nodes("body") %>%
  rvest::html_table()

soc_staff_1  # looks much better!!

class(soc_staff_1)
view(soc_staff_1)

fodd <- function(x) x%%2 != 0
feven <- function(x) x%%2 == 0

nstaf <- length(soc_staff)
nstaf

# Do you understand why we need the nstaf? What it does?
soc_names <- soc_staff[fodd(1:nstaf)]  # in the 1 until 94st number, get the odd elements
head(soc_names)

soc_experts <- soc_staff[feven(1:nstaf)]  # in the 1 until 94st number, get the even elements
head(soc_experts)

soc_df <- data.frame(cbind(soc_names, soc_experts))  # columnbind those and we have a DF for soc staff!
soc_df  # pretty nice!

# inspect again, and remove the rows we don't need (check for yourself to be certain!)

delrows <- which(soc_df$soc_names == "Staff:" | soc_df$soc_names == "PhD:" | soc_df$soc_names == "External PhD:" |
                   soc_df$soc_names == "Guest researchers:" | soc_df$soc_names == "Other researchers:")

soc_df <- soc_df[-delrows, ]

soc_df  # even better

