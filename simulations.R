## Part I

simulate <- function(df, years.to.sim, number.of.sim, plot=F){
  
  total.days <- length(df$Date)
  days.to.sim <- 252 * years.to.sim
  last.init <- total.days - days.to.sim
  
  if (plot == T){
    simuls <- matrix(data=NA, nrow=days.to.sim, ncol=number.of.sim) 
  }
  
  anual.rents <- c()
  for (i in 1:number.of.sim){
    init.day <- sample(1:last.init, size=1) + 1
    last.day <- init.day + days.to.sim - 1
    sim.period <- init.day:last.day
    sim.sample <- sample(sim.period, replace=T)
    sim.diff <- df$Diff_close_div[sim.sample]
    anual.rent <- prod(sim.diff) ** (1 / years.to.sim)
    anual.rents <- c(anual.rents, anual.rent)
    
    if (plot == T){
      simuls[,i] <- cumprod(sim.diff)
    }
  }
  
  if (plot == T){
    x11()
    plot(simuls[,1], type='l', ylim=c(min(simuls), max(simuls)))
    for (i in 2:number.of.sim){
      rgb <- sample(50:255, size=3)/255
      lines(simuls[,i], col=rgb(rgb[1], rgb[2], rgb[3]))
    }
    abline(h=1, lwd=2, col='red')
    x11()
    plot(log(simuls[,1]), type='l', ylim=c(min(log(simuls)), max(log(simuls))))
    for (i in 2:number.of.sim){
      rgb <- sample(1:255, size=3)/255
      lines(log(simuls[,i]), col=rgb(rgb[1], rgb[2], rgb[3]))
    }
    abline(h=0, lwd=2, col='red')
  }
  
  return(anual.rents)
}



## Part II

library(parallel)

sim.apply <- function(x, df, years.to.sim){
  
  total.days <- length(df$Date)
  days.to.sim <- 252 * years.to.sim
  last.init <- total.days - days.to.sim
  
  init.day <- sample(1:last.init, size=1) + 1
  last.day <- init.day + days.to.sim - 1
  sim.period <- init.day:last.day
  sim.sample <- sample(sim.period, replace=T)
  sim.diff <- df$Diff_close_div[sim.sample]
  anual.rent <- prod(sim.diff) ** (1 / years.to.sim)
  
  return(anual.rent)
}

simulate.apply <- function(df, years.to.sim, number.of.sim, paral=F){
  
  if (paral == T){
    cl <- makeCluster(detectCores() - 2)
    anual.rents <- parSapply(cl=cl, X=1:number.of.sim, FUN=sim.apply, df, years.to.sim)
    stopCluster(cl)
  } else {
    anual.rents <- sapply(X=1:number.of.sim, FUN=sim.apply, df, years.to.sim)
  }
  
  return(anual.rents)
}