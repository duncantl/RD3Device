d3Plot =
function(expr, file = character())
{
  dev = d3Device( file = file)
  on.exit(dev.off())
  
  expr
  
  invisible(dev)
}
