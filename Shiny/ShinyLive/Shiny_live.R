## running app without server

## Set working directory to TidyX to run the below codes
## setwd() command

shinylive::export(
  appdir = "cars",
  destdir = "docs"
)


## with development version of httpuv, run shinylive app locally
## remotes::install_github("rstudio/httpuv")

httpuv::runStaticServer(dir = "docs", port = 8888)
