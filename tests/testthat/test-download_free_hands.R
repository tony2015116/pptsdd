# WARNING - Generated by {fusen} from /dev/flat_full.Rmd: do not edit by hand

user_name = "隆鑫场测定一区"
stations = "101"
download_date = "2023-02-11"
test_that("download_free_hand works", {
  expect_no_error(
    download_free_hands(location = stations, 
                                   data_date = download_date, 
                                   url = Sys.getenv("web_url"),
                                   username = user_name, 
                                   password = Sys.getenv("user_password")), 
                  message = "somethings go wrong")
})
