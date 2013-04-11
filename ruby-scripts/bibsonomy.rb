

require 'faraday'
require 'logger'
require 'faraday_middleware'
require 'multi_xml'

connection = Faraday.new 'http://www.bibsonomy.org/api/users/carl-boettiger' do |conn|
  conn.response :xml,  :content_type => /\bxml$/
  conn.basic_auth('carl-boettiger', '2303c155155a05b3455be92bde0f3048')
  conn.adapter Faraday.default_adapter
  # ideally we should add parameters here: fix resourcetype, end

end

out = connection.get 'posts?resourcetype=bibtex&end=30'
b = out.body['bibsonomy']["posts"]['post'].map { |h| h['bibtex'].slice('year') }
b.length # proof that we requested 30 entries (default is 20)

## Parse the entries, e.g. 
out.body['bibsonomy']["posts"]['post'][0]['bibtex']['title']
out.body['bibsonomy']["posts"]['post'][0]['tag']['name']

out.body['bibsonomy']["posts"]['post'][0].keys # => => ["user", "group", "tag", "documents", "bibtex", "changedate", "postingdate"]


require 'active_support/core_ext'
b = out.body['bibsonomy']["posts"]['post'].map { |h| h['bibtex'].slice('author') }


# Querying tags returns a slightly different structure -- since we have conditioned on tag, we 
corals = connection.get 'posts?resourcetype=bibtex&tags=corals'
b = corals.body['bibsonomy']["posts"]['post'].map { |h| h.slice('author') }

