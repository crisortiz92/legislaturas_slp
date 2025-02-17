# install and load necessary packages

#install.packages(c('readr', 'ggplot2', 'tidyr', 'RSelenium', 'rvest'))

library(RSelenium)
library(rvest)

# start a remote driver
#driver <- rsDriver(browser = "chrome")
driver <- rsDriver(browser = "firefox", chromever= NULL)
# navigate to the website and scrape the data
initiative_list <- data.frame()
for (page in 0:2) {
    url <- paste0("https://congresosanluis.gob.mx/trabajo/trabajo-legislativo/iniciativas?page=", page)
    remDr <- driver[["client"]]
    remDr$navigate(url)
    page_source <- remDr$getPageSource()
    page_source <- read_html(page_source[[1]])
    tables <- page_source %>%
        html_nodes(xpath = '//table[@class="views-table cols-7"]') %>%
        html_table(header = TRUE, fill = TRUE)
    initiative_list <- rbind(initiative_list, tables[[1]])
}


write.csv(initiative_list, file = "table.csv", row.names = TRUE)
save(initiative_list,file="table.RData")
