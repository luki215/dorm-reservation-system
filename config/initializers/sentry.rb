Raven.configure do |config|
    config.dsn = 'https://cc7d7283966e41c4a316bd82bd57b1be:a6588d4e4a2b47578fc11e55fb605a43@sentry.io/1535175'
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end