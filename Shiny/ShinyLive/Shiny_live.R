## running app without server

## Set working directory to TidyX to run the below codes
## setwd() command

shinylive::export(
  appdir = "Shiny/ShinyLive/cars",
  destdir = "Shiny/ShinyLive/Apps"
)


## with development version of httpuv, run shinylive app locally
## remotes::install_github("rstudio/httpuv")

httpuv::runStaticServer(dir = "Shiny/ShinyLive/Apps", port = 8888)
