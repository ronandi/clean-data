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

    file_suffix = "_clean.csv"
    fileOutput = outputCsvLines.join
    output_file_name = if filename.include?(".")
                         filename[0..filename.rindex(".")-1] + file_suffix
                       else
                         filename + file_suffix
                       end
    attachment output_file_name
    content_type "application/octet-stream"
    fileOutput

  end

end

def row_is_good row
  blocked_words = ["do not contact", "leave me alone", "take me off", "remove", "stop texting", "do not call", "do not text",
                   "already", "early voted", "voted early", "i voted", "wrong person", "wrong number", "fuck", "hell", "asshole",
                   "shit", "ass", "can't vote", "cannot vote", "don't vote"]
  blocked_start_words = ["stop", "quit", "no", "dont", "don't"]
  return false if row.field('Inbound/outbound').include?("outbound")
  return false if row.field('Message').to_s.empty?
  return false if blocked_start_words.any? { |phrase| row.field('Message').split.first.downcase == phrase }
  return false if blocked_words.any? { |phrase| row.field('Message').split.first.downcase.include? phrase }

  return true
end
