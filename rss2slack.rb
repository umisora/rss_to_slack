require "feedbag"
require "feedjira"
feed = Feedjira::Parser::RSS.new
feed.feed_url = "http://<FQDN>/jenkins/rssFailed"
last_entry = Feedjira::Parser::RSSEntry.new
last_entry.url = "" #前回のLastURL
feed.entries = [last_entry]

# 過去に実行した履歴があれば読み込む
last_urls = []
if File.exist?("last.url")
  last_urls = File.open("last.url").readlines
end
last_urls.each do |url|
  entry = Feedjira::Parser::RSSEntry.new
  entry.url = url.chomp
  p entry.url
  feed.entries.push(entry)
end
print feed.entries 
feed2 = Feedjira::Feed.fetch_and_parse("http://<FQDN>/jenkins/rssFailed")
feed.update_from_feed(feed2)
feed.updated?
feed.new_entries.reverse!
last_url = ""
feed.new_entries.each do |entry| 
  #puts entry.title
  #puts entry.updated
  last_url = entry.url
  p last_url
end

