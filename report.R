
# All plots and data outputs are produced here

library(icesTAF)
taf.library(icesFO)
library(sf)
library(ggplot2)

mkdir("report")

##########
#Load data
##########

sid <- read.taf("bootstrap/data/ICES_StockInformation/sid.csv")

trends <- read.taf("model/trends.csv")
guild <- read.taf("model/guild.csv")

# read vms fishing effort
effort <-
  sf::st_read("bootstrap/data/ICES_vms_effort_map/vms_effort.csv",
               options = "GEOM_POSSIBLE_NAMES=wkt", crs = 4326)
effort <- dplyr::select(effort, -WKT)

# read vms swept area ratio
sar <-
  sf::st_read("bootstrap/data/ICES_vms_sar_map/vms_sar.csv",
               options = "GEOM_POSSIBLE_NAMES=wkt", crs = 4326)
sar <- dplyr::select(sar, -WKT)

###########
##  SAG  ##
###########
#~~~~~~~~~~~~~~~~~~~~~~~~~#
# Ecosystem Overviews plot
#~~~~~~~~~~~~~~~~~~~~~~~~~#

plot_guild_trends(guild, cap_year = 2019, cap_month = "October",return_data = FALSE )
ggplot2::ggsave("2019_CS_EO_GuildTrends.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
guild2 <- guild %>% dplyr::filter(Year > 1957)
plot_guild_trends(guild2, cap_year = 2019, cap_month = "October",return_data = FALSE )
ggplot2::ggsave("2019_CS_EO_GuildTrends_short.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

guild3 <- guild %>% dplyr::filter(FisheriesGuild != "MEAN")
plot_guild_trends(guild3, cap_year = 2019, cap_month = "November",return_data = FALSE )
ggplot2::ggsave("2019_CS_EO_GuildTrends_noMEAN.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
guild4 <- guild3 %>% dplyr::filter(Year > 1957)
plot_guild_trends(guild4, cap_year = 2019, cap_month = "November",return_data = FALSE )
ggplot2::ggsave("2019_CS_EO_GuildTrends_short_noMEAN.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)


dat <- plot_guild_trends(guild, cap_year = 2019, cap_month = "October",return_data = TRUE)
write.taf(dat, file ="2019_CS_EO_GuildTrends.csv", dir = "report" )


dat <- trends[,1:2]
dat <- unique(dat)
dat <- dat %>% dplyr::filter(StockKeyLabel != "MEAN")
dat2 <- sid %>% select(c(StockKeyLabel, StockKeyDescription))
dat <- left_join(dat,dat2)
write.taf(dat, file ="2019_CS_EO_SpeciesGuild_list.csv", dir = "report", quote = TRUE)



###########
##  VMS  ##
###########

#~~~~~~~~~~~~~~~#
# A. Effort map
#~~~~~~~~~~~~~~~#

gears <- c("Static", "Midwater", "Otter", "Demersal seine", "Dredge", "Beam")

effort <-
    effort %>%
      dplyr::filter(fishing_category_FO %in% gears) %>%
      dplyr::mutate(
        fishing_category_FO =
          dplyr::recode(fishing_category_FO,
            Static = "Static gears",
            Midwater = "Pelagic trawls and seines",
            Otter = "Bottom otter trawls",
            `Demersal seine` = "Bottom seines",
            Dredge = "Dredges",
            Beam = "Beam trawls")
        )

plot_effort_map(effort, ecoregion) +
  ggtitle("Average MW Fishing hours 2015-2018")

ggplot2::ggsave("2019_CS_EO_FigureX.png", path = "report", width = 170, height = 200, units = "mm", dpi = 300)

#~~~~~~~~~~~~~~~#
# B. Swept area map
#~~~~~~~~~~~~~~~#

plot_sar_map(sar, ecoregion, what = "surface") +
  ggtitle("Average surface swept area ratio 2015-2018")

ggplot2::ggsave("2019_CS_FO_Figure17a.png", path = "report", width = 170, height = 200, units = "mm", dpi = 300)

plot_sar_map(sar, ecoregion, what = "subsurface")+
  ggtitle("Average subsurface swept area ratio 2015-2018")

ggplot2::ggsave("2019_CS_EO_FigureY.png", path = "report", width = 170, height = 200, units = "mm", dpi = 300)


