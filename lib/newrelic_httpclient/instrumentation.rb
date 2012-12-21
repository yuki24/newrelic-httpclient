require 'new_relic/agent/method_tracer'

DependencyDetection.defer do
  @name = :httpclient

  depends_on do
    defined?(::HTTPClient) &&
    !NewRelic::Control.instance['disable_httpclient'] &&
    ENV['NEWRELIC_ENABLE'].to_s !~ /false|off|no/i
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing HTTPClient Instrumentation'
  end

  executes do
    ::HTTPClient.class_eval do
      def do_get_block_with_newrelic_trace(req, proxy, conn, &block)
        host   = req.http_header.request_uri.host
        method = req.http_header.request_method
        metrics = ["External/#{host}/HTTPClient/#{method}", "External/#{host}/all", "External/all"]
        if NewRelic::Agent::Instrumentation::MetricFrame.recording_web_transaction?
          metrics << "External/allWeb"
        else
          metrics << "External/allOther"
        end
        self.class.trace_execution_scoped metrics do
          do_get_block_without_newrelic_trace(req, proxy, conn, &block)
        end
      end
      alias do_get_block_without_newrelic_trace do_get_block
      alias do_get_block do_get_block_with_newrelic_trace
    end
  end
end
