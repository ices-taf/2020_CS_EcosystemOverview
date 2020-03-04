library(icesFO)


summary <- load_sag_summary(2019)
write.taf(summary, file = "SAG_summary.csv", quote = TRUE)

refpts <- load_sag_refpts(2019)
write.taf(refpts, file = "SAG_refpts.csv", quote = TRUE)
