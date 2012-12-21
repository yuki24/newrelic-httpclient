require 'test/unit'
require 'httpclient'
require 'newrelic/httpclient'

class TestNewRelicHttpclient < Test::Unit::TestCase
  include NewRelic::Agent::Instrumentation::ControllerInstrumentation

  def setup
    NewRelic::Agent.manual_start
    @engine = NewRelic::Agent.instance.stats_engine
    @engine.clear_stats

    @client = HTTPClient.new
  end

  def assert_metrics(*m)
    m.each do |x|
      assert @engine.metrics.include?(x), "#{x} not in metrics"
    end
  end

  def test_get
    response = @client.get("http://www.google.com/index.html")

    assert_match /<head>/i, response.body
    assert_metrics "External/all",
                   "External/www.google.com/HTTPClient/GET",
                   "External/allOther",
                   "External/www.google.com/all"
  end

  def test_post
    response = @client.post("http://www.google.com/index.html")

    assert_metrics "External/all",
                   "External/www.google.com/HTTPClient/POST",
                   "External/allOther",
                   "External/www.google.com/all"
  end

  def test_ignore
    NewRelic::Agent.disable_all_tracing do
      @client.get("http://www.google.com/index.html")
    end

    assert_equal 0, @engine.metrics.size
  end
end
