#
# add generated code to an HTML document.
#

addToHTMLTemplate =
function(code, outfile = character(),
         html = system.file("template", "template.html", package = "RD3Device"),
         div = "svg", isFile = length(code) == 1 && file.exists(code))
{
   doc = htmlParse(html)
   divNode = getNodeSet(doc, sprintf("//div[@id = '%s']", div))
   if(length(divNode) == 0)
      divNode = newXMLNode("div", attrs = c(id = div), parent = getNodeSet(doc, "//body"))
   else
      divNode = divNode[[1]]


   if(isFile)
     newXMLNode("script", attrs = c(src = code), parent = xmlParent(divNode))     
   else
     newXMLNode("script", code, parent = xmlParent(divNode))

   if(length(outfile))
     saveXML(doc, outfile)
   else
     doc
}
