require 'sinatra'
require 'lens_protocol'

get '/' do
  files_and_messages = Dir['examples/oma/*.oma'].map do |file|
    [File.basename(file), LensProtocol::OMA::Parser.parse_file(file)]
  end

  erb :index, locals: {files_and_messages: files_and_messages}
end
