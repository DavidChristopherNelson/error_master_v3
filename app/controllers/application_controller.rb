require 'show_action_variables'
class ApplicationController < ActionController::Base
  include ShowActionVariables

  def home
    home_show_action_variables
  end

  def run_rule_engine; end
end
