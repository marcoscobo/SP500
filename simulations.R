simulate <- function(df, years.to.sim, number.of.sim, save=F, plot.n=F, plot.l=F, cero.line=T){
  
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
  
  
  
  if (save == T){
    write.csv(data.frame(simuls), 'simulations.csv', row.names = FALSE)
  }
  
  if (plot.n == T){
    #png(filename = 'graf_n.png', width=1920, height=1080)
    #x11()
    plot(simuls[,1], type='l', ylim=c(min(simuls), max(simuls)))
    for (i in 2:number.of.sim){
      rgb <- sample(50:255, size=3)/255
      lines(simuls[,i], col=rgb(rgb[1], rgb[2], rgb[3]))
    }
    if (cero.line == T){
      abline(h=1, lwd=2, col='red')
    }
    #dev.off()
  }
  
  if (plot.l == T){
    #png(filename = 'graf_l.png', width=1920, height=1080)
    #x11()
    plot(log(simuls[,1]), type='l', ylim=c(min(log(simuls)), max(log(simuls))))
    for (i in 2:number.of.sim){
      rgb <- sample(1:255, size=3)/255
      lines(log(simuls[,i]), col=rgb(rgb[1], rgb[2], rgb[3]))
    }
    if (cero.line == T){
      abline(h=0, lwd=2, col='red')
    }
    #dev.off()
  }
  
  return(anual.rents)
}



hist.rent <- function(df, verbose=F){
  
  years <- length(df$Close) / 252
  rent <- df$Cum_Diff_close_div[length(df$Cum_Diff_close_div)] ^ (1 / years)
  
  return(rent)
}
