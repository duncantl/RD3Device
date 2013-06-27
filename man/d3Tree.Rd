\name{d3Tree}
\alias{d3Tree}
\alias{d3Graph}
\title{Create a D3 tree or network display}
\description{
  These functions illustrate how we can create a display using
  D3's own display and layout classes. We do not use R's
  graphics engine for these displays, but use R to create
  the JavaScript code and pre-process the data.

  This is just an illustration and could be done better
  (e.g. make the JavaScript use a function rather than  a global
  variable and a script).
}
\usage{
d3Tree(data, out = character(),
       htmlTemplate = system.file("template", "tree.html", package = "RD3Device"),
       jsTemplate = system.file("JavaScript", "tree.js", package = "RD3Device"),
       inline = length(out) < 2,
       d3 = "http://d3js.org/d3.v3.min.js", varName = "treeData")
d3Graph(data, out = character(),
        htmlTemplate = system.file("template", "graph.html", package = "RD3Device"),
        jsTemplate = system.file("JavaScript", "graph.js", package = "RD3Device"),
        inline = length(out) < 2,
        d3 = "http://d3js.org/d3.v3.min.js",
        varName = "graph")

}
\arguments{
  \item{data}{the data in R used to create the plot.
   This serialized to JavaScript form as JSON content.}
  \item{out}{a character vector giving the name of the file to which the
   completed HTML document will be written. If this has two elements,
   the second is used as the file name to which the JavaScript content
   will be written.}
  \item{htmlTemplate}{the name of a file containing the HTML content
    which we modify to create the actual HTML document in which to
    display the D3 plot}
  \item{jsTemplate}{the name of a JavaScript file containing code that }
  \item{inline}{a logical value which indicates whether to inline the
    data and code into the HTML document, or whether to write them as a
    separate JavaScript file and reference that.}
  \item{d3}{the URL or local file name for the D3 library}
  \item{varName}{the name of the JavaScript variable which is used to
    assign the data for the plot}
}
\details{
These mimic  and adapt examples from the D3 gallery and blog posts
}
\value{
  If \code{out} is empty, the parsed HTML tree is returned.
  Otherwise, the name of the file to which the document was written is returned.
}
%\references{}
\author{
Duncan Temple Lang
}

\seealso{
\code{\link{addToHTMLTemplate}}
}
\examples{
tt = structure(list(name = "a.xml", children = list(structure(list(
name = "b", children = structure(list(), class = "AsIs")), .Names = c("name", 
"children")), structure(list(name = "c", children = list(structure(list(
    name = "xyz", children = list(structure(list(name = "w", 
        children = structure(list(), class = "AsIs")), .Names = c("name", 
    "children")))), .Names = c("name", "children")))), .Names = c("name", 
"children")))), .Names = c("name", "children"))


d3Tree(tt, "sampleTree.html")


load(system.file("examples", "callGraph.rda", package = "RD3Device"))
d3Graph(callGraph, "sampleGraph.html")
}
\keyword{graphics}
\keyword{programming}

