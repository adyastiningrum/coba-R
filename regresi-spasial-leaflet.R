library(rgdal)
library(readxl)
library(sf)
library(dplyr)
library(htmltools)
library(leaflet)

datajambi <- read_excel("D:/4SI2/SKRIPSI/DATA/estimasi.xlsx", sheet="Sheet1")
petajambi <- readOGR("D:/4SI2/SKRIPSI/DATA/jambi/administrasikabupaten_ar_50k_150020180313221428.shp", layer="administrasikabupaten_ar_50k_150020180313221428")

petajambi_sf <- st_as_sf(petajambi)

alldata <- petajambi_sf %>%
  left_join(datajambi, by = c("namobj" = "kabKot"))

alldata <- alldata %>%
  st_simplify(preserveTopology = T, dTolerance = 0.0001)

#View(alldata)

mybin <- c(39.41, 47.13, 64.00, 81.32)
mypalette <- colorBin(palette = "Greens", domain = alldata, na.color = "transparent", bins = mybin)
mytext <- paste(
  alldata$namobj, "<br/>",
  "Persentase Capaian Vaksinasi: ", alldata$vaksin2, "<br/>",
  sep = "") %>%
  lapply(HTML)

petaleaflet <- leaflet(alldata) %>%
  addProviderTiles(providers$CartoDB.DarkMatter) %>%
  addPolygons(
    fillColor = ~ mypalette(alldata$vaksin2),
    weight = 1,
    opacity = 1,
    color = "white",
    dashArray = "2",
    fillOpacity = 0.7,
    label = mytext,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "13px",
      direction = "auto"
    )
  ) %>%
  addLegend("bottomright",
            pal = mypalette,
            values = ~ alldata$vaksin2,
            title = "Vaksinasi Dosis Kedua",
            labFormat = labelFormat(),
            opacity = 1)

petaleaflet

#alldata$estimasi <- sar$fitted.values
#View(alldata)

mybinp <- c(39.41, 47.13, 64.00, 81.32)
mypalettep <- colorBin(palette = "YlOrBr", domain = alldata, na.color = "transparent", bins = mybinp)
mytextp <- paste(
  alldata$namobj, "<br/>",
  "Persentase Estimasi Capaian Vaksinasi: ", alldata$estimasi, "<br/>",
  sep = "") %>%
  lapply(HTML)

petaleafletp <- leaflet(alldata) %>%
  addProviderTiles(providers$CartoDB.DarkMatter) %>%
  addPolygons(
    fillColor = ~ mypalettep(alldata$estimasi),
    weight = 1,
    opacity = 1,
    color = "white",
    dashArray = "2",
    fillOpacity = 0.7,
    label = mytextp,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "13px",
      direction = "auto"
    )
  ) %>%
  addLegend("bottomright",
            pal = mypalettep,
            values = ~ alldata$estimasi,
            title = "Vaksinasi Dosis Kedua",
            labFormat = labelFormat(),
            opacity = 1)

petaleafletp
