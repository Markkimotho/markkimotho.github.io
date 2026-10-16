require 'minitest/autorun'
require_relative '../_plugins/external-posts'

class ExternalPostsTest < Minitest::Test
  Response = Struct.new(:code, :body, :headers)
  SOURCE = { 'name' => 'substack.com', 'rss_url' => 'https://example.com/feed' }.freeze

  def setup
    @generator = ExternalPosts::ExternalPostsGenerator.new
  end

  def with_method(object, name, replacement)
    original = object.method(name)
    object.singleton_class.define_method(name, &replacement)
    yield
  ensure
    object.singleton_class.define_method(name, original)
  end

  def test_valid_feed_is_processed
    xml = '<rss version="2.0"><channel><title>Posts</title><item><title>One</title><link>https://example.com/one</link></item></channel></rss>'
    response = Response.new(200, xml, { 'content-type' => 'application/rss+xml' })
    entries = nil

    with_method(HTTParty, :get, ->(*_args) { response }) do
      with_method(@generator, :process_entries, ->(_site, _src, parsed_entries) { entries = parsed_entries }) do
        @generator.fetch_from_rss(nil, SOURCE)
      end
    end

    assert_equal 1, entries.length
    assert_equal 'One', entries.first.title
  end

  def test_non_feed_response_is_retried_without_failing_the_build
    response = Response.new(200, '<html>Temporarily unavailable</html>', { 'content-type' => 'text/html' })
    attempts = 0

    with_method(HTTParty, :get, ->(*_args) { attempts += 1; response }) do
      with_method(@generator, :sleep, ->(_seconds) {}) do
        @generator.fetch_from_rss(nil, SOURCE)
      end
    end

    assert_equal 3, attempts
  end

  def test_http_error_is_retried_without_failing_the_build
    response = Response.new(503, 'Unavailable', { 'content-type' => 'text/plain' })
    attempts = 0

    with_method(HTTParty, :get, ->(*_args) { attempts += 1; response }) do
      with_method(@generator, :sleep, ->(_seconds) {}) do
        @generator.fetch_from_rss(nil, SOURCE)
      end
    end

    assert_equal 3, attempts
  end

  def test_cached_posts_are_used_when_feed_is_blocked
    response = Response.new(403, '<html>Forbidden</html>', { 'content-type' => 'text/html' })
    cached_post = {
      'url' => 'https://example.com/one', 'title' => 'One',
      'published' => '2026-03-30T11:01:57Z', 'summary' => 'A short description'
    }
    site = Struct.new(:data).new({ 'external_feed_fallbacks' => { 'substack.com' => [cached_post] } })
    entries = nil

    with_method(HTTParty, :get, ->(*_args) { response }) do
      with_method(@generator, :sleep, ->(_seconds) {}) do
        with_method(@generator, :process_entries, ->(_site, _src, cached_entries) { entries = cached_entries }) do
          @generator.fetch_from_rss(site, SOURCE)
        end
      end
    end

    assert_equal 1, entries.length
    assert_equal 'One', entries.first.title
    assert_equal Time.utc(2026, 3, 30, 11, 1, 57), entries.first.published
  end
end
