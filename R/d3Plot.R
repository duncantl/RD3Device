d3Plot =
  #
  # An atomic version that allows us to 
  # draw a plot with one or more expressions
  # 
function(expr, file = character())
{
  dev = d3Device( file = file)
  on.exit(dev.off())
  
  expr
  
  invisible(dev)
}
