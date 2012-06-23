// Based on bullet chart, see:
// http://projects.instantcognition.com/protovis/bulletchart/

var width = 470,
    height = 50,
    margin = {top: 5, right: 40, bottom: 20, left: 80};

var titles      = [ "Gelb", "Gruen", "Orange", "Blau", "Rot", "Weiss" ];
var percentages = [0.15, 0.20, 0.25, 0.20, 0.10, 0.10];
var actual      = d3.select("body").selectAll("td");

var chart = bulletChart()
    .width(width - margin.right - margin.left)
    .height(height - margin.top - margin.bottom);

var vis = d3.select("#chart").selectAll("svg")
    .data(titles)
    .enter().append("svg")
    .attr("class", "balance")
    .attr("width", width)
    .attr("height", height)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    .call(chart);

var title = vis.append("g")
    .attr("text-anchor", "end")
    .attr("transform", "translate(-6," + (height - margin.top - margin.bottom) / 2 + ")");

title.append("text")
    .attr("class", "title")
    .text(function(d) { return d; });

title.append("text")
    .attr("class", "subtitle")
    .attr("dy", "1em")
    .text("boulders");


function bulletChart() {

  var reverse  = false,
      maximums = [ [21], [28], [35], [28], [14], [14] ],
      actuals  = [ [parseInt(actual[0][0].innerText)]
                 , [parseInt(actual[0][1].innerText)]
                 , [parseInt(actual[0][2].innerText)]
                 , [parseInt(actual[0][3].innerText)]
                 , [parseInt(actual[0][4].innerText)]
                 , [parseInt(actual[0][5].innerText)]
                 ],
      total_boulders =   parseInt(actuals[0]) + parseInt(actuals[1])
                       + parseInt(actuals[2]) + parseInt(actuals[3])
                       + parseInt(actuals[4]) + parseInt(actuals[5]),
      expecteds  = [ [0, total_boulders * percentages[0], 50]
                   , [0, total_boulders * percentages[1], 50]
                   , [0, total_boulders * percentages[2], 50]
                   , [0, total_boulders * percentages[3], 50]
                   , [0, total_boulders * percentages[4], 50]
                   , [0, total_boulders * percentages[5], 50]
                   ],
      width      = 380,
      height     = 30;

  // For each small multiple…
  function bullet(g) {
    g.each(function(d, i) {
      var expected_boulders = expecteds[i].slice().sort(d3.descending),
          boulder_actual    = actuals[i],
          max_boulders      = maximums[i],
          g = d3.select(this);

      // Compute the new x-scale.
      var x1 = d3.scale.linear()
          .domain([0, 50])
          .range(reverse ? [width, 0] : [0, width]);

      // Retrieve the old x-scale, if this is an update.
      var x0 = this.__chart__ || d3.scale.linear()
          .domain([0, Infinity])
          .range(x1.range());

      // Stash the new scale.
      this.__chart__ = x1;

      // Derive width-scales from the x-scales.
      var w0 = bulletWidth(x0),
          w1 = bulletWidth(x1);

      // Update the range rects.
      var range = g.selectAll("rect.range")
          .data(expected_boulders);

      range.enter().append("svg:rect")
          .attr("class", function(d, i) { return "range s" + i; })
          .attr("width", w0)
          .attr("height", height)
          .attr("x", reverse ? x0 : 0)
          .transition()
          .duration(0)
          .attr("width", w1)
          .attr("x", reverse ? x1 : 0);

      range.transition()
          .duration(0)
          .attr("x", reverse ? x1 : 0)
          .attr("width", w1)
          .attr("height", height);

      // Update the measure rects.
      var measure = g.selectAll("rect.measure")
          .data(boulder_actual);

      measure.enter().append("svg:rect")
          .attr("class", function(d, i) { return "measure s" + i; })
          .attr("width", w0)
          .attr("height", height / 3)
          .attr("x", reverse ? x0 : 0)
          .attr("y", height / 3)
          .transition()
          .duration(0)
          .attr("width", w1)
          .attr("x", reverse ? x1 : 0);

      measure.transition()
          .duration(0)
          .attr("width", w1)
          .attr("height", height / 3)
          .attr("x", reverse ? x1 : 0)
          .attr("y", height / 3);

      // Update the marker lines.
      var marker = g.selectAll("line.marker")
          .data(max_boulders);

      marker.enter().append("svg:line")
          .attr("class", "marker")
          .attr("x1", x0)
          .attr("x2", x0)
          .attr("y1", height / 6)
          .attr("y2", height * 5 / 6)
          .transition()
          .duration(0)
          .attr("x1", x1)
          .attr("x2", x1);

      marker.transition()
          .duration(0)
          .attr("x1", x1)
          .attr("x2", x1)
          .attr("y1", height / 6)
          .attr("y2", height * 5 / 6);

      // Compute the tick format.
      var format = x1.tickFormat(8);

      // Update the tick groups.
      var tick = g.selectAll("g.tick")
          .data(x1.ticks(8), function(d) {
            return this.textContent || format(d);
          });

      // Initialize the ticks with the old scale, x0.
      var tickEnter = tick.enter().append("svg:g")
          .attr("class", "tick")
          .attr("transform", bulletTranslate(x0))
          .style("opacity", 1e-6);

      tickEnter.append("svg:line")
          .attr("y1", height)
          .attr("y2", height * 7 / 6);

      tickEnter.append("svg:text")
          .attr("text-anchor", "middle")
          .attr("dy", "1em")
          .attr("y", height * 7 / 6)
          .text(format);

      // Transition the entering ticks to the new scale, x1.
      tickEnter.transition()
          .duration(0)
          .attr("transform", bulletTranslate(x1))
          .style("opacity", 1);

      // Transition the updating ticks to the new scale, x1.
      var tickUpdate = tick.transition()
          .duration(0)
          .attr("transform", bulletTranslate(x1))
          .style("opacity", 1);

      tickUpdate.select("line")
          .attr("y1", height)
          .attr("y2", height * 7 / 6);

      tickUpdate.select("text")
          .attr("y", height * 7 / 6);

      // Transition the exiting ticks to the new scale, x1.
      tick.exit().transition()
          .duration(0)
          .attr("transform", bulletTranslate(x1))
          .style("opacity", 1e-6)
          .remove();
    });
  }

  bullet.width = function(x) {
    width = x;
    return bullet;
  };

  bullet.height = function(x) {
    height = x;
    return bullet;
  };

  return bullet;
};

function bulletTranslate(x) {
  return function(d) {
    return "translate(" + x(d) + ",0)";
  };
}

function bulletWidth(x) {
  var x0 = x(0);
  return function(d) {
    return Math.abs(x(d) - x0);
  };
}
