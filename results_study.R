library(fitdistrplus) # "norm", "lnorm", "pois", "exp", "gamma", "nbinom", "geom", "beta", "unif", "logis"

df <- read.csv("amounts.csv")
amounts <- df$Amounts

factor <- 1e+4
amounts <- amounts / factor

fg <- fitdist(amounts, "gamma")

x11()
par(mfrow = c(2, 2))
denscomp(fg)
qqcomp(fg)
cdfcomp(fg)
ppcomp(fg)
