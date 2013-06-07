calledFrom =
  #
  # query the system calls when creating the plot
  # to determine which calls were calls to cmd
  # (either a string or a vector of strings)
  #
function(cmd, calls)
{
  sapply(calls, function(x) any(cmd %in% getCalleeNames(x)))
}

getTextCode =
function(code, str, asCode = FALSE)
{
  txt = sapply(code, function(x) attr(x, "text"))
  i = which(txt == str)

  n = length(i)
  if(n == 0)
     return(NULL)
  
  if(asValue)
    if(n == 1) code[[i]] else code[i]
  else
    i
}

getCalleeNames =
function(code)
{  
  sapply(code, function(x) if(is.function(x[[1]])) "" else as.character(x[[1]]))  
}


findAxesLines =
function(code, calls)
{
  i = names(code) == "line"
  w =  sapply(calls[i], function(code) any("axis" == getCalleeNames(code)))
  which(i)[w]
}
