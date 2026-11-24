## 通用参数 所有下载函数

| 参数                   | 含义                                  |
|------------------------|---------------------------------------|
| `url`                  | 测定站网站根地址                      |
| `username`、`password` | 网站账号和密码                        |
| `location`             | 站点编号，用字符串：`c("606", "608")` |
| `date`                 | `Date` 或 `"YYYY-MM-DD"`              |
| `download_path`        | 输出文件夹，不存在时自动创建          |

    pak::pkg_install("tony2015116/tidypptsdd")
    library(tidypptsdd)
    # ~/.Renviron 中写入 NEDAP_URL、
    # NEDAP_USERNAME、NEDAP_PASSWORD，再重启 R
    url <- Sys.getenv("NEDAP_URL")
    username <- Sys.getenv("NEDAP_USERNAME")
    password <- Sys.getenv("NEDAP_PASSWORD")
    download_path <- "D:/nedap-csv"

需要 Windows 和 R ≥ 4.1.0。浏览器下载需要 Chrome 或 Edge，以及 wdauto ≥
0.2.0，不再需要 Java。

## [HTTP 下载](https://tony2015116.github.io/tidypptsdd/reference/get_csv.md) 不需要浏览器

**[get_csv](https://tony2015116.github.io/tidypptsdd/reference/get_csv.md)**(url,
username, password, location_min, location_max, date_min, date_max,
download_path, show_message = FALSE)

按站点**范围**和日期**范围**导出一份 CSV，直接保存到 `download_path`。

**[get_csv_auto](https://tony2015116.github.io/tidypptsdd/reference/get_csv_auto.md)**(url,
username, password, location, date, download_path, show_message = FALSE)

**每个站点、每一天**分别保存一份 CSV，归档到 `NonEmptyCSVs/` 或
`EmptyCSVs/`。

    get_csv_auto(
      url, username, password,
      location = c("606", "608"),
      date = seq(as.Date("2024-02-18"),
                 as.Date("2024-02-19"),
                 by = "day"),
      download_path = download_path)

需要的是默认 CSV 报表时，优先用这两个函数。

## [浏览器下载](https://tony2015116.github.io/tidypptsdd/reference/download_csv_auto.md) Chrome 或 Edge

**[connect_to_browser](https://tony2015116.github.io/tidypptsdd/reference/connect_to_browser.md)**(dest_dir,
browser = "chrome")

通过 wdauto 下载驱动并启动 WebDriver 服务。

**[download_csv_auto](https://tony2015116.github.io/tidypptsdd/reference/download_csv_auto.md)**(url,
username, password, csv_position, location, date, download_path, browser
= "chrome")

`csv_position` 是报表在网页 CSV 列表中的位置，用字符串表示（`"1"`）。

    options(wdauto.mirror = "npmmirror")  # 国内
    connect_to_browser("C:/webdriver")
    download_csv_auto(
      url, username, password,
      csv_position = "1",
      location = c("606", "608"),
      date = "2024-02-18",
      download_path = download_path)

**[disconnect_from_browser](https://tony2015116.github.io/tidypptsdd/reference/disconnect_from_browser.md)**(browser
= "chrome")

停止服务。使用 Edge 时，三个函数都加上 `browser = "edge"`。

## [每日定时下载](https://tony2015116.github.io/tidypptsdd/reference/get_csv_schedule.md) 前一天的数据

**[get_csv_schedule](https://tony2015116.github.io/tidypptsdd/reference/get_csv_schedule.md)**(taskname,
schedule, starttime, startdate, rscript_args = NULL, ...)

**[download_csv_schedule](https://tony2015116.github.io/tidypptsdd/reference/download_csv_schedule.md)**(taskname,
schedule, starttime, startdate, rscript_args = NULL, ...)

创建 Windows 定时任务，每次运行时用 `get_csv_auto()` /
`download_csv_auto()` 下载前一天的数据。

| `rscript_args` | 内容                                           |
|----------------|------------------------------------------------|
| 必填           | `url`、`username`、`location`、`download_path` |
| 密码           | `password_env = "NEDAP_PASSWORD"`，填变量名    |
| 仅浏览器       | `csv_position`；可选 `browser`                 |

    get_csv_schedule(
      taskname = "nedap_csv_daily",
      schedule = "DAILY",
      starttime = "20:00",
      startdate = format(Sys.Date() + 1,
                         "%Y/%m/%d"),
      rscript_args = list(
        url = url, username = username,
        password_env = "NEDAP_PASSWORD",
        location = c("606", "608"),
        download_path = download_path))

- `startdate` 按 Windows 地区设置的日期格式填写
- 任务脚本和日志：`C:/Temp/tidypptsdd/`

&nbsp;

    # 删除任务
    taskscheduleR::taskscheduler_delete(
      "nedap_csv_daily")

## 输出文件 每站每天一份

    download_path/
      NonEmptyCSVs/606/*.csv  # 有数据行
      EmptyCSVs/608/*.csv     # 只有表头

文件名包含报表日期和下载日期：`location606_2024-02-18data_2024-02-20download.csv`。

`get_csv()` 的单份报表直接保存在 `download_path` 下。

## 排查问题

| 现象 | 检查 |
|----|----|
| 登录失败 / 返回的不是 CSV | 根地址、账号和报表权限；在浏览器中手动导出同一份报表试试 |
| CSV 被归到 `EmptyCSVs` | 该站点当天在网页中是否有数据 |
| 浏览器下载超时 | 浏览器、对应的 WebDriver 服务、`csv_position` |
| 手动成功，定时任务失败 | 任务账户能否读取密码变量、写入输出目录；查看任务日志 |

## [从 pptsdd 升级](https://tony2015116.github.io/tidypptsdd/news/index.md) 0.1.8 起改名

- 函数名和参数都不变：改用 `library(tidypptsdd)` 和 `tidypptsdd::`
- 旧版创建的定时任务调用的是 `pptsdd::`，需要重新创建，再删除旧任务
- 最后 `remove.packages("pptsdd")`
