# About
This Tool can rss feed data notification to slack.


For example, if you want to subscribe RSS from Slack to Jenkins on server that is invisible from the Internet, you can not connect to Jenkins from Slack. In such a case, using this tool, Jenkins server can notify Slack RSS.

# How about execute

```
bundle install

export RSS2SLACK_RSS_URL="http://<FQDN>/rss"
export RSS2SLACK_SLACKAPI_URL="https://hooks.slack.com/services/xxxx"
export RSS2SLACK_SLACK_CHANNEL="#channel"
export RSS2SLACK_SLACK_ICONEMOJI=":thinking_face:"
export RSS2SLACK_SLACK_USERNAME="RSS To Slack"
export RSS2SLACK_ENV="local"

bundle exec ruby rss2slack.rb
```

# Other

This tool creates a cache file (last.url) of RSSFeed.
When deleting the cache file (when executing for the first time), it will output & notify all the values that can be taken by the RSS feed.

# In Japanese
# 概要
このツールはRSSFeedを購読し、Slackへ通知するツールです。

例えばJenkinsの様にインターネット側から見えないサーバー上のRSSをSlackで購読したい場合、SlackからJenkinsに接続する事ができません。その様な時にこのツールを使うと、JenkinsサーバーからSlackにRSSを通知できます。


# 使い方

```
bundle install

export RSS2SLACK_RSS_URL="http://<FQDN>/rss"
export RSS2SLACK_SLACKAPI_URL="https://hooks.slack.com/services/xxxx"
export RSS2SLACK_SLACK_CHANNEL="#channel"
export RSS2SLACK_SLACK_ICONEMOJI=":thinking_face:"
export RSS2SLACK_SLACK_USERNAME="RSS To Slack"
export RSS2SLACK_ENV="local"

bundle exec ruby rss2slack.rb
```

# その他
このツールはRSSFeedのキャッシュファイル(last.url)を作成します。
キャッシュファイルを消した場合(初めて実行する場合)はRSSフィードで取れる値をすべて出力＆通知します。

