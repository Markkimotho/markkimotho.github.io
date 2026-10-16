#!/usr/bin/env ruby
# Sync public Substack post metadata from a network that can reach the feed.
# GitHub Actions then builds from the committed index, without fetching Substack.

require 'base64'
require 'cgi'
require 'json'
require 'net/http'
require 'open3'
require 'rexml/document'
require 'rexml/xpath'
require 'time'
require 'uri'
require 'yaml'

module SubstackFeedSync
  FEED_URL = 'https://ktinega.substack.com/feed'
  REPOSITORY = 'Markkimotho/markkimotho.github.io'
  BRANCH = 'main'
  DATA_PATH = '_data/external_feed_fallbacks.yml'
  EXCLUDED_URLS = ['https://ktinega.substack.com/p/coming-soon'].freeze

  module_function

  def valid_post_url?(url)
    parsed = URI.parse(url)
    parsed.scheme == 'https' && parsed.host == 'ktinega.substack.com' &&
      parsed.path.start_with?('/p/') && !EXCLUDED_URLS.include?(url)
  rescue URI::InvalidURIError
    false
  end

  def summary_from(description)
    text = CGI.unescapeHTML(description.to_s.gsub(/<[^>]*>/, ' '))
    text.gsub(/\s+/, ' ').strip[0, 300]
  end

  def parse_feed(xml)
    document = REXML::Document.new(xml)
    items = REXML::XPath.match(document, '/rss/channel/item')
    raise 'Substack feed has no RSS items; refusing to replace the index' if items.empty?

    items.map do |item|
      url = item.elements['link']&.text.to_s.strip
      next unless valid_post_url?(url)

      title = item.elements['title']&.text.to_s.strip
      published = item.elements['pubDate']&.text.to_s.strip
      next if title.empty? || published.empty?

      {
        'title' => title,
        'url' => url,
        'published' => Time.parse(published).utc.iso8601,
        'summary' => summary_from(item.elements['description']&.text)
      }
    end.compact
  end

  def merge_posts(existing, fresh)
    by_url = {}
    existing.each do |post|
      by_url[post['url']] = post if valid_post_url?(post['url'].to_s)
    end
    fresh.each do |post|
      old = by_url[post['url']]
      post['summary'] = old['summary'] if old && !old['summary'].to_s.empty?
      by_url[post['url']] = post
    end
    by_url.values.sort_by { |post| [-Time.parse(post['published']).to_i, post['url']] }
  end

  def fetch_feed
    uri = URI(FEED_URL)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true,
                               open_timeout: 15, read_timeout: 30) do |http|
      http.get(uri.request_uri, { 'Accept' => 'application/rss+xml, application/xml' })
    end
    raise "Substack returned HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    parse_feed(response.body)
  end

  def github_api(*arguments)
    stdout, stderr, status = Open3.capture3('gh', 'api', *arguments)
    raise "GitHub API failed: #{stderr.strip}" unless status.success?

    JSON.parse(stdout)
  end

  def run(dry_run: false)
    fresh = fetch_feed
    if dry_run
      existing = YAML.load_file(File.expand_path("../#{DATA_PATH}", __dir__))
      old_posts = existing.fetch('substack.com', [])
      merged = merge_posts(old_posts, fresh)
      puts "Feed: #{fresh.length} posts; index: #{old_posts.length} -> #{merged.length} posts."
      puts "New: #{(merged.map { |post| post['url'] } - old_posts.map { |post| post['url'] }).join(', ')}"
      return
    end

    endpoint = "repos/#{REPOSITORY}/contents/#{DATA_PATH}"
    remote = github_api("#{endpoint}?ref=#{BRANCH}")
    data = YAML.safe_load(Base64.decode64(remote.fetch('content')))
    old_posts = data.fetch('substack.com', [])
    merged = merge_posts(old_posts, fresh)
    if merged == old_posts
      puts "Feed unchanged (#{merged.length} posts); no commit needed."
      return
    end

    data['substack.com'] = merged
    content = "# Automatically synced from #{FEED_URL}; do not edit by hand.\n" + YAML.dump(data)
    github_api(endpoint, '--method', 'PUT',
               '-f', "message=Sync Substack feed (#{merged.length} posts)",
               '-f', "content=#{Base64.strict_encode64(content)}",
               '-f', "sha=#{remote.fetch('sha')}",
               '-f', "branch=#{BRANCH}")
    puts "Committed #{merged.length} Substack posts to #{REPOSITORY}/#{BRANCH}."
  end
end

if $PROGRAM_NAME == __FILE__
  SubstackFeedSync.run(dry_run: ARGV.include?('--dry-run'))
end
