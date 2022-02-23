require 'show_action_variables'
require 'rule_engine'
class ApplicationController < ActionController::Base
  include ShowActionVariables
  include RuleEngine

  def home
    sql_rule_command = 'SELECT rules.filter_id, rules.id, rules.field, rules.value FROM filters INNER JOIN rules ON filters.id = rules.filter_id'
    rule_data = Rule.connection.execute(sql_rule_command)
    puts '==================================================================================='
    puts rule_data
    p rule_data
    puts '==================================================================================='

    puts '==================================================================================='
    puts rule_data.to_a
    p rule_data
    puts '==================================================================================='
  end
end