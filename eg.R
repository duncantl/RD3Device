source("d3Dev.R")
dev = d3Device(file = "../../foo.js")
plot(1:10, cex = 2, main = "A title")
dev.off()


source("d3Dev.R")
dev = d3Device(file = "../../foo.js")
map('county', 'california')
dev.off()

source("d3Dev.R")
dev = d3Device(file = "../../foo.js")
map('county', 'california', fill = TRUE, col = c("red", "blue"))
dev.off()


source("d3Dev.R")
library(lattice)
dev = d3Device(file = "../../foo.js")
xyplot(mpg ~ wt | cyl, mtcars, group = gear)
dev.off()



source("d3Dev.R")
dev = d3Device(file = "../../foo.js")
   data("Hitters")
     attach(Hitters)
     colors <- c("black","red","green","blue","red","black","blue")
     pch <- substr(levels(Positions), 1, 1)
     ternaryplot(
       Hitters[,2:4],
       pch = as.character(Positions),
       col = colors[as.numeric(Positions)],
       main = "Baseball Hitters Data"
     )
     grid_legend(0.8, 0.9, pch, colors, levels(Positions),
       title = "POSITION(S)")
dev.off()

