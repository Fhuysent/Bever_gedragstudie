library(leaflet)

setwd("../Input/csv")
fileNames <- Sys.glob("*.csv")
data <- NULL
for (fileName in fileNames) {
  tmp <- read.csv2(fileName, header=TRUE, sep=,)
  data <- rbind(data,tmp)
}

BeverIcons <- iconList(
  BE1001 = makeIcon("../../images/marker-icon-blue.png",15,15),
  BE1002 = makeIcon("../../images/marker-icon-red.png",15,15),
  BE1004 = makeIcon("../../images/marker-icon-green.png",15,15),
  BE1006 = makeIcon("../../images/marker-icon-orange.png",15,15),
  BE1008 = makeIcon("../../images/marker-icon-yellow.png",15,15),
  BE1003 = makeIcon("../../images/marker-icon-violet.png",15,15))


leaflet(data=data) %>% 
  addTiles() %>%
  addMarkers(~x,~y, icon=~BeverIcons[bever], popup = ~as.character(datum), label = ~paste(as.character(datum), as.character(uur)))
