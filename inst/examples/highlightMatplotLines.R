source("d3Dev.R")
dev = d3Device()
d = matrix(rnorm(30*101, seq(.1, length = 30, by = .1)), 101, 30)
matplot(t(d), type = "l")
dev.off()

code = dev$getCode()
calls = dev$getCalls()

# misses the first one if we just use calledFrom("lines", calls)
i = names(code) == "polyline" & calledFrom("plot.xy", calls)  


changeStrokeWidth =
function(code, sizes = c(mouseover = 4L, mouseout = 1L))
{
   sizes = as(sizes, "integer")
    # we are adding the mouseover and mouseout in one call. Could be 2.
   cmd = sprintf('el.on("%s", function() { d3.event.target.setAttribute("stroke-width", %d)}).on("%s", function() { d3.event.target.setAttribute("stroke-width", %d);});', names(sizes)[1], sizes[1], names(sizes)[2], sizes[2])
   c(code, cmd)
}

code[i] = lapply(code[i], changeStrokeWidth)


cat(unlist(code), file = "../../foo.js", sep = "\n")
