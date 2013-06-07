source("d3Dev.R")
library(maps)
dev = d3Device(file = "../../foo.js")
# need fill to get the names in m and the polygons to return correctly
m = map('county', 'california', fill = TRUE, col = "white")
dev.off()

code = dev$getCode()
calls = dev$getCalls()

m$names = gsub("^california,", "", m$names)

i = names(code) == "polygon"
code[i] = mapply(function(x, id)
                   c(x, sprintf('el.append("svg:title").text("%s");', id)),
                 code[i], m$names, SIMPLIFY = FALSE)

# Change the stroke-width/border to 2 pixels when mouseover.
code[i] = mapply(function(x, id)
                       # we are adding the mouseover and mouseout in one call. Could be 2.
                   c(x, sprintf('el.on("mouseover", function() { d3.event.target.setAttribute("stroke-width", 2)}).on("mouseout", function() { d3.event.target.setAttribute("stroke-width", 1);});')),
                 code[i], m$names, SIMPLIFY = FALSE)

# Add a .on("click", ) to call alert() to show it works.
code[i] = mapply(function(x, id)
                   c(x, sprintf('el.on("click", function() { alert("%s");});', id)),
                 code[i], m$names, SIMPLIFY = FALSE)

cat(unlist(code), file = "../../foo.js", sep = "\n")
