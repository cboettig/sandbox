require 'faraday'
require 'logger'
require 'faraday_middleware'

conn = Faraday.new 'http://dx.doi.org' do |c|
  c.use FaradayMiddleware::ParseJson,       content_type: 'application/vnd.citationstyles.csl+json' #'application/json'
  c.use FaradayMiddleware::FollowRedirects, limit: 3
  c.use Faraday::Adapter::NetHttp
end
response = conn.get '10.1126/science.169.3946.635'
response.body['title'] # no, that's not correct... 


connection = Faraday.new 'http://dx.doi.org' do |conn|
  conn.request :xml
  conn.response :xml,  :content_type => /\bxml$/
  conn.response :FollowRedirects, limit: 3
  conn.use :instrumentation
  conn.adapter Faraday.default_adapter
end

response = connection.get '10.1126/science.169.3946.635'

response.body['title'] # no, that's not correct... 
