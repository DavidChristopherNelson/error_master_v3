require 'show_action_variables'
require 'rule_engine'
class ApplicationController < ActionController::Base
  include ShowActionVariables
  include RuleEngine

  def home
    sql_rule_command = 'SELECT rules.filter_id, rules.id, rules.field, rules.value
                        FROM filters
                        INNER JOIN rules
                        ON filters.id = rules.filter_id'
    rule_data = Rule.connection.execute(sql_rule_command)
    puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    puts "rule_data"
    p rule_data
    p rule_data.class
    puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    rule_data_in_array = rule_data.to_a
    puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    puts "rule_data_in_array"
    p rule_data_in_array
    p rule_data_in_array.class
    puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

    cached_data = Rails.cache.fetch('rules') do
      puts "cache miss"
      rule_data_in_array
    end
    puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    puts "cached_data"
    p cached_data
    p cached_data.class
    puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

    puts cached_data
  end
end