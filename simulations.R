simulate <- function(df, years.to.sim, number.of.sim, save=F, save.name='simulations.csv', plot.n=F, plot.l=F, cero.line=F){
  
  total.days <- length(df$Date)
  days.to.sim <- 252 * years.to.sim
  last.init <- total.days - days.to.sim
  
  simuls <- matrix(data=NA, nrow=days.to.sim, ncol=number.of.sim) 
  for (i in 1:number.of.sim){
    init.day <- sample(1:last.init, size=1) + 1
    last.day <- init.day + days.to.sim - 1
    sim.period <- init.day:last.day
    sim.sample <- sample(sim.period, replace=T)
    sim.diff <- df$Diff_close_div[sim.sample]
    simuls[,i] <- cumprod(sim.diff)
  }
  rents <- simuls[days.to.sim,]
  anual.rents <- rents ^ (1 / years.to.sim)
  
  if (plot.n == T){
    x11()
    plot(simuls[,1], type='l', ylim=c(min(rents), max(rents)))
    for (i in 2:1000){
      rgb <- sample(50:255, size=3)/255
      lines(simuls[,i], col=rgb(rgb[1], rgb[2], rgb[3]))
    }
  }
  if (plot.l == T){
    x11()
    plot(log(simuls[,1]), type='l', ylim=c(min(log(rents)), max(log(rents))))
    for (i in 2:500){
      rgb <- sample(1:255, size=3)/255
      lines(log(simuls[,i]), col=rgb(rgb[1], rgb[2], rgb[3]))
    }
    if (cero.line == T){
      abline(h=0, lwd=2, col='red')
    }
  }
  
  if (save == T){
    simuls <- data.frame(simuls)
    write.csv(simuls, save.name, row.names = FALSE)
  }
  
  return(anual.rents)
}

hist.rent <- function(df, verbose=F){
  
  years <- length(df$Close) / 252
  rent <- df$Cum_Diff_close_div[length(df$Cum_Diff_close_div)] ^ (1 / years)
  
  return(rent)
}
