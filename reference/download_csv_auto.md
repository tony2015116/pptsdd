# Automatically download CSVs

`download_csv_auto()` is downloads CSVs through Chrome or Edge.

## Usage

``` r
download_csv_auto(
  url,
  username,
  password,
  csv_position,
  location,
  date,
  download_path,
  browser = c("chrome", "edge")
)
```

## Arguments

- url:

  The login url of pig performance test station website.

- username:

  The username of pig performance test station website.

- password:

  The password of pig performance test station website.

- csv_position:

  The position of the CSV report in the browser menu, as a numeric
  string.

- location:

  Numeric value in string format.

- date:

  A vector of Date values or YYYY-MM-DD strings.

- download_path:

  The folder of downloading csv files.

- browser:

  Browser to use, either `chrome` or `edge`. Start the same browser
  driver with
  [`connect_to_browser()`](https://tony2015116.github.io/tidypptsdd/reference/connect_to_browser.md).

## Value

Invisibly NULL. Writes CSVs to the download directory.

## Examples

``` r
# Start selenium webdriver service
connect_to_browser(dest_dir = "C:/Users/Dell/Desktop/test")
# Download CSVs
download_csv_auto(url = Sys.getenv("url"), 
                  username = Sys.getenv("username"), 
                  password = Sys.getenv("password"),
                  csv_position = "1",
                  location = c("606","607"), 
                  date = c("2024-02-18","2024-02-19"), 
                  download_path = "C:/Users/Dell/Downloads/download_rename")
#> Error: url must be a non-empty character string.
```
