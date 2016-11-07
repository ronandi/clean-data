require 'sinatra'
require 'csv'

get '/' do
  erb :index
end

post 'submit' do
  if params[:file] && params[:file][:filename]
    filename = params[:file][:filename]
    file = params[:file][:tempfile]

    csv = CSV.parse(file, :headers => true)

    outputCsvLines = Array.new

    csv.each do |row|
      outputCsvLines << row if (rowIsGood(row))
    end

  end

end

def row_is_good(row)
  if (row.field('Inbound/outbound').include?("outbound"))
      return false
  end

  return true
end
