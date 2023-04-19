# pptsdd 0.1.1

* Added a `NEWS.md` file to track changes to the package.

# pptsdd 0.1.2

* creat two functions which named `download_free_hands()` and `download_free_brain`.

# pptsdd 0.1.3

* combine two functions in pptsdd 0.1.2 into one function, named `download_csv_auto()`. In this version, improved the function structure, downloading the csv files according data date. You can freely download CSV files according to your ideas, such as downloading one or more pig performance test stations each day, downloading the same pig performance test station or multiple pig performance test stations for multiple dates in `download_csv_auto()`
* creat a new function named `download_csv_schedule()`. You can download csv files of pig performance test stations according to specific time and date.
* add argument checking in every function.
* add a progress bar in `download_csv_schedule()`.
* change the default download folder in `download_csv_auto()`, You can set download folder as you want.
* change the data_date parameter as default parameter `data_date = Sys.Date() -1` in `download_csv_schedule()` 
