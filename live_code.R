library(sf)
library(tidyverse)


# Con puntos desde csv ----------------------------------------------------

paradas <- read_csv("data/paradas_frecuentes.csv") %>% 
  st_as_sf(coords = c("X", "Y"), crs = 32719)

# st_write(paradas, "basura/paradas.shp")

library(mapview)
mapview(paradas)


# Con datos vectoriales ---------------------------------------------------

ciclovias_2016 <- read_sf("http://datos.cedeus.cl/geoserver/wfs?srsName=EPSG%3A4326&typename=geonode%3Aciclovias_existentes_09_16&outputFormat=json&version=1.0.0&service=WFS&request=GetFeature")
ciclovias_2018 <- read_sf("http://datos.cedeus.cl/geoserver/wfs?srsName=EPSG%3A4326&typename=geonode%3Aciclovias_sendasmultiproposito_existentes_rms_2019_gorerms&outputFormat=json&version=1.0.0&service=WFS&request=GetFeature")

mapview(ciclovias_2018, color = "purple") +
  mapview(ciclovias_2016, color = "orange")


# Usando leafsync::sync() -------------------------------------------------
library(leafsync)

p1 <- mapview(ciclovias_2018, color = "purple")
p2 <- mapview(ciclovias_2016, color = "orange")


sync(p1, p2, no.initial.sync = F)

# Con rasters -------------------------------------------------------------
library(raster)

temp_ene <- raster("data/temp_ene.tif")
temp_jul <- raster("data/temp_jul.tif")
region <- st_read("data/metropolitana.geojson")

p1 <- mapview(temp_ene, at = seq(-30, 50, 10), query.type = "click") +
  mapview(region, col.region = "transparent", alpha.region = 0)


p2 <- mapview(temp_jul, at = seq(-30, 50, 10), query.type = "click")+
  mapview(region, col.region = "transparent", alpha.region = 0)

sync(p1, p2)
