require 'rule_engine'
require 'compute_logic'
class RuleEngineWorker
  include Sidekiq::Worker
  include SidekiqStatus::Worker
  include RuleEngine
  include ComputeLogic

  # Initiates a background process to run the rule engine according to the
  # parameters passed in. These parameters must follow the convention described
  # for RuleEngine::get_error_and_filter_data.
  #
  # @param [hash] follow the convention describe in
  #   RuleEngine::get_error_and_filter_data
  # @return [String?] A unique job id for the worker which can be used to query
  #   for the status of the worker. See app/views/folders/show.js.erb for an
  #   example of this.
  def perform(resource)
    at(1)
    error_data, filter_data = get_error_and_filter_data(resource)
    at(2)
    self.total = error_data.size
    errors_categorised = 0
    error_data.each do |error|
      filter_data.each do |filter|
        next unless compute_match(error, filter)

        DecoError.connection.exec_update(<<-EOQ, 'SQL', [[nil, (filter['folder_id']).to_s]])
            UPDATE  deco_errors
            SET     folder_id = $1
            WHERE   id = #{error['id']}
        EOQ
        break
      end
      at(errors_categorised += 1)
    end
  end
end
