require 'sinatra'
require 'lens_protocol'

get '/' do
  files_and_messages = Dir['examples/oma/*.oma'].map do |file|
    [File.basename(file), LensProtocol::OMA.parse(File.read(file))]
  end

  erb :index, locals: {files_and_messages: files_and_messages}
end
