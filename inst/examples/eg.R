source("d3Dev.R")
dev = d3Device(file = "../../foo.js")
plot(1:10, cex = 2, main = "A title")
abline(v = 5, col = "red")
abline(h = 5, col = "blue")
dev.off()


source("d3Dev.R")
library(maps)
dev = d3Device(file = "../../foo.js")
map('county', 'california')
dev.off()


source("d3Dev.R")
library(maps)
dev = d3Device(file = "../../foo.js")
map('county', 'california', fill = TRUE, col = c("red", "blue"))
dev.off()

hdoc = addToHTMLTemplate(dev$getCode(), html = "../inst/template/template.html")


# contour example
source("d3Dev.R")
dev = d3Device(file = "../../foo.js")
     line.list <- contourLines(x, y, volcano)
     plot(x = 0, y = 0, type = "n", xlim = rx, ylim = ry, xlab = "", ylab = "")
     u <- par("usr")

     rect(u[1], u[3], u[2], u[4], col = tcol[8], border = "red")
     contour(x, y, volcano, col = tcol[2], lty = "solid", add = TRUE,
                  vfont = c("sans serif", "plain"))
     templines <- function(clines) {
       lines(clines[[2]], clines[[3]])
     }
     invisible(lapply(line.list, templines))
dev.off()


source("d3Dev.R")
dev = d3Device(file = "../../foo.js")
library(igraph)
plot( graph.tree(10, 2), vertex.size = 32)
dev.off()

source("d3Dev.R")
dev = d3Device(file = "../../foo.js")
par(mfrow = c(1, 2))
library(igraph)
plot( graph.tree(10, 2), vertex.size = 32)
library(maps)
map('usa')
dev.off()





###############
# Not behaving yet.
#


source("d3Dev.R")
dev = d3Device(file = "../../foo.js")
     x <- y <- seq(-4*pi, 4*pi, len = 27)
     r <- sqrt(outer(x^2, y^2, "+"))
     image(z = z <- cos(r^2)*exp(-r/6), col  = gray((0:32)/32))
#     image(t(volcano)[ncol(volcano):1,])
dev.off()


## The next two use grid.  Ternary has coordinates outside of our box.

source("d3Dev.R")
library(lattice)
dev = d3Device(file = "../../foo.js")
xyplot(mpg ~ wt, mtcars, group = gear)
#xyplot(mpg ~ wt | cyl, mtcars, group = gear)
dev.off()



source("d3Dev.R")
library(vcd)
dev = d3Device(file = "../../foo.js")
   data("Hitters")
     colors <- c("black","red","green","blue","red","black","blue")
     pch <- substr(levels(Hitters$Positions), 1, 1)
     ternaryplot(
       Hitters[,2:4],
       pch = as.character(Hitters$Positions),
       col = colors[as.numeric(Hitters$Positions)],
       main = "Baseball Hitters Data"
     )
     grid_legend(0.8, 0.9, pch, colors, levels(Hitters$Positions),
       title = "POSITION(S)")
dev.off()

