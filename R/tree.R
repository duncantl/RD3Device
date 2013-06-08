d3Tree =
  #
  #
  #
  # a = list(name = "a.xml", children = list( list(name = "b", children = list()), list(name = "c", children = list(list(name = "xyz", children = list(list(name = "w", children = list())))))))
  # 
  #
  #
  #
function(data, out = character(),
         htmlTemplate = system.file("template", "tree.html", package = "RD3Device"),
         jsTemplate = system.file("JavaScript", "tree.js", package = "RD3Device"),
         inline = length(out) < 2,
         d3 = "http://d3js.org/d3.v3.min.js",
         varName = "treeData")
{
   # Coerce the data to the appropriate form. Later we'll have classes and methods.
  
  createDocument(data, out, htmlTemplate, jsTemplate, inline, d3, varName) 
}


createDocument =
function(data, out, htmlTemplate, jsTemplate, inline = length(out) < 2, d3 = "http://d3js.org/d3.v3.min.js", varName = "data")
{
  hdoc = htmlParse(htmlTemplate, FALSE)

  setD3Source(hdoc, d3)
  
  addData(data, hdoc, out[3], varName)
  addCode(hdoc, jsTemplate, out[2], inline)
  
  if(length(out) && !is.na(out[1]))
    saveXML(hdoc, out[1])
  else
    invisible(hdoc)  
}
