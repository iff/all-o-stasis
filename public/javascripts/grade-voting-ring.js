var width = 100,
    height = 100,
    radius = Math.min(width, height) / 2;

var vals   = d3.select("body").selectAll("td");
var values = [];
for( var i = 0; i < vals[0].length; i+=2 ) {
    d = { value: parseInt(vals[0][i].innerText),
          color: vals[0][i+1].innerText };
    values.push(d);
}

var arc = d3.svg.arc()
    .outerRadius(radius - 10)
    .innerRadius(radius - 30);

var pie = d3.layout.pie()
    .sort(null)
    .value(function(d) { return d.value; });

var root = d3.select("#chart")
  .append("svg")
    .attr("width", width)
    .attr("height", height)
  .append("g")
    .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")

var g = root.selectAll(".arc")
    .data(pie(values))
  .enter().append("g")
    .attr("class", "arc");

g.append("path")
    .attr("d", arc)
    .attr("class", function(d) { return d.data.color; });
