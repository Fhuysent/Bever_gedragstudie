library(leaflet)
library(raster)

setwd("Input/csv")
fileNames <- Sys.glob("*.csv")
data <- NULL
for (fileName in fileNames) {
  tmp <- read.csv2(fileName, header=TRUE, sep=,)
  data <- rbind(data,tmp)
}

#hieronder a6cee3 vervangen door kleuren
BeverIcons <- iconList(
  BE1002 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|a6cee3&chf=a,s,ee00FFFF",10,10),
  BE1003 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|1f78b4&chf=a,s,ee00FFFF",10,10),
  BE1004 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|b2df8a&chf=a,s,ee00FFFF",10,10),
  BE1005 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|33a02c&chf=a,s,ee00FFFF",10,10),
  BE1006 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|fb9a99&chf=a,s,ee00FFFF",10,10),
  BE1007 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|e31a1c&chf=a,s,ee00FFFF",10,10),
  BE1008 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|fdbf6f&chf=a,s,ee00FFFF",10,10),
  BE1009 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|ff7f00&chf=a,s,ee00FFFF",10,10),
  BE1010 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|cab2d6&chf=a,s,ee00FFFF",10,10),
  BE1011 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|6a3d9a&chf=a,s,ee00FFFF",10,10),
  BE1013 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|f37736&chf=a,s,ee00FFFF",10,10),
  BE1014 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|ff1d8e&chf=a,s,ee00FFFF",10,10),
  BE1015 = makeIcon("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|15c3d3&chf=a,s,ee00FFFF",10,10))

mapdata <- subset(data, bever!="BE1012" & 
                    bever!="BE1016")

m <-leaflet(data=mapdata) %>% 
  addTiles() %>%
  addMarkers(~x,~y, icon=~BeverIcons[bever], 
             popup = ~as.character(datum),
             label = ~paste(as.character(datum),
                            as.character(uur)))

m
library(mapview)
mapshot(m, file = "../../Output/kaartje_telemetrie.jpg")

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


##Eerste aanzet om hier polygonen van te maken
library(sp)

for (i in levels(data$bever)){
  tmp <- subset(data, bever==i)
  coords <- cbind(tmp[,3:4])
  sp <- SpatialPoints(coords)
  P <- Polygon(sp)
  Ps <- Polygons(list(P), ID= i)
  name <- paste("Ps", i, sep="")
  assign(name, Ps)
  }

sp2 = SpatialPolygons(list(PsBE1002,PsBE1003))
Ps1 = SpatialPolygons(list(Polygons(list(P1), ID = "a")), proj4string=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))



m <-leaflet(data=mapdata) %>% 
  addTiles() %>%
  addMarkers(~x,~y, icon=~BeverIcons[bever], 
             popup = ~as.character(datum),
             label = ~paste(as.character(datum),
                            as.character(uur))) %>%
  addPolygons(data=PsBE1002) %>%
  addPolygons(data=PsBE1003, color="green") %>%
  addPolygons(data=PsBE1004) %>%
  addPolygons(data=PsBE1005) %>%
  addPolygons(data=PsBE1006) %>%
  #addPolygons(data=PsBE1007, color="green") %>%
  addPolygons(data=PsBE1008, color="red") %>%
  addPolygons(data=PsBE1009, color="green") %>%
  addPolygons(data=PsBE1010, color="red") %>%
  #addPolygons(data=PsBE1011, color="orange") %>%
  addPolygons(data=PsBE1013, color="red") %>%
  #addPolygons(data=PsBE1014, color="purple") %>%
  addPolygons(data=PsBE1015)
m

mapshot(m, file = "../../Output/kaartje_telemetrie_families.jpg")

