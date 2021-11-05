## Part I

source("simulations.R")

df <- read.csv("SP500.csv")

years.to.sim <- 25
number.of.sim <- 5000

anual.rents <- simulate(df, years.to.sim, number.of.sim, plot=F)

hist(anual.rents, breaks=seq(min(anual.rents) - 0.01, max(anual.rents) + 0.01, by=0.01))



## Part II

number.of.sim <- 1000000
anual.rents <- simulate.apply(df, years.to.sim, number.of.sim, paral=T)


x11(); par(mfrow = c(2, 1))
hist(anual.rents, breaks=seq(min(anual.rents) - 0.005, max(anual.rents) + 0.005, by=0.005), prob=T)
lines(density(anual.rents), col='red')
plot(ecdf(anual.rents), col='red', col.01line=NULL)


calc.prob <- function(x, simuls){
  return(length(simuls[simuls <= x]) / length(simuls))
}

prob1 <- calc.prob(1, anual.rents)
sprintf('Probabilidad de rent <= 1 a %i años: %4f', years.to.sim, prob1)
prob2 <- 1 - calc.prob(1.05, anual.rents)
sprintf('Probabilidad de rent > 1.05 a %i años: %4f', years.to.sim, prob2)


number.of.sim <- 10000
probs <- c()
for (year in 1:60){
  anual.rents <- simulate.apply(df, year, number.of.sim, paral=T)
  probs <- c(probs, calc.prob(1, anual.rents))
}
plot(probs, type='l')
