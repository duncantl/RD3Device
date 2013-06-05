# Helpful links.
# http://www.dashingd3js.com/table-of-contents
# http://www.dashingd3js.com/svg-basic-shapes-and-d3js
library(RGraphicsDevice)
library(RJSONIO)


d3Device =
function(dim = c(800, 600), file = character(), svgVarName = "svg", div = "svg")
{

   # don't need activate/deactivate, locator, GEInitDevice, getEvent
   #
   # need polygon
   #  newPage, newFrameConfirm, size(?)
   #
   #  ?textUTF8, strWidthUTF8, state?
  
  dev = new("RDevDescMethods")
  dim = as.integer(dim)

  init = sprintf('var %s = d3.select("#%s")\n\t.append("svg").attr("width", %d).attr("height", %d);',
                        svgVarName, div, dim[1], dim[2])
  jsCode = c(init, "",
             'svg.style("stroke", "black").style("stroke-width", 1).attr("font-family", "sans-serif");', "") # .style("fill", "red")

  makeAttrs = function(vals) {
     attrs = sprintf('.attr("%s", %f)', names(vals), as.numeric(vals))
     paste(attrs, collapse = "")
  }

  convertColor = function(col)  {
    if(isTransparent(col))
      "none"
    else
      as(col, "RGB")
  }
  setGraphics = function(gc) {
     tmp = gc[ c("fill", "col") ]
     paste(sprintf('attr("%s", "%s")', names(tmp), sapply(tmp, convertColor)), collapse = ".")
  }
  
  dev@line =  function(x1, y1, x2, y2, gcontext, dev) {
     vals = c(x1 = x1, y1 = y1, x2 = x2, y2 = y2)
     cmd = sprintf('%s.append("line")%s;', svgVarName, makeAttrs(vals))
     jsCode <<- c(jsCode, cmd)
  }
  dev@circle =  function(x, y, r, gcontext, dev) {
     vals =  c(r = r, cx = x, cy = y)
     cmd = sprintf('%s.append("circle")%s;', svgVarName, makeAttrs(vals))
     jsCode <<- c(jsCode, cmd)
  }

  dev@rect = function(x, y, w, h, gcontext, dev) {
     vals =  c(x = x, y = y, width = w, height = h)
     cmd = sprintf('%s.append("rect")%s;', svgVarName, makeAttrs(vals))
     jsCode <<- c(jsCode, cmd)
  }


  dev@text = function(x, y, str, rot, hadj, gcontext, dev) {
     vals =  c(x = x, y = y)
     xtra = c()

    #  http://stackoverflow.com/questions/11252753/rotate-x-axis-text-in-d3
     if(rot != 0) 
       xtra = c(xtra, sprintf('.attr("transform", function(d) { return "rotate(%f %f,%f)" } )', 360 - rot, x, y))

     cmd = sprintf('%s.append("text")%s.text("%s")%s;',
                    svgVarName,
                    makeAttrs(vals),
                    str,
                    if(length(xtra))
                       paste(xtra, collapse = ".")
                    else
                       "")
     
     jsCode <<- c(jsCode, cmd)
  }

  dev@strWidth = function(str, gcontext, dev) {
    nchar(str) *  min(10, gcontext $ ps) * gcontext$cex
  }

  ctr = c(polyline = 0L)

  toJSONRows = function(x, y) 
    toJSON(mapply(function(a, b) list(x = a, y = b), x, y, SIMPLIFY = FALSE))
  
  polyline = dev@polyline = function(n, x, y, gcontext, dev, polygon = FALSE) {
    x = x[1:n]
    y = y[1:n]
    data = toJSONRows(x, y)

       # use unique names. Keep a counter.
    ctr["polyline"] <<- count <- ctr["polyline"] + 1L
    graphics = setGraphics(gcontext)
    cmd = sprintf('%s.append("path").%s.attr("d", polylineFunction%d(polylineData%d));',
                       svgVarName, graphics, count, count)
    
    jsCode <<- c(jsCode,
                 sprintf('var polylineFunction%d = d3.svg.line().x(function(d) { return d.x; }).y(function(d) { return d.y; }).interpolate("linear");', count),
                 sprintf('var polylineData%d = %s;', count, data),
                 cmd)

  }

  dev@polygon = function(n, x, y, gcontext, dev) {
    polyline(n, x, y, gcontext, dev, TRUE)
  }
  
  dev@initDevice = function(dev) {
    dev$ipr = rep(1/72.27, 2)
    dev$cra = rep(c(6, 13)/12) * 10
    dev$startps = 10
    dev$canClip = TRUE
    dev$canChangeGamma = TRUE
    dev$startgamma = 1 
    dev$startcol = as("red", "RGBInt")
  }

  dev@close = function(dev) {
    if(length(file))
       cat(jsCode, file = file, sep = "\n")
    else
      cat("can't get at the code I created!")
  }

  idev = graphicsDevice(dev, dim, col = "red", fill = "transparent", ps = 10)

  list(dev = idev, device = dev)
}
