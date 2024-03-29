## Part I

# Define the simulations function
simulate <- function(df, years.to.sim, number.of.sim, plot=F, save=F){
  
  # Get the number of day we have historical data
  total.days <- length(df$Date)
  # Calculate the number of days to simulate (1 year has 252 market opening days aprox.)
  days.to.sim <- 252 * years.to.sim
  # Get the last possible starting day to simulate
  last.init <- total.days - days.to.sim
  
  if (plot == T){
    # Initialize an empty matrix to save every simulation
    simuls <- matrix(data=NA, nrow=days.to.sim, ncol=number.of.sim) 
  }
  
  # Initialize an empty vector to save every simulated yield
  annual.yields <- c()
  for (i in 1:number.of.sim){
    # Get the initial day of the simulation
    init.day <- sample(1:last.init, size=1) + 1
    # Calculate the last day of the simulation
    last.day <- init.day + days.to.sim - 1
    # Get the simulation period
    sim.period <- init.day:last.day
    # Get the indexes of simulation
    sim.sample <- sample(sim.period, replace=T)
    # Get the simulated increments
    sim.diff <- df$Diff_close_div[sim.sample]
    # Calculate the simulated annual yield
    annual.yield <- prod(sim.diff) ** (1 / years.to.sim)
    # Add the annual yield to the vector
    annual.yields <- c(annual.yields, annual.yield)
    
    if (plot == T || save == T){
      # Add the simulation to the matrix
      simuls[,i] <- cumprod(sim.diff)
    }
  }
  
  if (plot == T){
    # Initialize the plot with the first simulation
    plot(simuls[,1], type='l', ylim=c(min(simuls), max(simuls)), main='Simulated yields', xlab='number of simulation', ylab='simulated yields', cex.axis=2, cex.main=2, cex.lab=2)
    for (i in 2:number.of.sim){
      # Get a random color
      rgb <- sample(50:255, size=3)/255
      # Add the simulation to the plot
      lines(simuls[,i], col=rgb(rgb[1], rgb[2], rgb[3]))
    }
    # Add an horizontal line at the yield of 1
    abline(h=1, lwd=2, col='red')
    # Initialize the plot with the first simulation (log)
    plot(log(simuls[,1]), type='l', ylim=c(min(log(simuls)), max(log(simuls))), main='Simulated yields', xlab='number of simulation', ylab='log(simulated yields)', cex.axis=2, cex.main=2, cex.lab=2)
    for (i in 2:number.of.sim){
      # Get a random color
      rgb <- sample(1:255, size=3)/255
      # Add the simulation to the plot (log)
      lines(log(simuls[,i]), col=rgb(rgb[1], rgb[2], rgb[3]))
    }
    # Add an horizontal line at the yield of 1 (log(1)=0)
    abline(h=0, lwd=2, col='red')
  }

  if (save == T){
    write.csv(simuls,'simulations.csv', row.names=F)
  }
  
  # Return the annual yields vector
  return(annual.yields)
}



## Part II

# Import the pararell library
library(parallel)

# Define the function simulate an annual yield
sim.apply <- function(x, df, years.to.sim){
  
  # Get the number of day we have historical data
  total.days <- length(df$Date)
  # Calculate the number of days to simulate (1 year has 252 market opening days aprox.)
  days.to.sim <- 252 * years.to.sim
  # Get the last possible starting day to simulate
  last.init <- total.days - days.to.sim
  
  # Get the initial day of the simulation
  init.day <- sample(1:last.init, size=1) + 1
  # Calculate the last day of the simulation
  last.day <- init.day + days.to.sim - 1
  # Get the simulation period
  sim.period <- init.day:last.day
  # Get the indexes of simulation
  sim.sample <- sample(sim.period, replace=T)
  # Get the simulated increments
  sim.diff <- df$Diff_close_div[sim.sample]
  # Calculate the simulated annual yield
  annual.yield <- prod(sim.diff) ** (1 / years.to.sim)
  
  # Return the simulated annual yield
  return(annual.yield)
}

# Define the simulations function
simulate.apply <- function(df, years.to.sim, number.of.sim, paral=F){
  
  if (paral == T){
    # Make a cluster with all but 2 processor cores (leave 2 for other tasks)
    cl <- makeCluster(detectCores() - 2)
    # Calculate the simulated annual yields
    annual.yields <- parSapply(cl=cl, X=1:number.of.sim, FUN=sim.apply, df, years.to.sim)
    # Stop the cluster
    stopCluster(cl)
  } else {
    # Calculate the simulated annual yields
    annual.yields <- sapply(X=1:number.of.sim, FUN=sim.apply, df, years.to.sim)
  }
  
  # Return the annual yields vector
  return(annual.yields)
}
