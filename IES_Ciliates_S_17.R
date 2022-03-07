#Saving to GitHub repository
ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}
packages <- c("tidyr", "dplyr", "ggplot2", "ggmap", "maps", "mapdata", "ncdf4", "chron", "lattice", "RColorBrewer", "Hmisc", "stringr", "trend", "kableExtra", "RODBC", "lsmeans", "car","wesanderson", "maptools", "deldir", "rgdal", "sp", "sf", "viridis", "measurements", "readxl")
ipak(packages)

IESData_2017 <- read.csv("~/Desktop/R/IERP Data/IES_17_Surf.csv")
IESData_2017$ciliate_biomass <- as.numeric(IESSurfData_2017$ciliate_biomass)
MAP <- st_read(dsn ="~/Desktop/R/Mapping Code - Astrid/Example 3 - abundance data on map/Shape_files_Alaska_dcw", layer = "Alaska_dcw_polygon_Project")

MAP <- st_transform(MAP, "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
BATH_200 <- st_read(dsn = "~/Desktop/R/Mapping Code - Astrid/Example 3 - abundance data on map/Bathy_200_m",
                    layer = "ne_10m_bathymetry_K_200")
BATH_200 <- st_transform(BATH_200, "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

ggplot()+
  geom_sf(color = "black", data = BATH_200[3], alpha = 0)+
  geom_sf(fill ="#a7ad94", color = "black", data = MAP[1])+
  coord_sf(xlim = c(-168.519,-157.228), ylim =c(72.498,66.997))+
  geom_point(aes(x = Longitude, y = Latitude, color = ciliate_biomass), data = IESSurfData_2017)+
  scale_color_viridis(option = "magma", name = expression(paste("ugC/L")), limits = c(0,200),breaks=c(seq(from=0, to=200, by=15)), labels=c(seq(from=0, to=200, by=15)))+
  theme_bw()+
  xlab(label = "Longitude")+
  ylab(label = "Latitude")+
  theme(
    axis.text.y = element_text(size = 8, color = "black"),
    axis.text.x = element_text(size = 8, color = "black"),
    axis.title = element_text(size = 8),
    strip.text = element_text(size = 8),
    legend.title = element_text(size = 8),
    legend.text = element_text(size = 5),
    strip.background = element_blank())+
  ggtitle(expression("Surface Ciliate Biomass 2017"))+
  labs(tag = "C")+
  theme(plot.tag.position = "topleft")

ggsave("IES_Ciliates_S_17.png", width = 6, height = 4, units = "in",
       bg = "transparent")