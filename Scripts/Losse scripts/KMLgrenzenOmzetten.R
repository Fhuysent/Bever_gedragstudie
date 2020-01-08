setwd("../../Input/kmlgrenzen")
fileNames <- Sys.glob("*.kml")

fileName <- "Grens Dijle.kml"
fileName_short <- sub(".kml","", fileName)
assign(fileName_short, as.data.frame(Polygon_kml_coord(fileName)))

fileName <- "Lijngrenzen.kml"
fileName_short <- sub(".kml","", fileName)
assign(fileName_short, as.data.frame(Line_kml_coord(fileName)))

fileName <- "RuweGrens.kml"
fileName_short <- sub(".kml","", fileName)
assign(fileName_short, as.data.frame(Polygon_kml_coord(fileName)))


fileName <- "Dijle.kml"
fileName_short <- sub(".kml","", fileName)
assign(fileName_short, as.data.frame(Line_kml_coord(fileName)))


