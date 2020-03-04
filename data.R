# Initial formatting of the data

library(icesTAF)
taf.library(icesFO)
library(dplyr)

mkdir("data")

# load species list
species_list <- read.taf("bootstrap/data/FAO_ASFIS_species/species_list.csv")
sid <- read.taf("bootstrap/data/ICES_StockInformation/sid.csv")

# 2: SAG
sag_sum <- read.taf("bootstrap/data/SAG_data/SAG_summary.csv")
sag_refpts <- read.taf("bootstrap/data/SAG_data/SAG_refpts.csv")


clean_sag <- format_sag(sag_sum, sag_refpts, 2019, "Celtic")
clean_sag <- unique(clean_sag)

out_stocks <-  c("aru.27.123a4", "bli.27.nea", "bll.27.3a47de",
                        "cap.27.2a514", "her.27.1-24a514a", "lin.27.5b", "reb.2127.dp",
                        "reg.27.561214", "rjb.27.3a4", "rng.27.1245a8914ab",
                        "san.sa.7r", "smn-dp")

library(operators)
clean_sag <- dplyr::filter(clean_sag, StockKeyLabel %!in% out_stocks)
detach("package:operators", unload=TRUE)

unique(clean_sag$StockKeyLabel)

write.taf(clean_sag, dir = "data")
