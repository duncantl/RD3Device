      // Create a svg canvas
      var vis = d3.select("#tree").append("svg:svg")
      .attr("width", 800)
      .attr("height", 800)
      .append("svg:g")
      .attr("transform", "translate(40, 0)"); // shift everything to the right
 
      // Create a tree "canvas"
      var tree = d3.layout.tree()
    .size([800,600]);
 
      var diagonal = d3.svg.diagonal()
      // change x and y (for the left to right tree)
//      .projection(function(d) { return [d.y, d.x]; });
 
      // Preparing the data for the tree layout, convert data into an array of nodes
      var nodes = tree.nodes(treeData);
      // Create an array with all the links
      var links = tree.links(nodes);
 
      var link = vis.selectAll("pathlink")
      .data(links)
      .enter().append("svg:path")
      .attr("class", "link")
      .attr("d", diagonal)
 
      var node = vis.selectAll("g.node")
      .data(nodes)
      .enter().append("svg:g")
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
  //    .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; })
 
      // Add the dot at every node
      node.append("svg:circle")
      .attr("r", 3.5)
      .attr("svg:title", function(d) { return(d.name); });
 
      // place the name atribute left or right depending if children
 if(false)
      node.append("svg:text")
      .attr("dx", function(d) { return d.children ? 300 : 300; })
      .attr("dy", 20)
      .attr("text-anchor", function(d) { return d.children ? "end" : "start"; })
      .text(function(d) { return d.name; })
 