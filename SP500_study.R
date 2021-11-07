## Part I

source("simulations.R")

df <- read.csv("SP500.csv")

years.to.sim <- 20
number.of.sim <- 1000

anual.rents <- simulate(df, years.to.sim, number.of.sim, plot=T)
anual.rents <- anual.rents - 0.001

hist(anual.rents, breaks=seq(min(anual.rents) - 0.01, max(anual.rents) + 0.01, by=0.01))



## Part II

par(mfrow = c(2, 1))
hist(anual.rents, breaks=seq(min(anual.rents) - 0.005, max(anual.rents) + 0.005, by=0.005), prob=T, main='Density Function')
lines(density(anual.rents), col='red')
plot(ecdf(anual.rents), col='red', col.01line=NULL, main='Cumulative Distribution Function')

source("simulations.R")

number.of.sim <- 1000000
anual.rents <- simulate.apply(df, years.to.sim, number.of.sim, paral=T)
anual.rents <- anual.rents - 0.001

par(mfrow = c(2, 1))
hist(anual.rents, breaks=seq(min(anual.rents) - 0.005, max(anual.rents) + 0.005, by=0.005), prob=T, main='Density Function')
lines(density(anual.rents), col='red')
plot(ecdf(anual.rents), col='red', col.01line=NULL, main='Cumulative Distribution Function')

calc.prob <- function(x, simuls){
  return(length(simuls[simuls <= x]) / length(simuls))
}

prob1 <- calc.prob(1, anual.rents)
sprintf('Probabilidad de rent <= 1 a %i años: %4f', years.to.sim, prob1)
prob2 <- 1 - calc.prob(1.05, anual.rents)
sprintf('Probabilidad de rent > 1.05 a %i años: %4f', years.to.sim, prob2)

number.of.sim <- 100000
probs <- c()
for (year in 1:60){
  print(year)
  anual.rents <- simulate.apply(df, year, number.of.sim, paral=T) - 0.001
  probs <- c(probs, calc.prob(1, anual.rents))
}
plot(probs, type='l', main='Probability of anual yield <= 0%')
abline(h=0.01, lty=3, col='red')
