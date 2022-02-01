require 'rule_engine'
class RuleEngineWorker
  include Sidekiq::Worker
  include SidekiqStatus::Worker
  include RuleEngine

  def perform(resource)
    at(0)    
    deco_errors = serialize_errors_and_filters(resource)[:deco_errors]
    puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    puts "The number of errors is #{deco_errors.count}"
    puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    self.total = deco_errors.size
    errors_categorised = 0
    deco_errors.each do |deco_error|
      match_error_to_filters(deco_error)
      at(errors_categorised += 1)
      puts "---------------------------------------------------------------------"
      puts errors_categorised
      puts "---------------------------------------------------------------------"
    end
  end
end
