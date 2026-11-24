# Changelog

## tidypptsdd 0.1.8

- Renamed the package from `pptsdd` to `tidypptsdd`. Function names and
  arguments are unchanged. Scheduled tasks created by `pptsdd` call
  `pptsdd::` and must be created again with `tidypptsdd`.
- Chrome downloads use the W3C WebDriver client through ChromeDriver
  (`wdauto` \>= 0.2.0), so RSelenium and Java are no longer required.
