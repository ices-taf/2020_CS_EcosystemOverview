
library(icesTAF)
taf.library(icesFO)

sid <- load_sid(2019)

write.taf(sid, quote = TRUE)
