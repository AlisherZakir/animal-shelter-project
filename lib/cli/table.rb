class Table
  include CommandLineReporter
  def initialize(columns, data)
    @columns = columns
    @data = data
  end
  def render
    header title: 'The table', align: 'center', width: 60

    table border: true do
      row header: true, color: 'red'  do
        @columns.each do |column|
          column column, align: 'center'
        end
      end
      @data.each do |pet|
        row  do
          @columns.each do |column|
            column pet[column], align: 'center'
          end
        end
      end
    end
  end
end
