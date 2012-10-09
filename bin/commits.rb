#!/usr/bin/env ruby

require 'octokit'
require 'chronic'

#day = context.environments.first["page"]["date"]
if ARGV.length == 2 
  address = ARGV[0]
  day = Chronic.parse(ARGV[1])
elsif ARGV.length == 1 
  address = ARGV[0]
  day = Chronic.parse(Date.today.iso8601)  # start of today
else 
  raise "Specify user/repo" 
end
@until = (day + 60*60*24).iso8601
@since = day.iso8601

repo = Octokit.commits(address, "master", {:since => @since, :until => @until}) 

out = ""
for i in 0 ... repo.size
  out = out + "- " +
    repo[i].commit.message + " " + 
    "[" + DateTime.parse(repo[i].commit.author.date).to_time.strftime("%I:%M %P %Y/%m/%d") + "]" +
    ## Adjust the link to a proper url
    "(" + repo[i].commit.url.gsub("api\.", "").gsub("repos/","").gsub("git/", "").gsub("commits/", "commit/") + ")\n"
end
print out

## html formatted version

#out = "<ul>\n"
#for i in 0 ... repo.size
#  out = out + "<li>" +
#    repo[i].commit.message + " " + 
#    "<a href=\"" +
#    ## Adjust the link to a proper url
#    repo[i].commit.url.gsub("api\.", "").gsub("repos/","").gsub("git/", "").gsub("commits/", "commit/") + 
#    "\">" + 
#    DateTime.parse(repo[i].commit.author.date).to_time.strftime("%I:%M %P %Y/%m/%d") +
#    "</a>" +
#    "</li>\n"
#end
#out = out + "</ul>\n"

