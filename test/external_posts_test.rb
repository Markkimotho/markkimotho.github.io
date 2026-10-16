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
end
