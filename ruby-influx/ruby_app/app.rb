require 'sinatra'
require 'sinatra/base'
require 'json'
require 'thin'
require 'influxdb'

set :bind, '0.0.0.0'

before do
  request.path_info.sub! %r{/$}, ''
  @metric = InfluxData.new
end


not_found do
  @metric.check_statistics(request.env["REQUEST_METHOD"], request.url, response.status)
  '404'
end

get '/' do
  @metric.check_statistics(request.env["REQUEST_METHOD"], request.url, response.status)
  'hello world'
end

get '/status' do
  @metric.check_statistics(request.env["REQUEST_METHOD"], request.url, response.status)
  content_type :json
  {
    status: 200
  }.to_json
end

class InfluxData
  def initialize
    @influxdb = InfluxDB::Client.new 'influxdb',
      username: 'root',
      password: 'root',
      host: 'influxdb',
      port: 8086
  end

  def check_statistics(message, data, tag)
    data = {
      tags: { message.to_s => tag },
      timestamp: Time.now.to_i,
      values: { speed: rand(20) }
    }
    write_data(data)
  end

  def write_data(data)
    @influxdb.write_point("ruby_app", data)
  end
end
