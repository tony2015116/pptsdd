# Direct web scraping CSVs

`get_csv_auto` allows you to directly download CSV files from the web.
You can download CSV data for a specific location or date.

## Usage

``` r
get_csv_auto(
  url,
  username,
  password,
  location,
  date,
  download_path,
  show_message = FALSE
)
```

## Arguments

- url:

  A character string specifying the URL to log into.

- username:

  A character string specifying the username for login.

- password:

  A character string specifying the password for login.

- location:

  A character vector of numeric station IDs.

- date:

  A vector of Date values or YYYY-MM-DD strings.

- download_path:

  A character string specifying the path where the downloaded CSV file
  should be saved.

- show_message:

  A logical value. If TRUE, a message will be displayed after the
  download. Default is FALSE.

## Value

CSVs in the path of download_path.

## Examples

``` r
# Download CSV data for a specific location or date
get_csv_auto(url = Sys.getenv("url"),
             username = Sys.getenv("username"),
             password = Sys.getenv("password"),
             location = c("607","608"),
             date = c("2024-02-18", "2024-02-19"),
             download_path = "C:/Users/Dell/Downloads/download_rename")
#> Error: url must be a non-empty character string.
```
