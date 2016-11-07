require 'sinatra'
require 'csv'

get '/' do
  erb :index
end

post '/submit' do
  if params[:file] && params[:file][:filename]
    filename = params[:file][:filename]
    file = params[:file][:tempfile]

    csv = CSV.parse(file, :headers => true)

    outputCsvLines = Array.new
    outputCsvLines << csv.headers.join(",")

    csv.each do |row|
      outputCsvLines << row if row_is_good(row)
    end

    fileOutput = outputCsvLines.join("\n")
    content_type :txt
    fileOutput

  end

end

def row_is_good row
  return false if row.field('Inbound/outbound').include?("outbound")

  return true
end
