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
library(pptsdd)

## start selenium webdriver service
connect_to_browser(dest_dir = "path/to/destination/directory")
## download csv data
download_csv_auto(browser = "chrome", 
                  url = Sys.getenv("web_url"),
                  username = Sys.getenv("user_name"),
                  password = Sys.getenv("user_password"),
                  csv_position = "1", # 1 or 4
                  location = c("606","607"), 
                  data_date = c("2024-02-17","2024-02-18"), 
                  download_path = "C:/Users/Dell/Downloads/download_temp",
                  save_path = "C:/Users/Dell/Downloads/download_rename")
## download csv data in a task schedule
download_csv_schedule(taskname = "ppt_csv_download",
                      schedule = "DAILY",
                      starttime = "20:00",
                      startdate = format(Sys.Date(), "%Y/%m/%d"),
                      rscript_args = list(browser = "chrome", 
                                          url = Sys.getenv("web_url"),
                                          username = Sys.getenv("user_name"),
                                          password = Sys.getenv("user_password"),
                                          location = c("606","607"),
                                          csv_position = "1",
                                          download_path = "C:/Users/Dell/Downloads/download_temp",
                                          save_path = "C:/Users/Dell/Downloads/download_rename"))
## reset selenium webdriver
disconnect_from_browser()
```
