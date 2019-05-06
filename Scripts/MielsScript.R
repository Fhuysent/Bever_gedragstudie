## **1. Voorbereiding**

### 1.1 Bibliotheken instellen

library(tidyr)
library(adehabitatHR)
library(leaflet)
library(rgdal)
library(lubridate)

### 1.2 Gegevens ophalen

setwd("../Input/csv")
fileNames <- Sys.glob("*.csv")
data <- NULL
for (fileName in fileNames) {
tmp <- read.csv2(fileName, header=TRUE)
data <- rbind(data,tmp)
}

#Grids definieren
BEL <- "+init=epsg:31370"
WGS84 <- "+init=epsg:4326"

##Data klaarzetten, id moet eerste kolom zijn
data2 <- data[,c(5,1,2,3,4)]
data2 <- subset(data2,bever %in% c("BE1002","BE1003","BE1005","BE1009","BE1013"))
data2$bever <- factor(data2$bever)
#3 regels om er een spatial element van te maken
coordinates(data2) <- c("x","y")
proj4string(data2) <- CRS(WGS84)
data2 <- spTransform(data2, CRS(BEL))

plot(data2, col=data2$bever)

##95%MCP
cp <- mcp(data2[,1], percent=95, unin = "m", unout = "ha")
plot(cp)
plot(data2, col=data2$bever, add=TRUE)

mcp.area(data2[,1], percent=seq(50, 100, by = 5))
##Ziet er goed uit
##Oppervlakten
as.data.frame(cp)

##1003Seizoen
data1003 <- subset(data,bever=="BE1003")
data1003$bever <- factor(data1003$bever)
data1003$maand <- month(data1003$datum)
data1003$bever2[data1003$maand<7] <- "BE1003voorjaar"
data1003$bever2[data1003$maand>6] <- "BE1003najaar"
data1003 <- data1003[,c(7,1,2,3,4)]
data1003$bever2 <- factor(data1003$bever2)
coordinates(data1003) <- c("x","y")
proj4string(data1003) <- CRS(WGS84)
data1003 <- spTransform(data1003, CRS(BEL))

##95%MCP
cp <- mcp(data1003[,1], percent=95, unin = "m", unout = "ha")
plot(cp)
plot(data1003, col=data1003$bever2, add=TRUE)

mcp.area(data1003[,1], percent=seq(50, 100, by = 5))
##Ziet er goed uit
##Oppervlakten
as.data.frame(cp)

##Kernel densities?
kud <- kernelUD(data2[,1], h="href")
kud
image(kud)
homerange <- getverticeshr(kud, unin = "m", unout = "ha", percent=95)
plot(homerange, col=2:6)

as.data.frame(homerange)
ii <- kernel.area(kud, percent=seq(50,95,by=5))
ii

homerangeplot <- spTransform(homerange, CRS(WGS84))

pal <- colorFactor(
palette = c('red', 'blue', 'green', 'purple', 'orange'),
domain = homerangeplot@data$id
)

leaflet() %>%
addTiles() %>%
addPolygons(data=homerangeplot, color=~pal(id))

