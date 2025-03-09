class HealthController < ApplicationController
  # Skip authentication for health check
  # We're not using Devise authentication for regular users yet
  
  def check
    health_status = {
      status: 'ok',
      timestamp: Time.current,
      environment: Rails.env,
      database_connection: database_connected?,
      elasticsearch_connection: elasticsearch_connected?,
      solid_queue_status: solid_queue_status,
      cache_status: cache_status
    }
    
    status_code = health_status.values.all? { |status| status.to_s == 'ok' || status.is_a?(String) || status.is_a?(Time) || status.is_a?(TrueClass) } ? :ok : :service_unavailable
    
    render json: health_status, status: status_code
  end
  
  private
  
  def database_connected?
    # Simple ActiveRecord check
    begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      true
    rescue => e
      { error: e.message }
    end
  end
  
  def elasticsearch_connected?
    # Check Elasticsearch connection if Elasticsearch is configured
    if defined?(Elasticsearch)
      begin
        Elasticsearch::Model.client.cluster.health
        true
      rescue => e
        { error: e.message }
      end
    else
      'not_configured'
    end
  end
  
  def solid_queue_status
    # Check Solid Queue status
    if defined?(SolidQueue)
      begin
        connection_ok = ActiveRecord::Base.connection.table_exists?('solid_queue_jobs')
        connection_ok ? 'ok' : 'tables_not_found'
      rescue => e
        { error: e.message }
      end
    else
      'not_configured'
    end
  end
  
  def cache_status
    # Test cache read/write
    if defined?(Rails.cache)
      begin
        test_key = "health_check_#{Time.current.to_i}"
        Rails.cache.write(test_key, 'ok')
        cache_result = Rails.cache.read(test_key)
        cache_result == 'ok' ? 'ok' : 'write_failed'
      rescue => e
        { error: e.message }
      end
    else
      'not_configured'
    end
  end
end 