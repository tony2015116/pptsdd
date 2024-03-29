# pptsdd <a href='https://tony2015116.github.io/pptsdd/'><img src='man/figures/logo.svg'  width="120" align="right" />
<!--apple-touch-icon-120x120.png-->
<!-- <picture><source srcset="reference/figures/apple-touch-icon-120x120.png" media="(prefers-color-scheme: dark)"></picture> -->
<!-- badges: start -->
[![GitHub R package version](https://img.shields.io/github/r-package/v/tony2015116/pptsdd)](#)
[![GitHub last commit](https://img.shields.io/github/last-commit/tony2015116/pptsdd)](#)
<!-- badges: end -->

**pptsdd** is an R package that enables automatic downloading of data from pig performance test stations. The package stands for 'Pig Performance Test Station Data Download'. With pptsdd, managing test station data is made much more efficient, as the package automates the process of downloading data from these stations. This allows for a more streamlined workflow for test station data management personnel.

# Installation
You can install the development version from GitHub with:
``` r
# install.packages("devtools")
devtools::install_github("tony2015116/pptsdd")
# install.packages("pak")
pak::pak("tony2015116/pptsdd")
```

## Example

This is a basic example which shows you how to download pig performance test CSVs data:

``` r
# Install packages
install.packages("httr2")
install.packages("rvest")
install.packages("pak")
pak::pak(tony2015116/wdauto)
pak::pak("tony2015116/pptsdd")

# Require packages
library(pptsdd)

# Set parameters
url = "https://xxxxx.vpu-online.cn/"
username = "pigfarm1"
password = "12345"
csv_pisition = "1" # 1 or 4

location = "607" # one location
location = c("607", "608") # two or more locations
location = purrr::map_chr(seq(607L, 612L, 1L), as.charater) # many sequentially numbered locations

date = "2024-02-18" # one date
date = c("2024-02-18","2024-02-19") # two or more dates
date = seq(as.Date("2024-02-18"), as.Date("2024-02-28"), 1) # many sequentially dates

download_path = "path/of/saving/you/data"

# Selenium Web Scraping
## start selenium webdriver service
connect_to_browser(dest_dir = "path/to/destination/directory")
## download csv data
download_csv_auto(url = Sys.getenv("url"),
                  username = Sys.getenv("username"),
                  password = Sys.getenv("password"),
                  csv_position = "1", # 1 or 4
                  location = c("606","607"), 
                  date = c("2024-02-18","2024-02-19"), 
                  download_path = "C:/Users/Dell/Downloads/download_rename")
## download csv data in a task schedule
download_csv_schedule(taskname = "ppt_csv_download",
                      schedule = "DAILY",
                      starttime = "20:00",
                      startdate = format(Sys.Date(), "%Y/%m/%d"),
                      rscript_args = list(url = Sys.getenv("url"),
                                          username = Sys.getenv("username"),
                                          password = Sys.getenv("password"),
                                          location = c("606","607"),
                                          csv_position = "1",
                                          download_path = "C:/Users/Dell/Downloads/download_rename"))
## reset selenium webdriver
disconnect_from_browser() # if you use download_csv_schedule() make a download task, please don't run this code.
## delete download task
taskscheduleR::taskscheduler_delete(taskname = "ppt_csv_download")

# Direct Web Scraping
## download CSV data for a specific location range or date range.
get_csv(url = Sys.getenv("url"),
        username = Sys.getenv("username"),
        password = Sys.getenv("password"),
        location_min = "406",
        location_max = "407",
        date_min = "2024-02-18",
        date_max = "2024-02-19",
        download_path = "C:/Users/Dell/Downloads/download_rename", 
        show_message = TRUE)
## download CSV data for a specific location or date
get_csv_auto(url = Sys.getenv("url"),
             username = Sys.getenv("username"),
             password = Sys.getenv("password"),
             location = c("607","608"),
             date = c("2024-02-18", "2024-02-19"),
             download_path = "C:/Users/Dell/Downloads/download_rename")
## make a download task
get_csv_schedule(taskname = "ppt_csv_download",
                 schedule = "DAILY",
                 starttime = "20:00",
                 startdate = format(Sys.Date(), "%Y/%m/%d"),
                 rscript_args = list(url = Sys.getenv("url"),
                                     username = Sys.getenv("username"),
                                     password = Sys.getenv("password"),
                                     location = c("606","607"),
                                     download_path = "C:/Users/Dell/Downloads/download_rename"))
## delete download task
taskscheduleR::taskscheduler_delete(taskname = "ppt_csv_download")
## reset selenium webdriver service
disconnect_from_browser()
```
