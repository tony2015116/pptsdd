# Schedule automatic downloads of CSVs

`get_csv_schedule()` is used to make download task.

## Usage

``` r
get_csv_schedule(
  taskname,
  schedule,
  starttime,
  startdate,
  rscript_args = NULL,
  ...
)
```

## Arguments

- taskname:

  A character string with the name of the task. Should not contain any
  spaces.

- schedule:

  Either one of 'ONCE', 'MONTHLY', 'WEEKLY', 'DAILY', 'HOURLY',
  'MINUTE', 'ONLOGON', 'ONIDLE.

- starttime:

  A time point in HH:MM format indicating when to run the script.

- startdate:

  A date that specifies the first date on which to run the task. Only
  applicable if schedule is of type 'MONTHLY', 'WEEKLY', 'DAILY',
  'HOURLY', 'MINUTE'. Use the Windows task scheduler's date format for
  your locale.

- rscript_args:

  A named list of download arguments. Optionally set password_env to the
  name of the password environment variable (default password). The task
  account must provide the variable when the script runs.

- ...:

  Additional arguments passed to the Windows task scheduler.

## Value

The output of the Windows task registration command.

## Examples

``` r
# Make a download task
get_csv_schedule(taskname = "ppt_csv_download",
                 schedule = "DAILY",
                 starttime = "20:00",
                 startdate = format(Sys.Date(), "%Y/%m/%d"),
                 rscript_args = list(url = Sys.getenv("url"),
                                     username = Sys.getenv("username"),
                                     password_env = "password",
                                     location = c("606","607"),
                                     download_path = "C:/Users/Dell/Downloads/download_rename"))
#> Error: url must be a non-empty character string.
# Delete download task
taskscheduleR::taskscheduler_delete("ppt_csv_download")
#> [1] 1
# Reset selenium webdriver service
disconnect_from_browser()
```
