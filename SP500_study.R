## Part I

# Load simulations function
source("simulations.R")

# Load historical data
df <- read.csv("SP500.csv")

# Define the simulated period
years.to.sim <- 20
# Define the number of simulations to do
number.of.sim <- 1000

# Get the simulated annual yields
annual.yields <- simulate(df, years.to.sim, number.of.sim, plot=T)
# Discount commissions
annual.yields <- annual.yields - 0.001

# Histogram of annual yields
hist(annual.yields, breaks=seq(min(annual.yields) - 0.01, max(annual.yields) + 0.01, by=0.01), main='Distribution of annual yields', cex.axis=2, cex.main=2, cex.lab=2)



## Part II

# Divide the frame
par(mfrow = c(2, 1))
# Histogram of annual yields
hist(annual.yields, breaks=seq(min(annual.yields) - 0.005, max(annual.yields) + 0.005, by=0.005), prob=T, main='Density Function', cex.axis=2, cex.main=2, cex.lab=2)
# Add the density function
lines(density(annual.yields), col='red')
# Plot the cumulative distribution function
plot(ecdf(annual.yields), col='red', col.01line=NULL, main='Cumulative Distribution Function', cex.axis=2, cex.main=2, cex.lab=2)

# Load simulations function
source("simulations.R")

# Define the number of simulations to do
number.of.sim <- 1e+6
# Get the simulated annual yields and discount commissions
annual.yields <- simulate.apply(df, years.to.sim, number.of.sim, paral=T) - 0.001

# Divide the frame
par(mfrow = c(2, 1))
# Histogram of annual yields
hist(annual.yields, breaks=seq(min(annual.yields) - 0.005, max(annual.yields) + 0.005, by=0.005), prob=T, main='Density Function', cex.axis=2, cex.main=2, cex.lab=2)
# Add the density function
lines(density(annual.yields), col='red')
# Plot the cumulative distribution function
plot(ecdf(annual.yields), col='red', col.01line=NULL, main='Cumulative Distribution Function', cex.axis=2, cex.main=2, cex.lab=2)

# Define the function to return the prob of X <= x
calc.prob <- function(x, simuls){
  # P(X<=x) = number of simulatios <= x / total simulations
  return(length(simuls[simuls <= x]) / length(simuls))
}

# Get the probability of annual yield <= 1
prob1 <- calc.prob(1, annual.yields)
sprintf('Probability of annual yield <= 1 for %i years: %4f', years.to.sim, prob1)
# Get the probability of annual yield > 1.05
prob2 <- 1 - calc.prob(1.05, annual.yields)
sprintf('Probability of annual yield > 1.05 for %i years: %4f', years.to.sim, prob2)

# Define the number of simulations to do
number.of.sim <- 1e+5
# Initialize an empty vector to save the probabilities
probs <- c()
for (year in 1:60){
  # Get the simulated annual yields and discount commissions
  annual.yields <- simulate.apply(df, year, number.of.sim, paral=T) - 0.001
  # Add the probability to the vector
  probs <- c(probs, calc.prob(1, annual.yields))
}
# Reset the frame
par(mfrow = c(1, 1))
# Plot the probability curve
plot(probs, type='l', main='Probability of annual yield <= 0%', xlab='number of years', ylab='Probability', cex.axis=2, cex.main=2, cex.lab=2)
# Add an horizontal line at the probability of 0.01
abline(h=0.01, lty=3, col='red')
