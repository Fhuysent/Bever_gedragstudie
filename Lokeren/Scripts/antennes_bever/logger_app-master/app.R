##### Logger-App #####
######################

required_packages<-c("shiny",
                     "readxl",
                     "writexl",
                     "ggplot2",
                     "leaflet",
                     "rgdal",
                     "DBI",
                     "RSQLite",
                     "shinyjs",
                     "htmltools",
                     "shinycssloaders",
                     "RMySQL",
                     "plotKML",
                     "geosphere",
                     "foreach",
                     "doParallel",
                     "doSNOW",
                     "fasttime",
                     "shinybusy",
                     "DT",
                     "data.table",
                     "plyr",
                     "shinyWidgets",
                     "dplyr"
                     )

# try to load packages and install missing ones
for (package in required_packages) {
    # require tries to load a package, and returns a boolean indicating success
    if (!require(package, character.only = TRUE)) {
        install.packages(package , dependencies = TRUE)
        require(package, character.only = TRUE)
    }
}

#timestamps to be shown with 3 digits
options(digits.secs = 3)
options(shiny.maxRequestSize=400000*1024^2)

ui <- tagList(
  useShinyjs(),
  includeCSS("style.css"),
  includeCSS("tooltip.css"),
  extendShinyjs("script.js",functions=c("mark_valid",
                                        "mark_invalid",
                                        "disableTab",
                                        "enableTab",
                                        "disableButton")),
  add_busy_spinner(spin="circle", height = "30px", width = "30px"),
  navbarPage(id = "navbar", "rteu-logger-app v1.4",
    source("ui/uiTabData.R")$value,
    source("ui/uiTabLive.R")$value,
    source("ui/uiTabFilter.R")$value,
    source("ui/uiTabResults.R")$value,
    source("ui/uiTabBearings.R", encoding = "UTF-8")$value,
    source("ui/uiTabTriangulation.R")$value,
    source("ui/uiTabMap.R")$value,
    source("ui/uiTabSave.R")$value
  )
)

server <- function(input, output, session) {
  ### define reactiveValues to store all data ###
  global <- reactiveValues()

  source("server/srvFunctions.R", local = TRUE)$value
  source("server/srvTabData.R", local = TRUE)$value
  source("server/srvTabLive.R", local = TRUE)$value
  source("server/srvFileIO.R", local = TRUE)$value
  source("server/srvFilters.R", local = TRUE)$value
  source("server/srvTabFilter.R", local = TRUE)$value
  source("server/srvTabResults.R", local = TRUE)$value
  source("server/srvResults.R", local = TRUE)$value
  source("server/srvDoA.R", local = TRUE)$value
  source("server/srvTabBearings.R", local = TRUE)$value
  source("server/srvTabTriangulation.R",local = TRUE)$value
  source("server/srvMapFuncs.R",local=TRUE)$value
  source("server/srvTriangulation.R",local=TRUE)$value
  source("server/srvTabMap.R", local = TRUE)$value

  onStop(function() {
    close_all_dbs()
    if (exists("cl"))
      stopCluster(cl)
  })
}

shinyApp(ui = ui, server = server)
