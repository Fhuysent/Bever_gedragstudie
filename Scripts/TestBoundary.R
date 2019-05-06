BE1003 <- data2[as.data.frame(data2)[,1]=="BE1003",]

kud <- kernelUD(BE1003, h=300, grid=1000)
kud
image(kud)
homerange <- getverticeshr(kud, unin = "m", unout = "ha", percent=95)
plot(homerange, col=2:6)
as.data.frame(homerange)

Grens <- subset(Lijngrenzen, naam=="Dijle")
Grens$x <- as.numeric(Grens$x)
Grens$y <- as.numeric(Grens$y)
coordinates(Grens) <- c("x","y")
proj4string(Grens) <- CRS(WGS84)
Grens <- spTransform(Grens, CRS(BEL))

bound <- structure(list(Grens$x, Grens$y), .Names= c("x","y"))
lines(bound, lwd=3)

bound <- do.call("cbind",bound)
Slo1 <- Line(bound)
Sli1 <- Lines(list(Slo1), ID="frontier1")
barrier <- SpatialLines(list(Sli1))
plot(barrier)

kud <- kernelUD(BE1003, h=390, grid=1000, boundary=barrier)
kud
image(kud)
homerange <- getverticeshr(kud, unin = "m", unout = "ha", percent=95)
plot(homerange, col=2:6)
as.data.frame(homerange)

homerangeplot <- spTransform(homerange, CRS(WGS84))

pal <- colorFactor(
  palette = c('red', 'blue', 'green', 'purple', 'orange'),
  domain = homerangeplot@data$id
)

leaflet() %>%
  addTiles() %>%
  addPolygons(data=homerangeplot, color=~pal(id))


