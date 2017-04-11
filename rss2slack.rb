require "feedbag"
require "feedjira"
require 'slack/incoming/webhooks'
require 'time'

class RssSlack
  def initialize()
    @feed_url =  ENV['RSS2SLACK_RSS_URL'] ||= ""
    @slack_url =  ENV['RSS2SLACK_SLACKAPI_URL'] ||= ""
    @slack_channel = ENV['RSS2SLACK_SLACK_CHANNEL'] ||= ""
    @slack_iconemoji = ENV['RSS2SLACK_SLACK_ICONEMOJI'] ||= ""
    @slack_username = ENV['RSS2SLACK_SLACK_USERNAME'] ||= ""
    @environment = ENV['RSS2SLACK_ENV'] ||= ""
    if File.exist?("last.url")
      @is_first = false
    else
      @is_first = true
    end
  end

  def run()
   
    feed = Feedjira::Parser::RSS.new
    
    # 過去に実行した履歴があれば読み込む
    last_urls = []
    unless @is_first 
      last_urls = File.open("last.url").readlines 
      last_urls.each do |url|
        entry = Feedjira::Parser::RSSEntry.new
        entry.url = url.chomp
        feed.entries.push(entry)
      end
    end
    new_feed = Feedjira::Feed.fetch_and_parse(@feed_url)
    feed.update_from_feed(new_feed)
    
    if feed.new_entries.empty?
      puts "Noting Updated RSS Feed."
      exit(0)
    end

    # 更新があれば処理を継続する
    feed.new_entries.reverse!
    slack = Slack::Incoming::Webhooks.new @slack_url, channel: @slack_channel, username: @slack_username , icon_emoji: @slack_iconemoji
    puts "Start Notification to Slack"

    last_url = ""
    feed.new_entries.each do |entry| 
      title_arr = entry.title.split(" ")
      rss_title = title_arr[0]
      rss_subtitle = title_arr[1]
      rss_status = title_arr[2]
    
      if rss_status.include?("故障")
        slack_color = "danger"
      elsif rss_status.include?("不安定")
        slack_color = "warning"
      else
        slack_color = "#800080"
      end
    
      attachments = {
          color: slack_color,
          title:  "[#{@environment}] #{rss_title} #{rss_subtitle}" ,
          title_link: entry.url,
          text: rss_status,
          footer: "#{@environment} Jenkins",
          ts: Time.parse(entry.updated.to_s).to_i
        }
      slack.post "", attachments: [attachments] unless @is_first
      last_url = entry.url
    end
    
    File.open("last.url", "w") do |f| 
      f.puts(last_url)
    end
  end
end

# Main
rssslack = RssSlack.new
rssslack.run
