library(pptsdd)

normalize_report_dates <- pptsdd:::normalize_report_dates
report_is_empty <- pptsdd:::report_is_empty
save_report <- pptsdd:::save_report
wait_for_browser_csv <- pptsdd:::wait_for_browser_csv
scheduled_download_script <- pptsdd:::scheduled_download_script

expect_error <- function(expr, message) {
  result <- tryCatch(force(expr), error = identity)
  stopifnot(inherits(result, "error"), grepl(message, conditionMessage(result), fixed = TRUE))
}

local({
  date <- "2024-02-29"
  stopifnot(identical(normalize_report_dates(as.Date(date)), date))
  expect_error(normalize_report_dates(c(date, "2023-02-29")), "valid Date")
  expect_error(normalize_report_dates(c(date, NA_character_)), "valid Date")
  expect_error(normalize_report_dates(character()), "valid Date")
  expect_error(get_csv("unused", "unused", "unused", "606", "607", date, "2024-02-28",
                       tempfile()), "date_min must be on or before date_max")
  expect_error(download_csv_auto("unused", "unused", "unused", "1", "606", "invalid",
                                 tempfile()), "valid Date")

  path <- tempfile()
  dir.create(path)
  on.exit(unlink(path, recursive = TRUE))
  staging <- file.path(path, "staging")
  dir.create(staging)
  old_file <- file.path(path, "unrelated.csv")
  writeLines("keep this file", old_file)

  partial <- file.path(staging, "location606.crdownload")
  writeLines(c("pig,weight", "1,42"), partial)
  expect_error(wait_for_browser_csv(staging, "606", timeout = 0), "Timed out")
  finished <- file.path(staging, "location606_2024-03-01_report.csv")
  stopifnot(file.rename(partial, finished))
  expect_error(wait_for_browser_csv(staging, "607", timeout = 0), "unexpected or ambiguous")
  stopifnot(identical(wait_for_browser_csv(staging, "606", timeout = 0), finished))
  stopifnot(identical(save_report(finished, path, "606", date, download_date = "2024-03-01"), FALSE))

  name <- "location606_2024-02-29data_2024-03-01download.csv"
  stopifnot(file.exists(file.path(path, "NonEmptyCSVs", "606", name)), file.exists(old_file))

  writeLines("pig;weight", finished)
  stopifnot(identical(save_report(finished, path, "606", date, download_date = "2024-03-01"), TRUE))
  stopifnot(file.exists(file.path(path, "EmptyCSVs", "606", name)))

  writeLines(c("pig,weight", '"a', '1",42'), finished)
  stopifnot(identical(report_is_empty(finished), FALSE))
  writeLines(c("pig,weight", '"a,42'), finished)
  expect_error(report_is_empty(finished), "not a valid CSV")
  writeLines("<html><form id='frmLogin'>Login, Password</form></html>", finished)
  expect_error(report_is_empty(finished), "not a valid CSV")
  writeLines(c("pig,weight", "1,42"), finished)
  dir.create(file.path(path, "location606_2024-02-29data_2024-03-01download.csv"))
  expect_error(save_report(finished, path, "606", date, archive = FALSE,
                           download_date = "2024-03-01"), "Cannot move")

  variable <- "PPTSDD_TEST_PASSWORD"
  old_value <- Sys.getenv(variable, unset = NA_character_)
  on.exit({
    if (is.na(old_value)) Sys.unsetenv(variable) else Sys.setenv(PPTSDD_TEST_PASSWORD = old_value)
  }, add = TRUE)
  Sys.setenv(PPTSDD_TEST_PASSWORD = "fake-original-secret")
  args <- list(url = "https://example.invalid/", username = "tester", location = "606",
               download_path = file.path(path, "new", "reports"), password_env = variable,
               password = "fake-original-secret")
  script <- scheduled_download_script("get_csv_auto", args)
  stopifnot(!any(grepl("fake-original-secret", script, fixed = TRUE)),
            !any(grepl("C:/Temp/config", script, fixed = TRUE)))
  args$password <- "different-literal"
  expect_error(scheduled_download_script("get_csv_auto", args), "instead of a literal password")

  steps <- parse(text = script)
  run_env <- new.env()
  Sys.setenv(PPTSDD_TEST_PASSWORD = "fake-rotated-secret")
  for (step in head(steps, -1L)) eval(step, envir = run_env)
  stopifnot(identical(run_env$arg_list$password, "fake-rotated-secret"),
            identical(run_env$arg_list$date, Sys.Date() - 1L))
  Sys.unsetenv(variable)
  expect_error({
    for (step in head(steps, -1L)) eval(step, envir = run_env)
  }, "Set the password environment variable")
})

local({
  env <- new.env(parent = asNamespace("pptsdd"))
  for (name in c("download_csv_auto", "open_edge_session")) {
    fn <- get(name, envir = asNamespace("pptsdd"))
    environment(fn) <- env
    env[[name]] <- fn
  }
  path <- tempfile()
  on.exit(unlink(path, recursive = TRUE))
  calls <- list()
  elements <- character()
  staging <- NULL
  env$edge_request <- function(route, body = NULL, method = NULL) {
    calls[[length(calls) + 1L]] <<- list(route = route, body = body, method = method)
    if (route == "/session") {
      capabilities <- body$capabilities$alwaysMatch
      stopifnot(identical(capabilities$browserName, "MicrosoftEdge"))
      staging <<- capabilities[["ms:edgeOptions"]]$prefs[["download.default_directory"]]
      return(list(sessionId = "mock-edge-session"))
    }
    if (endsWith(route, "/element")) {
      elements <<- c(elements, body$value)
      return(setNames(list(as.character(length(elements))), "element-6066-11e4-a52e-4f735466cecf"))
    }
    if (endsWith(route, "/click")) {
      id <- as.integer(sub(".*/element/([0-9]+)/click$", "\\1", route))
      if (grepl("reports_download_csv_data", elements[[id]], fixed = TRUE)) {
        writeLines(c("pig,weight", "1,42"), file.path(staging, "location606_2024-03-01_report.csv"))
      }
    }
    invisible(NULL)
  }

  env$download_csv_auto("https://example.invalid", "tester", "fixture-password", "1",
                        "606", "2024-02-29", path, browser = "edge")
  report <- file.path(path, "NonEmptyCSVs", "606", "location606_2024-02-29data_2024-03-01download.csv")
  stopifnot(identical(readLines(report), c("pig,weight", "1,42")),
            identical(tail(calls, 1L)[[1L]]$method, "DELETE"),
            any(vapply(calls, function(call) identical(call$body$text, paste0("606", "\uE007")), logical(1))))

  args <- list(url = "https://example.invalid", username = "tester",
               password_env = "NEDAP_PASSWORD", location = "606", download_path = path,
               csv_position = "1", browser = "edge")
  script <- scheduled_download_script("download_csv_auto", args)
  expressions <- parse(text = script)
  scheduled <- new.env()
  eval(expressions[[1L]], envir = scheduled)
  stopifnot(identical(scheduled$arg_list$browser, "edge"))
})
