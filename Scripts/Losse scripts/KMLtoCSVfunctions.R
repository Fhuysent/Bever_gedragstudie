require(tidyr)

##Polygon_kml_coord function
##gets names and coordinates from kml polygons

Polygon_kml_coord <- function(fileName){
  kml.text <- readLines(fileName)
  coordstart <- grep("<coordinates>",kml.text)
  coordeind <- grep("</coordinates>",kml.text)
  coords <- NULL
  for (i in 1:length(coordstart)){
    start <- coordstart[i]
    eind <- coordeind[i]
    naam <- gsub("^.*>","",gsub("</name>","",kml.text[start-6]))
    for (j in (start+1):(eind-1)){
      coordi <- as.data.frame(kml.text[j])
      colnames(coordi) <- c("ruw")
      coordi <- coordi %>%
        separate(ruw, c("x", "y", "z"), ",")
      coordi <- cbind(naam, coordi)
      coords <- rbind(coords,coordi)
    }
  }
  coords <- coords[,1:3]
  return(coords)
}

##Line_kml_coord function
##gets names and coordinates from kml lines

Line_kml_coord <- function(fileName){
  kml.text <- readLines(fileName)
  coordstart <- grep("<coordinates>",kml.text)
  coordeind <- grep("</coordinates>",kml.text)
  coords <- NULL
  for (i in 1:length(coordstart)){
    start <- coordstart[i]
    eind <- coordeind[i]
    naam <- gsub("^.*>","",gsub("</name>","",kml.text[start-4]))
    for (j in (start+1):(eind-1)){
      coordi <- as.data.frame(kml.text[j])
      colnames(coordi) <- c("ruw")
      coordi <- coordi %>%
        separate(ruw, c("x", "y", "z"), ",")
      coordi <- cbind(naam, coordi)
      coords <- rbind(coords,coordi)
    }
  }
  coords <- coords[,1:3]
  return(coords)
}




