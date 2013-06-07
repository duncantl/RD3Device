RD3Device
=========

A graphics device for R that outputs D3 code to display the R plot.

The idea here is to continue to use R's graphical functionality and
graphics engine to create plots, but render them via JavaScript
code that uses D3.js.  We could also use the Raphael graphics
device the Gabe Becker developed.

The idea in this package, at present, is not to provide
R functions that create the particular plots provided by D3
itself.  People are writing wrappers to those.
Instead, this uses R's graphics functionality to create
regular R plots and render them using D3.

The graphics device in R creates the JavaScript code for the D3
display.  Before we write this code to a file, we can post-process it
and make the elements interactive, animated, etc.  Mapping the D3 code
elements to the elements in the R display is not entirely
trivial. However, the device collects information about the types of
the D3 code elements, aspects of their content (e.g. the string for a
text node, the x, y, radius for a circle, ...)  and also the call
stack that was in effect when each element was drawn.  This allows us
to reasonably easily and accurately identify the elements and the
corresponding D3 code element, assuming we know the basic contents of
the plot and how the are created.


There are better ways to create some types of interactive plots.
rCharts based on Polycharts.JS shows a lot of promise. googleVis gives
us access to certain types of displays that we don't have in other JS
libraries or R. 

The point of this is that it is quite simple to develop and gives us
some facilities for continuing to use R graphics functionality to
create interactive, animated plots.

We can also create the SVG ourselves, either directly with our own
graphics device or via, e.g., gridSVG, or with the svg() device in R.



