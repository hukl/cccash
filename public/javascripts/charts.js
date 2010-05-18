var Chart = function(chart_type, title, id, data, size) {
  var that = this;
  var chart;

  switch(chart_type) {
    case "line":
      chart = new Bluff.Line(id, size);
      chart.title_font_size = 16;
      chart.legend_font_size = 10;
      chart.marker_font_size = 10;
      chart.line_width = 2;
      chart.dot_radius = 3;
      chart.theme_keynote();
      break;
    case "miniline":
      chart = new Bluff.Line(id, size);
      chart.title_font_size = 16;
      chart.legend_font_size = 10;
      chart.marker_font_size = 10;
      
      chart.top_margin    = 10;
      chart.bottom_margin = -20;
      chart.left_margin   = -30;
      chart.right_margin  = 10;
      chart.title_margin  = 0;
      chart.legend_margin = 0;
      
      chart.line_width = 1;
      chart.hide_dots = true
      chart.hide_title = true;
      chart.hide_legend = true;
      chart.theme_37signals();
      break;

    case "stackedbar":
      chart = new Bluff.StackedBar(id, size);
      chart.theme_keynote();
      break;
    case "pie":
      chart = new Bluff.Pie(id, size);
      chart.theme_keynote();
  }

  // Add styling
  chart.title = title;
  chart.tooltips = true;

  // Add data and labels
  chart.x_axis_label = data.x_axis;
  chart.y_axis_label = data.y_axis;
  chart.labels = data.labels;
  
  $H(data.series).each(function(pair) {
    chart.data(pair.key, pair.value);
  });

  chart.draw();

  return that;
}

