# WARNING - Generated by {fusen} from dev/csv_download.Rmd: do not edit by hand

#' Schedule automatic downloads of CSVs
#' 
#' @description
#'
#' `download_csv_schedule()` is used to make download task.
#' 
#' @param taskname A character string with the name of the task. Defaults to the filename. Should not contain any spaces.
#' @param schedule Either one of 'ONCE', 'MONTHLY', 'WEEKLY', 'DAILY', 'HOURLY', 'MINUTE', 'ONLOGON', 'ONIDLE.
#' @param starttime A time point in HH:mm format indicating when to run the script. Defaults to within 62 seconds.
#' @param startdate A date that specifies the first date on which to run the task. Only applicable if schedule is of type 'MONTHLY', 'WEEKLY', 'DAILY', 'HOURLY', 'MINUTE'. Defaults to today in '%d/%m/%Y' format. Change to your locale format if needed.
#' @param rscript_args Character string with further arguments passed on to Rscript.
#' @param ... other parameters.
#'
#' @return CSVs in the path of save_path.
#' @export
#' @examples
#' # Make a download task
#' download_csv_schedule(taskname = "ppt_csv_download",
#'                       schedule = "DAILY",
#'                       starttime = "20:00",
#'                       startdate = format(Sys.Date(), "%Y/%m/%d"),
#'                       rscript_args = list(url = Sys.getenv("url"),
#'                                           username = Sys.getenv("username"),
#'                                           password = Sys.getenv("password"),
#'                                           location = c("606","607"),
#'                                           csv_position = "1",
#'                                           download_path = "C:/Users/Dell/Downloads/download_temp"))
#' # Delete download task
#' taskscheduleR::taskscheduler_delete("ppt_csv_download")
#' # Reset selenium webdriver service
#' disconnect_from_browser()

download_csv_schedule <- function(taskname, schedule, starttime, startdate, rscript_args = NULL, ...) {
  if (missing(taskname) || !is.character(taskname) || length(taskname) != 1) {
    stop("taskname must be a single character string")
  }

  if (missing(schedule) || !is.character(schedule) || length(schedule) != 1) {
    stop("schedule must be a single character string")
  }

  if (missing(starttime) || !is.character(starttime) || length(starttime) != 1) {
    stop("starttime must be a single character string")
  }

  if (missing(startdate) || !is.character(startdate) || length(startdate) != 1) {
    stop("startdate must be a single character string")
  }

  if (missing(rscript_args) || !is.list(rscript_args)) {
    stop("rscript_args must be a list of arguments")
  }

  # Save the function to a temporary script file with a shorter path
  short_temp_path <- "C:/Temp"
  dir.create(short_temp_path, showWarnings = FALSE)
  script_file <- file.path(short_temp_path, paste0(taskname, "_", sample(letters, 1), ".R"))

  my_function <- function(...) {
    pptsdd::download_csv_auto(date = Sys.Date()-1, ...)
  }

  # Save the arguments to a configuration file
  config_file <- file.path(short_temp_path, paste0("config_", taskname, ".txt"))
  cat("arg_list <- ", capture.output(dput(rscript_args)), file = config_file)

  write_function_to_script <- function(func, file_path, config_path) {
    func_name <- deparse(substitute(func))
    lines <- capture.output(dump(func_name, stdout()))
    lines <- c(lines, sprintf("source('%s')", config_path))
    lines <- c(lines, sprintf("do.call(%s, arg_list)", func_name))

    if (!file.exists(script_file)) {
      file.create(script_file)
    }

    con <- file(script_file, "w")
    on.exit(close(con), add = TRUE)
    writeLines(lines, con)
  }

  write_function_to_script(func = my_function, file_path = script_file, config_path = config_file)

  # Schedule the task
  taskscheduleR::taskscheduler_create(taskname = taskname,
                                      rscript = script_file, 
                                      schedule = schedule,
                                      starttime = starttime,
                                      startdate = startdate,
                                      rscript_args = NULL,
                                      ...)
}
