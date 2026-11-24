# Get started with tidypptsdd

[中文](https://tony2015116.github.io/tidypptsdd/articles/tidypptsdd-zh.html)

tidypptsdd downloads CSV reports from Nedap pig performance test
stations. It can export one report for a range of stations and dates,
save one report per station and day, and download the previous day’s
reports every day on Windows.

| Task | Function | How |
|----|----|----|
| One CSV for a range of stations and dates | [`get_csv()`](https://tony2015116.github.io/tidypptsdd/reference/get_csv.md) | HTTP |
| One CSV per station and day | [`get_csv_auto()`](https://tony2015116.github.io/tidypptsdd/reference/get_csv_auto.md) | HTTP |
| Choose a CSV report from the website menu | [`download_csv_auto()`](https://tony2015116.github.io/tidypptsdd/reference/download_csv_auto.md) | Chrome or Edge |
| Download yesterday’s data every day | [`get_csv_schedule()`](https://tony2015116.github.io/tidypptsdd/reference/get_csv_schedule.md) / [`download_csv_schedule()`](https://tony2015116.github.io/tidypptsdd/reference/download_csv_schedule.md) | Windows Task Scheduler |

Start with
[`get_csv()`](https://tony2015116.github.io/tidypptsdd/reference/get_csv.md)
or
[`get_csv_auto()`](https://tony2015116.github.io/tidypptsdd/reference/get_csv_auto.md)
when HTTP provides the report you need. Use Chrome or Edge when the
report has to be chosen in the website menu.

## Install

tidypptsdd runs on **Windows with R 4.1.0 or newer**. It depends on the
Windows-only `taskscheduleR`, so this also applies to HTTP downloads.
Browser downloads need Google Chrome or Microsoft Edge and
[wdauto](https://github.com/tony2015116/wdauto) 0.2.0 or newer; Java is
not needed.

``` r

install.packages("pak")
pak::pkg_install("tony2015116/tidypptsdd")
```

The package was called `pptsdd` before version 0.1.8. Function names and
arguments are unchanged; replace
[`library(pptsdd)`](https://rdrr.io/r/base/library.html) and `pptsdd::`
with `tidypptsdd`, and create scheduled tasks again (see below).

## Store the account

Run `file.edit(path.expand("~/.Renviron"))` and add the station address
and account. The address is the site’s root URL.

``` text
NEDAP_URL=https://your-site.vpu-online.cn
NEDAP_USERNAME=your_username
NEDAP_PASSWORD="your_password"
```

Restart R, then set up the values used by the examples:

``` r

library(tidypptsdd)

url <- Sys.getenv("NEDAP_URL")
username <- Sys.getenv("NEDAP_USERNAME")
password <- Sys.getenv("NEDAP_PASSWORD")
download_path <- file.path(path.expand("~"), "tidypptsdd-data")

stopifnot(all(nzchar(c(url, username, password))))
```

Replace the station numbers and dates below with ones that have data.

## Download over HTTP

One CSV for stations 606 to 608 and 18 to 19 February 2024:

``` r

get_csv(
  url = url, username = username, password = password,
  location_min = "606", location_max = "608",
  date_min = "2024-02-18", date_max = "2024-02-19",
  download_path = download_path,
  show_message = TRUE
)
```

One CSV per station and day, here four reports. Station numbers are
strings; dates can be `Date` values or `YYYY-MM-DD` strings.

``` r

get_csv_auto(
  url = url, username = username, password = password,
  location = c("606", "608"),
  date = seq(as.Date("2024-02-18"), as.Date("2024-02-19"), by = "day"),
  download_path = download_path,
  show_message = TRUE
)
```

## Download through Chrome or Edge

Start the WebDriver service for the browser, then give the position of
the CSV report in the website’s report list with `csv_position`.

``` r

driver_dir <- "C:/webdriver"
connect_to_browser(dest_dir = driver_dir)

download_csv_auto(
  url = url, username = username, password = password,
  csv_position = "1",
  location = c("606", "608"),
  date = "2024-02-18",
  download_path = download_path
)
```

For Edge, add `browser = "edge"` to both calls. In mainland China, run
`options(wdauto.mirror = "npmmirror")` before
[`connect_to_browser()`](https://tony2015116.github.io/tidypptsdd/reference/connect_to_browser.md)
so the driver is downloaded from a mirror. Stop the service with
[`disconnect_from_browser()`](https://tony2015116.github.io/tidypptsdd/reference/disconnect_from_browser.md)
(Chrome) or `disconnect_from_browser(browser = "edge")`.

## Schedule a daily download

This task runs every day at 20:00, starting tomorrow, and downloads the
previous day’s data. Write `startdate` in the date format of the Windows
regional settings; the example uses year/month/day.

``` r

task_args <- list(
  url = url,
  username = username,
  password_env = "NEDAP_PASSWORD",
  location = c("606", "608"),
  download_path = download_path
)

get_csv_schedule(
  taskname = "nedap_csv_daily",
  schedule = "DAILY",
  starttime = "20:00",
  startdate = format(Sys.Date() + 1L, "%Y/%m/%d"),
  rscript_args = task_args
)
```

- The task reads the password from the environment variable named in
  `password_env` when it runs, so set it for the account that runs the
  task.
- For browser downloads use
  [`download_csv_schedule()`](https://tony2015116.github.io/tidypptsdd/reference/download_csv_schedule.md)
  with `c(task_args, list(csv_position = "1"))`, and add
  `browser = "edge"` for Edge. The WebDriver service must be running.
- Logs are written to `C:/Temp/tidypptsdd/`. Delete the task with
  `taskscheduleR::taskscheduler_delete("nedap_csv_daily")`.

## Results and troubleshooting

Reports are filed by station: `NonEmptyCSVs/<station>/` for reports with
data rows and `EmptyCSVs/<station>/` for reports with only a header.
File names contain the report date and the download date, for example
`location606_2024-02-18data_2024-02-20download.csv`.

| Problem | Check |
|----|----|
| Login fails or the response is not a CSV | The root URL, the account and its report permissions. Export the same report by hand in a browser. |
| Reports land in `EmptyCSVs` | Whether the station has data for that day on the website. |
| Browser downloads time out | The browser, its WebDriver service, and the report at `csv_position`. |
| Works by hand, fails as a task | Whether the task account can read the password variable and write to the folder; the task log. |
