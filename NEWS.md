# pptsdd 0.1.1

* added a `NEWS.md` file to track changes to the package.

# pptsdd 0.1.2

* create two functions which named `download_free_hands()` and `download_free_brain`.

# pptsdd 0.1.3

* combine two functions in pptsdd 0.1.2 into one function, named `download_csv_auto()`. In this version, improved the function structure, downloading the csv files according data date. You can freely download CSV files according to your ideas, such as downloading one or more pig performance test stations each day, downloading the same pig performance test station or multiple pig performance test stations for multiple dates in `download_csv_auto()`
* create a new function named `download_csv_schedule()`. You can download csv files of pig performance test stations according to specific time and date.
* add argument checking in every function.
* add a progress bar in `download_csv_schedule()`.
* change the default download folder in `download_csv_auto()`, You can set download folder as you want.

# pptsdd 0.1.4

* the code structure of `download_csv_auto()` has been refactored to make it more understandable. 
* `connect_to_browser()` function has been added to download Google/Edge browser and selenium drivers , and also can enable auto-start the drivers on boot.
* `disconnect_from_browser()` has been added to remove the selenium and Browser launched by the `connect_to_browser()` function and the auto-start feature.

# pptsdd 0.1.5

* pptsdd v0.1.5 can only be used with the Chrome browser.
* `connect_to_browser()` and `disconnect_from_browser()` has been modified to be based on the [wdauto](https://tony2015116.github.io/wdauto/) package, improving the stability of chromedriver and selenium server downloads.
* `connect_to_browser()` has already removed the download of Edgedriver and selenium server.
* you can initiate and restart the Selenium WebDriver service in the Edge browser using pptsdd V0.1.4. However, you must first download the Edge browser driver.
* create a hexagon sticker for pptsdd website.

# pptsdd 0.1.6
* Add three new functions, `get_csv()`, `get_csv_auto()` and `get_csv_schedule()`.
* You can use the older functions to download csv data, and now, you can also use these three new functions.
* `get_csv()` can download CSV data for a specific location range or date range.
* `get_csv_auto()` can download CSV data for a specific location or date.
* `get_csv_schedule()` can make a download task.
