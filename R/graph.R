d3Graph =
  #
  #
  # @param the data for the graph
  # @out a character vector that specifies where the HTML document is written.
  #       if this has two elements, the second is the name of the file to which the JSON representation of the
  #       graph data (nodes and edges/links). If this parameter is not specified, the HTML document
  #       is returned with the code and data inlined.
  # @htmlTemplate the file containing the HTML code into which we will add the JS data and code or references to their files.
  # @jsTemplate the name of the file containing the JS code or the code itself, identified as such as I(code).

  #
  # @example load(system.file("examples", "callGraph.rda", package = "RD3Device"))
  #          browseURL(d3Graph(callGraph, tempfile(), "../template/graph.html", "../JavaScript/graph.js"))
  #
  #
function(data, out = character(),
         htmlTemplate = system.file("template", "graph.html", package = "RD3Device"),
         jsTemplate = system.file("JavaScript", "graph.js", package = "RD3Device"),
         inline = length(out) < 2,
         d3 = "http://d3js.org/d3.v3.min.js",
         varName = "graph")
{

  # Coerce the data to the appropriate form. Later we'll have classes and methods.
  createDocument(data, out, htmlTemplate, jsTemplate, inline, d3, varName)   
}

setD3Source =
function(hdoc, d3)
{
  d3Node = getNodeSet(hdoc, "//script[@id = 'd3' or contains(@src, 'd3.js')]")
  if(length(d3Node))
     xmlAttrs(d3Node[[1]]) = c(src = d3)
  else
     newXMLNode("script", attrs = c(src = d3), parent = xmlRoot(hdoc)[["body"]])
}

addData =
  #
  # add data to the file either inlining it in a script node or by adding its src to a script node.
  #
  #
function(data, hdoc, out, varName)
{
  
  if(!is(data, "AsIs"))
    data = toJSON(data)


  dnode = getNodeSet(hdoc, "//script[@id = 'data']")
  dnode = if(length(dnode) == 0) 
             newXMLNode("script", parent = xmlRoot(hdoc)[["body"]], at = 1) # make certain comes before js code.
          else
             dnode[[1]]
  
  if(length(out) && !is.na(out)) {
    cat(paste("var", varName, "="),  data, ";", sep = "\n", file = out)
    xmlAttrs(dnode) = c(src = out)
  } else
    addChildren(dnode, sprintf("var %s =", varName), data, ";")

}

addCode =
function(hdoc, src, out, inline = length(out) && !is.na(out))
{
   if(!inline) {
     code = if(is(src, "AsIs")) src else readLines(src)
     cat(code, file = out, sep = "\n")
   }
  
   jnode = getNodeSet(hdoc, "//script[@id = 'js']")
   jnode = if(length(jnode) == 0)
              newXMLNode("script", parent = xmlRoot(hdoc)[["body"]])
           else
               jnode[[1]]

   if(inline || is(src, "AsIs")) 
      addChildren(jnode, paste(readLines(src), collapse = "\n"))
   else
      xmlAttrs(jnode) = c(src = src)
}
