library(RD3Device)

showPlotElements =
  # @example showPlotElements({plot(1:10); abline(v = c(2, 4, 6)); text(2, 8, "Foo")}, "showPlot.html")
  # showPlotElements({library(maps); map('usa')}, "showPlot.html")
function(expr, out, dev = d3Device(), ...)
{
  dev # force dev 

  expr # evaluate the expression now that the device is open.

  dev.off()

    # now process the code & calls to put the tooltips on the graphical elements.
  calls = dev$getCalls()
  code = dev$getCode()

  i = 2:length(code)
  code[i] = mapply(makeTooltip, code[i], calls[i], names(code)[i])

  RD3Device:::addToHTMLTemplate(code, out, ...)
}


makeTooltip =
function(code, call, grType)
{
   txt = c(sprintf("(%s)", grType),
           paste(rev(sapply(call, function(x) x[[1]])), collapse = "->"),
           sapply(call, deparse))

   txt = paste(txt, collapse = "\\r\\n")
   txt = gsub('"', "", txt)
   c(code, sprintf('el.append("svg:title").text("%s");', txt))
}
