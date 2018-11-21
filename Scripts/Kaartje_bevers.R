library(leaflet)
library(raster)

setwd("../Input/csv")
fileNames <- Sys.glob("*.csv")
data <- NULL
for (fileName in fileNames) {
  tmp <- read.csv2(fileName, header=TRUE, sep=,)
  data <- rbind(data,tmp)
}

#hieronder a6cee3 vervangen door kleuren
BeverIcons <- iconList(
  BE1002 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|a6cee3&chf=a,s,ee00FFFF",15,15),
  BE1003 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|1f78b4&chf=a,s,ee00FFFF",15,15),
  BE1004 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|b2df8a&chf=a,s,ee00FFFF",15,15),
  BE1005 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|33a02c&chf=a,s,ee00FFFF",15,15),
  BE1006 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|fb9a99&chf=a,s,ee00FFFF",15,15),
  BE1007 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|e31a1c&chf=a,s,ee00FFFF",15,15),
  BE1008 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|fdbf6f&chf=a,s,ee00FFFF",15,15),
  BE1009 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|ff7f00&chf=a,s,ee00FFFF",15,15),
  BE1010 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|cab2d6&chf=a,s,ee00FFFF",15,15),
  BE1011 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|6a3d9a&chf=a,s,ee00FFFF",15,15),
  BE1013 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|ffff99&chf=a,s,ee00FFFF",15,15))

mapdata <- subset(data, bever!="BE1007" & 
                    bever!="BE1011" & 
                    bever!="BE1012" & 
                    bever!="BE1014" & 
                    bever!="BE1015" & 
                    bever!="BE1016")

m <-leaflet(data=mapdata) %>% 
  addTiles() %>%
  addMarkers(~x,~y, icon=~BeverIcons[bever], 
             popup = ~as.character(datum),
             label = ~paste(as.character(datum),
                            as.character(uur)))
library(mapview)
mapshot(m, file = "kaartje_telemetrie.jpg")

##maximale afstanden berekenen per beest
x <- 0
afstanden <- data.frame(bever=factor(levels(data$bever)),
                        maxdist=as.numeric(rep("", length(levels(data$bever)))))
for (i in levels(data$bever)){
  tmp <- subset(data, bever==i)
  for (j in 1:(nrow(tmp)-1)){
    for (k in 1:(nrow(tmp)-j)){
      y <- pointDistance(tmp[j,c("x","y")],tmp[j+k,c("x","y")], lonlat=T)
      if(y>x){
        x<-y
      }
    }
  }
afstanden$maxdist[afstanden$bever==i] <- x
x <- 0
}
