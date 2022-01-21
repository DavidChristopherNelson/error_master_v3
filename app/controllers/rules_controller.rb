require 'show_action_variables'
class RulesController < ApplicationController
  include ShowActionVariables
  before_action :set_rule, only: %i[show edit update destroy]

  # GET /rules
  # GET /rules.json
  def index
    @rules = Rule.all
  end

  # GET /rules/1
  # GET /rules/1.json
  def show; end

  # GET /rules/new
  def new
    @rule = Rule.new
  end

  # GET /rules/1/edit
  def edit; end

  # POST /rules
  # POST /rules.json
  def create
    rule = Rule.create!(rule_params)
    @filter = Filter.find(rule&.filter_id)
    filter_show_action_variables
    respond_to do |format|
      format.js do
        render(template: '/filters/show.js.erb',
               layout: false
              )
      end
    end
  end

  # PATCH/PUT /rules/1
  # PATCH/PUT /rules/1.json
  def update
    @filter = Filter.find(@rule&.filter_id)
    @rule.update!(rule_params)
    filter_show_action_variables
    respond_to do |format|
      format.js do
        render(template: '/filters/show.js.erb',
               layout: false
              )
      end
    end
  end

  # DELETE /rules/1
  # DELETE /rules/1.json
  def destroy
    @filter = Filter.find(@rule.first.filter_id)
    @rule&.each(&:destroy!)
    filter_show_action_variables
    respond_to do |format|
      format.js do
        render(template: '/filters/show.js.erb',
               layout: false
              )
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rule
    @rule = Rule.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def rule_params
    params.require(:rule).permit(:filter_id, :field, :value)
  end
end
