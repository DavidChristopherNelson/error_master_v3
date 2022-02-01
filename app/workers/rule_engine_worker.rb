require 'rule_engine'
class RuleEngineWorker
  include Sidekiq::Worker
  include SidekiqStatus::Worker
  include RuleEngine

  def perform(resource)
    at(2)
    self.total = @deco_errors.size
    errors_categorised = 0
    serialize_errors_and_filters(resource)[:deco_errors].each do |deco_error|
      match_error_to_filters(deco_error)
      at(errors_categorised += 1)
    end
  end
end
