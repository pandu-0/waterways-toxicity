install.packages(c(
  "sf",
  "dplyr",
  "ggplot2",
  "ggrepel",
  "httr2",
  "rnaturalearth",
  "rnaturalearthdata"
))


library(sf)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(httr2)
library(rnaturalearth)
library(rnaturalearthdata)

# Station codes to plot
station_codes <- strsplit(
  paste(
    "403STCBQT 404BLNAxx 911TJHRxx 405SGRA2x 907SDRWAR 801CCPT12",
    "541MERECY 901SJSJC9 906LPLPC6 412LARWxx 801SDCxxx 403STCSSP",
    "310ARG 309TDW 541STC516 909SWRWSx 207KIR020 723NROTWM",
    "535STC206 312SMA 904ESCOxx 204SMA020 205COY060 402VRB0xx",
    "205GUA020 723ARGRB1 315ATA 207WAL020 309DAV 315MIS",
    "719CVSCOT 305THU 520CBDKLU 408CGCS06 204SLE030 541STC019",
    "801SARVRx 206SON010 504BCHROS 204ALA020 403STCEST 515SACKNK",
    "535MER007 905SDSDQ9 558TUR090 603BSP002 541SJC501 903SLRRBB",
    "114LAGWOH 535MER546 535STC504 310SLB 558CCR010 519BERBRY",
    "544SAC002 510LSAC08 304SOK 902SSMR07 511CAC113 535STC501",
    "103SM1009 105KLAMKK 109MAD101 111EELFRN 111SF0933 113NA3269",
    "114RRDSDM 201LAG125 201WLK160 207LAU020 304SLRWAT 307CML",
    "313SAI 314SYN 504SACHMN 508SACBLF 515YBAMVL 519AMNDVY",
    "519FTRNCS 520BUTPAS 520SACLSA 526PRFALR 531SAC001 532AMA002",
    "535STC210 541MER522 541MER542 551LKI040 554SKR010 558PKC005",
    "603LOWSED 628DEPSED 631WWKLAR 633WCRSED 634UTRSED 635MARSED",
    "635TRKSED 635TROSED 637SUS001 802SJCREF"
  ),
  " "
)[[1]]

# Official California Water Board station lookup service
lookup_url <- paste0(
  "https://gispublic.waterboards.ca.gov/portalserver/rest/services/",
  "Hosted/StationLookUp/FeatureServer/0/query"
)

# Build a query containing the requested station codes
where_clause <- paste0(
  "StationCode IN (",
  paste0("'", station_codes, "'", collapse = ","),
  ")"
)

# Request station locations as GeoJSON
response <- request(lookup_url) |>
  req_url_query(
    where = where_clause,
    outFields = "*",
    returnGeometry = "true",
    f = "geojson"
  ) |>
  req_perform()

station_geojson <- resp_body_string(response)

# Save the GeoJSON response temporarily
geojson_file <- tempfile(fileext = ".geojson")
writeLines(station_geojson, geojson_file)

# Read the temporary GeoJSON file
stations <- st_read(
  dsn = geojson_file,
  quiet = TRUE
) |>
  st_transform(4326)


# Get a California state boundary
california <- map_data("state") |>
  filter(region == "california")



stations_plot <- stations |>
  st_drop_geometry()

ggplot() +
  geom_polygon(
    data = california,
    aes(
      x = long,
      y = lat,
      # group = group
    ),
    fill = "gray95",
    color = "gray40"
  ) +
  geom_point(
    data = stations_plot,
    aes(
      x = targetlongitude,
      y = targetlatitude
    ),
    size = 1,
    alpha = 0.9
  ) +
  coord_fixed(
    xlim = c(-125, -114),
    ylim = c(32, 43)
  ) +
  labs(
    # title = "Location of SPoT Monitoring Stations Used in the Analysis",
    x = "Longitude",
    y = "Latitude",
    # color = "Land-use category"
  ) +
  theme_minimal()














