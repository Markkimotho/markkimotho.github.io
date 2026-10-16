require 'minitest/autorun'
require_relative 'sync_substack_feed'

class SubstackFeedSyncTest < Minitest::Test
  def test_parses_public_posts_and_excludes_announcement
    xml = <<~XML
      <rss><channel>
        <item><title>New post</title><link>https://ktinega.substack.com/p/new-post</link>
          <pubDate>Fri, 16 Oct 2026 06:00:00 GMT</pubDate>
          <description><![CDATA[<p>A <strong>short</strong> description.</p>]]></description>
        </item>
        <item><title>Coming soon</title><link>https://ktinega.substack.com/p/coming-soon</link>
          <pubDate>Fri, 16 Oct 2026 05:00:00 GMT</pubDate></item>
      </channel></rss>
    XML

    posts = SubstackFeedSync.parse_feed(xml)
    assert_equal 1, posts.length
    assert_equal 'New post', posts.first['title']
    assert_equal 'A short description.', posts.first['summary']
    assert_equal '2026-10-16T06:00:00Z', posts.first['published']
  end

  def test_merges_new_posts_without_losing_older_history
    old = { 'title' => 'Older', 'url' => 'https://ktinega.substack.com/p/older',
            'published' => '2025-01-01T00:00:00Z', 'summary' => 'Original summary' }
    fresh = { 'title' => 'Newer', 'url' => 'https://ktinega.substack.com/p/newer',
              'published' => '2026-01-01T00:00:00Z', 'summary' => 'New summary' }

    posts = SubstackFeedSync.merge_posts([old], [fresh])
    assert_equal [fresh['url'], old['url']], posts.map { |post| post['url'] }
  end

  def test_rejects_non_substack_links
    refute SubstackFeedSync.valid_post_url?('https://example.com/p/other')
    refute SubstackFeedSync.valid_post_url?('http://ktinega.substack.com/p/post')
  end
end
