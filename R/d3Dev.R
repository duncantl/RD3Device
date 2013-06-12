# Helpful links.
# http://www.dashingd3js.com/table-of-contents
# http://www.dashingd3js.com/svg-basic-shapes-and-d3js
library(RGraphicsDevice) #XXXX go when we install the package.
library(RJSONIO)

d3Device =
function(dim = c(800, 600), file = character(), svgVarName = "svg", div = "svg",
          plotVarName = sprintf("_%s", svgVarName))
{

   # don't need activate/deactivate, locator, GEInitDevice, getEvent, size (when resized), mode
   #
   #  raster, path, cap
   #
   # need [done] polygon
   #  newPage, newFrameConfirm (no) , clip
   #
   #  ?textUTF8, strWidthUTF8
  
  dev = new("RDevDescMethods")
  dim = as.integer(dim)

  pages = list()
  curDivName = div[1]
  jsCode = makeInitCode(curDivName, dim, svgVarName)

  calls = list(sys.calls())

  addCode = function(cmd, type = NA, attrs = NULL) {
     if(!is.na(type))  {
       cmd[length(cmd)] = paste("el =", cmd[length(cmd)])
       cmd = c(cmd, sprintf("%s.%ss.push(el);", plotVarName, type))
     }

     if(length(attrs))
       attributes(cmd) = attrs

     
     jsCode[[length(jsCode) + 1L]] <<- cmd # c(jsCode, cmd)
     if(!is.na(type)) 
       names(jsCode)[length(jsCode)] <<- type

     k = sys.calls()
     calls[[ length(calls) + 1L ]] <<-  k[1:(length(k) - 2)] # get rid of this call and the one above it
                                                         # which are the device function calls.
   }
    
  
  dev@line =  function(x1, y1, x2, y2, gcontext, dev) {
     vals = c(x1 = x1, y1 = y1, x2 = x2, y2 = y2)
     graphics = setGraphics(gcontext)     
     cmd = sprintf('%s.append("line")%s.%s;', svgVarName, makeAttrs(vals), graphics)
     addCode(cmd, "line", list(x1 = x1, y1 = y1, x2 = x2, y2 = y2))
  }
  
  dev@circle =  function(x, y, r, gcontext, dev) {
     vals =  c(r = r, cx = x, cy = y)
     graphics = setGraphics(gcontext)
     cmd = sprintf('%s.append("circle")%s.%s;', svgVarName, makeAttrs(vals), graphics)
     addCode(cmd, "circle", list(x = x, y = y, r = r))
  }

  dev@rect = function(x, y, x1, y1, gcontext, dev) {
     vals =  c(x = min(x, x1), y = min(y, y1), width = abs(x - x1), height = abs(y1 - y))
     cmd = sprintf('%s.append("rect")%s.%s;', svgVarName, makeAttrs(vals), setGraphics(gcontext))
     addCode(cmd, "rectangle", list(x = x, y = y, x1 = x1, y1 = y1))
  }

  dev@text = function(x, y, str, rot, hadj, gcontext, dev) {
     vals =  c(x = x, y = y)
     xtra = c()
     
         #  http://stackoverflow.com/questions/11252753/rotate-x-axis-text-in-d3
     if(rot != 0) 
       xtra = c(xtra, sprintf('.attr("transform", function(d) { return "rotate(%f %f,%f)" } )', 360 - rot, x, y))

     cmd = sprintf('%s.append("text")%s.%s.text("%s")%s;',
                    svgVarName,
                    makeAttrs(vals),
                    setGraphics(gcontext),
                    str,
                    if(length(xtra))
                       paste(xtra, collapse = ".")
                    else
                       "")

     addCode(cmd, "text", list(text = str, x = x, y = y, rot = rot))
  }

  dev@strWidth = function(str, gcontext, dev) {
    nchar(str) *  gcontext $ ps * gcontext$cex
  }

  dev@newPage = function(gcontext, dev) {
    pages[[ curDivName ]]  <<- jsCode 
    curDivName <<- if(length(div) == 1 || length(curDivName) <= length(pages))
                     sprintf("%s%d", div[1], length(pages))
                   else
                     div[length(pages) + 1]
    jsCode = makeInitCode(curDivName, dim, svgVarName)
  }  

  ctr = c(polyline = 0L)

   # polyline is local here so polygon can invoke it.  
  polyline = dev@polyline = function(n, x, y, gcontext, dev, polygon = FALSE) {
    x = x[1:n]
    y = y[1:n]
    data = toJSONRows(x, y)

       # use unique names. Keep a counter.
    ctr["polyline"] <<- count <- ctr["polyline"] + 1L
    graphics = setGraphics(gcontext)
    cmd = sprintf('%s.append("path").%s.attr("d", polylineFunction%d(polylineData%d));',
                       svgVarName, graphics, count, count)


    cmd = c(sprintf('var polylineFunction%d = d3.svg.line().x(function(d) { return d.x; }).y(function(d) { return d.y; }).interpolate("linear");', count),
            sprintf('var polylineData%d = %s;', count, data),
            cmd)
    
    addCode(cmd, if(polygon) "polygon" else "polyline")
  }

  dev@polygon = function(n, x, y, gcontext, dev) {
    polyline(n, x, y, gcontext, dev, TRUE)
  }
  
  dev@initDevice = function(dev) {
    dev$ipr = rep(1/72.27, 2)
    dev$cra = rep(c(6, 13)/12) * 10
    dev$startps = 10
    dev$startfont = 1    
    dev$canClip = FALSE # XXXX TRUE
    dev$canChangeGamma = TRUE
    dev$startgamma = 1 
    dev$startcol = as("black", "RGBInt")
  }

  dev@close = function(dev) {
    if(length(file))
       cat(unlist(jsCode), file = file, sep = "\n")
  }

  idev = graphicsDevice(dev, dim, col = "black", fill = "transparent", ps = 10)

  list(dev = idev, device = dev,
       getCode = function() jsCode,
       getCalls = function() structure(calls, names = names(jsCode)),
       getJSInfo = function()
                     c(svgVarName = svgVarName,  plotVarName = plotVarName, divName = div)
      )
}




makeAttrs =
function(vals) {
   attrs = sprintf('.attr("%s", %f)', names(vals), as.numeric(vals))
   paste(attrs, collapse = "")
}

convertColor =
function(col)  {
  if(isTransparent(col))
    "none"
  else {
    vals = col2rgb(as(col, "RGB"))
    sprintf("rgb(%s)", paste(vals, collapse = ", "))
  }
}
setGraphics = function(gc) {
   tmp = structure(gc[ c("fill", "col") ], names = c("fill", "stroke"))
   paste(sprintf('attr("%s", "%s")', names(tmp), sapply(tmp, convertColor)), collapse = ".")
}

toJSONRows =
function(x, y) 
    toJSON(mapply(function(a, b) list(x = a, y = b), x, y, SIMPLIFY = FALSE))


makeInitCode =
function(div, dim, svgVarName = div, plotVarName = sprintf("_%s", svgVarName))
{
  init = sprintf('var %s = d3.select("#%s")\n\t.append("svg").attr("width", %d).attr("height", %d);',
                        svgVarName, div, dim[1], dim[2])
 list(init = c(init, "",
          # .attr("font-family", "sans-serif") .style("fill", "red")
    'svg.style("stroke", "black").style("stroke-width", 1);',
    "",
    sprintf("var %s = new makePlot(%s);", plotVarName, svgVarName),
    "",
    "var el;", ""))
}
  
