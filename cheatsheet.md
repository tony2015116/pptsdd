## Common arguments all download functions

| Argument               | Meaning                                       |
|------------------------|-----------------------------------------------|
| `url`                  | Root address of the station website           |
| `username`, `password` | Website account                               |
| `location`             | Station numbers as strings: `c("606", "608")` |
| `date`                 | `Date` values or `"YYYY-MM-DD"`               |
| `download_path`        | Output folder; created when missing           |

    pak::pkg_install("tony2015116/tidypptsdd")
    library(tidypptsdd)
    # ~/.Renviron: NEDAP_URL, NEDAP_USERNAME,
    # NEDAP_PASSWORD; restart R afterwards
    url <- Sys.getenv("NEDAP_URL")
    username <- Sys.getenv("NEDAP_USERNAME")
    password <- Sys.getenv("NEDAP_PASSWORD")
    download_path <- "D:/nedap-csv"

Windows and R ≥ 4.1.0. Browser downloads need Chrome or Edge and wdauto
≥ 0.2.0; Java is not needed.

## [HTTP downloads](https://tony2015116.github.io/tidypptsdd/reference/get_csv.md) no browser

**[get_csv](https://tony2015116.github.io/tidypptsdd/reference/get_csv.md)**(url,
username, password, location_min, location_max, date_min, date_max,
download_path, show_message = FALSE)

One CSV for a **range** of stations and dates, saved in `download_path`.

**[get_csv_auto](https://tony2015116.github.io/tidypptsdd/reference/get_csv_auto.md)**(url,
username, password, location, date, download_path, show_message = FALSE)

One CSV **per station and day**, filed into `NonEmptyCSVs/` or
`EmptyCSVs/`.

    get_csv_auto(
      url, username, password,
      location = c("606", "608"),
      date = seq(as.Date("2024-02-18"),
                 as.Date("2024-02-19"),
                 by = "day"),
      download_path = download_path)

Start here when the default CSV export is the report you need.

## [Browser downloads](https://tony2015116.github.io/tidypptsdd/reference/download_csv_auto.md) Chrome or Edge

**[connect_to_browser](https://tony2015116.github.io/tidypptsdd/reference/connect_to_browser.md)**(dest_dir,
browser = "chrome")

Downloads the driver and starts the WebDriver service through wdauto.

**[download_csv_auto](https://tony2015116.github.io/tidypptsdd/reference/download_csv_auto.md)**(url,
username, password, csv_position, location, date, download_path, browser
= "chrome")

`csv_position` is the position of the report in the website's CSV list,
as a string (`"1"`).

    options(wdauto.mirror = "npmmirror")  # China
    connect_to_browser("C:/webdriver")
    download_csv_auto(
      url, username, password,
      csv_position = "1",
      location = c("606", "608"),
      date = "2024-02-18",
      download_path = download_path)

**[disconnect_from_browser](https://tony2015116.github.io/tidypptsdd/reference/disconnect_from_browser.md)**(browser
= "chrome")

Stops the service. For Edge pass `browser = "edge"` to all three
functions.

## [Daily schedule](https://tony2015116.github.io/tidypptsdd/reference/get_csv_schedule.md) yesterday's data

**[get_csv_schedule](https://tony2015116.github.io/tidypptsdd/reference/get_csv_schedule.md)**(taskname,
schedule, starttime, startdate, rscript_args = NULL, ...)

**[download_csv_schedule](https://tony2015116.github.io/tidypptsdd/reference/download_csv_schedule.md)**(taskname,
schedule, starttime, startdate, rscript_args = NULL, ...)

Registers a Windows task that runs `get_csv_auto()` /
`download_csv_auto()` for the previous day.

| `rscript_args` | Content                                              |
|----------------|------------------------------------------------------|
| required       | `url`, `username`, `location`, `download_path`       |
| password       | `password_env = "NEDAP_PASSWORD"`, the variable name |
| browser only   | `csv_position`; optional `browser`                   |

    get_csv_schedule(
      taskname = "nedap_csv_daily",
      schedule = "DAILY",
      starttime = "20:00",
      startdate = format(Sys.Date() + 1,
                         "%Y/%m/%d"),
      rscript_args = list(
        url = url, username = username,
        password_env = "NEDAP_PASSWORD",
        location = c("606", "608"),
        download_path = download_path))

- `startdate` uses the Windows regional date format
- Scripts and logs: `C:/Temp/tidypptsdd/`

&nbsp;

    # delete the task
    taskscheduleR::taskscheduler_delete(
      "nedap_csv_daily")

## Output files one report per station and day

    download_path/
      NonEmptyCSVs/606/*.csv  # with data rows
      EmptyCSVs/608/*.csv     # header only

File names contain the report date and the download date:
`location606_2024-02-18data_2024-02-20download.csv`.

`get_csv()` saves its single report directly in `download_path`.

## Troubleshooting

| Symptom | Check |
|----|----|
| Login fails / not a CSV | Root URL, account, report permissions; export the same report by hand |
| Reports in `EmptyCSVs` | Does the station have data that day? |
| Browser timeout | Browser, its WebDriver service, `csv_position` |
| Fails only as a task | Task account can read the password variable and write the folder; task log |

## [From pptsdd](https://tony2015116.github.io/tidypptsdd/news/index.md) renamed in 0.1.8

- Function names and arguments are unchanged: use `library(tidypptsdd)`
  and `tidypptsdd::`
- Tasks created by pptsdd call `pptsdd::`; create them again, then
  delete the old tasks
- Then `remove.packages("pptsdd")`
