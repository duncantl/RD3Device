#
# add generated code to an HTML document.
#

addToHTMLTemplate =
function(code, outfile = character(),
         supportCode = system.file("JavaScript", "Plot.js", package = "RD3Device"),
         html = system.file("template", "template.html", package = "RD3Device"),
         css = character(),
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
     newXMLNode("script", paste(unlist(code), collapse = "\n"), parent = xmlParent(divNode))

   if(length(supportCode)) {
     h = getNodeSet(doc, "//head")
     txt = c("", readLines(supportCode), "")
     newXMLNode("script", paste(txt, collapse = "\n"), parent = h[[1]])
   }

   if(length(css)) {
      if(!is(css, "AsIs"))
        css = readLines(css)

      css = paste(css, collapse = "\n")
      h = getNodeSet(doc, "//head")[[1]]
      newXMLNode(h, css, parent = h)
   }

   if(length(outfile))
     saveXML(doc, outfile)
   else
     doc
}
