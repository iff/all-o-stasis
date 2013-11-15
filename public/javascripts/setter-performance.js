// Shows the performance of a setter given a table containing
// dates of set boulders.

var vals   = d3.select("body").selectAll("td");
var values = [];
for( var i = 0; i < vals[0].length; i++ ) {
    date_val = vals[0][i].innerText;
    date  = new Date(date_val);
    month = date.getMonth() + 1;
    year  = date.getYear()  + 1900;
    d = { "Date"    : date_val,
          "Month"   : [month, year].join("/"),
          "Boulders": 1 };
    values.push(d);
}

var svg = dimple.newSvg("#setterPerformance", 590, 300);
var myChart = new dimple.chart(svg, values);
myChart.setBounds(60, 30, 500, 200);
var x = myChart.addCategoryAxis("x", "Month")
myChart.addMeasureAxis("y", "Boulders");

x.addOrderRule("Date");

myChart.addColorAxis("Boulders", ["green", "yellow", "red"]);

var lines = myChart.addSeries(null, dimple.plot.line);
lines.lineWeight = 5;
lines.lineMarkers = true;

myChart.draw();
