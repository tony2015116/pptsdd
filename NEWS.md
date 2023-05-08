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
