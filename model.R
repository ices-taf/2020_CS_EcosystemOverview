
# Here we run a few intermediate formatting steps done on SAG. 
# STECF and catch statistics only need one formatting step already done in data.R

library(icesTAF)
library(dplyr)
taf.library(icesFO)

mkdir("model")

# Have to substitute time-series of SSB of lez.27.6b with the custom column 2,
# which is the biomass index used in the advice.

icesSAG::findAssessmentKey("lez.27.6b", year = 2019)

lezdat <- getCustomColumns(13168)
lezdat <- lezdat %>% filter(customColumnId == 2) 
clean_sag <- clean_sag %>% mutate(SSB = replace(SSB,StockKeyLabel == "lez.27.6b", lezdat$customValue))

# Trends by guild

clean_sag <- read.taf("data/clean_sag.csv")
trends <- stock_trends(clean_sag)
guild <- guild_trends(clean_sag)

write.taf(trends, dir = "model")
write.taf(guild, dir = "model")

