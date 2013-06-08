# Comes from RClangSimple/inst/explorations
library(RCIndex)
f = sprintf("%s/../src/main/memory.c", R.home())
#tu = createTU(f, args = "-DHAVE_CONFIG_H", includes = c(sprintf("%s/../src/include", R.home()), sprintf("%s/include", R.home())))
r = getRoutines(f, TRUE, args = "-DHAVE_CONFIG_H", includes = c(sprintf("%s/../src/include", R.home()), sprintf("%s/include", R.home())))

kalls = lapply(r, findCalls)
withinFileCalls = lapply(kalls, intersect, names(r))


# Now get the call graph in the correct form for D3.

links = lapply(seq(along = withinFileCalls),
               function(i) {
                 to = withinFileCalls[[i]]
                 if(length(to) == 0)
                   return(NULL)

                 to = match(to, names(withinFileCalls)) - 1L
                 lapply(to, function(j) list(source = i-1L, target = j))
               })


graph = list(nodes = structure(lapply(names(withinFileCalls), function(x) list(name = x)), names = NULL),
             links = unlist(links, recursive = FALSE))

# Insert into our template document
hdoc = htmlParse("../template/graph.html")
sc = getNodeSet(hdoc, "//script")
node = newXMLNode("script",
                    "var graph =",  toJSON(graph), ";")
invisible(addSibling(sc[[length(sc)]], node, after = FALSE))

saveXML(hdoc, "callGraph1.html")

cat("var graph = ", toJSON(graph), ";", sep = "\n", file = "callGraph.js")


