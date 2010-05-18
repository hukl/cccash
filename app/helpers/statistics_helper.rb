module StatisticsHelper
  
  SECS = (26..30).to_a.collect {|i| i.to_s }
  DAYS = { '26' => 'Tag 0', '27' => 'Tag 1', '28' => 'Tag 2', '29' => 'Tag 3', '30' => 'Tag 4'}
  def time_table(tickets)
    html = ''
    content_tag('table',
       content_tag('tr',
          content_tag('th', "Ticket") +
          SECS.collect {|d| content_tag('th', DAYS[d]) }.join('')
       ) +
       tickets.map do |t|
         m = t.sales_grouped_by_day
         content_tag('tr',
            content_tag('td', t.name) +         
            SECS.collect {|d| content_tag('td', yield(m[d]))}.join('')
         )
       end.join('')
    )
  end
  
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
