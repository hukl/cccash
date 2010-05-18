module StatisticsHelper
  def line_chart(title, id, data, size)
    javascript_tag do
      "document.observe('dom:loaded', function() {
        new Chart('line', '#{title}', '#{id}', #{data.to_json}, '#{size}');
      });"
    end
  end

  def mini_line_chart(title, id, data, size)
    javascript_tag do
      "document.observe('dom:loaded', function() {
        new Chart('miniline', '#{title}', '#{id}', #{data.to_json}, '#{size}');
      });"
    end
  end


  def stacked_bar_chart(title, id, data, size)
    javascript_tag do
      "document.observe('dom:loaded', function() {
        new Chart('stackedbar', '#{title}', '#{id}', #{data.to_json}, '#{size}');
      });"
    end
  end
  
  def pie_chart(title, id, data, size)
    javascript_tag do
      "document.observe('dom:loaded', function() {
        new Chart('pie', '#{title}', '#{id}', #{data.to_json}, '#{size}');
      });"
    end
  end
end
