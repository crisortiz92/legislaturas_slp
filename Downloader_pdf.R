#install.packages(c('readr', 'ggplot2', 'tidyr', 'RSelenium', 'rvest'))
# Load necessary libraries
library(RSelenium)
library(rvest)

#Check if you have problems
#driver$server$log()
#delete licence

# Define website URL
url <- "http://congresosanluis.gob.mx/trabajo/trabajo-legislativo/iniciativas?page="

# Start Selenium server
#driver <- rsDriver(browser = "chrome")
driver <- rsDriver(browser = "firefox", chromever=NULL)
remDr <- driver[["client"]]

# Loop through all pages and extract PDF download links
for(i in 0:2) {
    # Construct page URL
    page_url <- paste0(url, i)
    
    # Navigate to page
    tryCatch({
        remDr$navigate(page_url)
    }, error = function(e) {
        print(paste0("Error: ", e$message))
        next
    })
    
    # Extract PDF download links
    page_source <- remDr$getPageSource()[[1]]
    page_html <- read_html(page_source)
    pdf_links <- page_html %>% html_nodes("td[class='views-field views-field-nothing'] a") %>% html_attr("href")
    
    # Download PDF files
    for(j in seq_along(pdf_links)) {
        tryCatch({
            download.file(pdf_links[j], destfile = paste0("pdf_", i, "_", j, ".pdf"), mode = "wb")
        }, error = function(e) {
            print(paste0("Error downloading file ", pdf_links[j], ": ", e$message))
        })
    }
}

# Quit Selenium driver
remDr$close()
driver$server$stop()
