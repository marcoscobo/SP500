library(fitdistrplus) # "norm", "lnorm", "pois", "exp", "gamma", "nbinom", "geom", "beta", "unif", "logis"
source("simulations.R")

df <- read.csv("SP500.csv")

rent <- hist.rent(df, verbose=T)
sprintf('Rentabilidad anual media = %4f', (rent - 1) * 100)

years.to.sim <- 25
number.of.sim <- 5000

anual.rents <- simulate(df, years.to.sim, number.of.sim, plot.l=F, cero.line=T)

## DISTRIBUCION DE LAS RENTABILIDADES

shapiro.test(anual.rents)

fn <- fitdist(anual.rents, "norm")
fl <- fitdist(anual.rents, "logis")

x11()
par(mfrow = c(1, 2))
plot.legend <- c("norm", "logis")
denscomp(list(fn, fl), legendtext = plot.legend)
qqcomp(list(fn, fl), legendtext = plot.legend)
cdfcomp(list(fn, fl), legendtext = plot.legend)
ppcomp(list(fn, fl), legendtext = plot.legend)


## CALCULO DE PROBABILIDADES
sprintf('Rentabilidad anual media: %4f', mean(anual.rents))

# normal
nprob <- pnorm(1, mean=fn$estimate[1], sd=fn$estimate[2])
sprintf('Probabilidad de rent <= 1 a %i años: %4f', years.to.sim, nprob)

nprob2 <- (pnorm(1.14, mean=fn$estimate[1], sd=fn$estimate[2]) - pnorm(1.06, mean=fn$estimate[1], sd=fn$estimate[2]))
sprintf('Probabilidad de rent en (1.06,1.14) a %i años: %4f', years.to.sim, nprob2)

nprob3 <- (1 - pnorm(1.05, mean=fn$estimate[1], sd=fn$estimate[2]))
sprintf('Probabilidad de rent > 1.05 a %i años: %4f', years.to.sim, nprob3)


# logistic
lprob <- plogis(1, location=fl$estimate[1], scale=fl$estimate[2])
sprintf('Probabilidad de rent <= 1 a %i años: %4f', years.to.sim, lprob)

lprob2 <- (plogis(1.14, location=fl$estimate[1], scale=fl$estimate[2]) - plogis(1.06, location=fl$estimate[1], scale=fl$estimate[2]))
sprintf('Probabilidad de rent en (1.06,1.14) a %i años: %4f', years.to.sim, lprob2)

lprob3 <- (1 - plogis(1.05, location=fl$estimate[1], scale=fl$estimate[2]))
sprintf('Probabilidad de rent > 1.05 a %i años: %4f', years.to.sim, lprob3)

## PLOT

probs <- c()
for (year in 1:50){
  anual.rents <- simulate(df, year, 5000)
  fl <- fitdist(anual.rents, "logis")
  probs <- c(probs, plogis(1, location=fl$estimate[1], scale=fl$estimate[2]))
}

for (year in seq(5, 50, by=5)){
  print(probs[year])
}

x11()
plot(probs, type='l')
