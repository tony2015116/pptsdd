# Start a browser WebDriver service

`connect_to_browser()` starts the local browser WebDriver service with
wdauto. Chrome uses ChromeDriver directly, so Java is not required.

## Usage

``` r
connect_to_browser(dest_dir, browser = c("chrome", "edge"))
```

## Arguments

- dest_dir:

  Directory for browser drivers.

- browser:

  Browser to start, either `chrome` or `edge`.

## Examples

``` r
connect_to_browser(dest_dir = "C:/Users/Dell/Desktop/test")
```
