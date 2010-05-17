var Chart = function(chart_type, title, id, data, size) {
  var that = this;
  var chart;

  switch(chart_type) {
    case "line":
      chart = new Bluff.Line(id, size);
      break;
    case "stackedbar":
      chart = new Bluff.StackedBar(id, size);
      break;
    case "pie":
      chart = new Bluff.Pie(id, size);
  }

  // Add styling
  chart.title = title;
  chart.theme_keynote();
  chart.title_font_size = 16;
  chart.legend_font_size = 10;
  chart.marker_font_size = 12;
  chart.line_width = 2;

  // Add data and labels
  //chart.x-axis-label = data.x_axis;
  //chart.y-axis-label = data.y_axis;
  chart.labels = data.labels;
  $H(data.series).each(function(pair) {
    chart.data(pair.key, pair.value);
  });

  chart.draw();

  return that;
}

