require 'json'
require 'show_action_variables'
class DecoErrorsController < ApplicationController
  include ShowActionVariables
  before_action :set_deco_error, only: %i[show edit update destroy]
  protect_from_forgery(except: [:create])

  # GET /deco_errors
  # GET /deco_errors.json
  def index
    @deco_errors = DecoError.all
  end

  # GET /deco_errors/1
  # GET /deco_errors/1.json
  def show
    deco_error_show_action_variables

    @folder = @deco_error.folder
    respond_to do |format|
      format.js do
        render(template: '/deco_errors/show.js.erb',
               layout: false
              )
      end
    end
  end

  # GET /deco_errors/new
  def new
    @deco_error = DecoError.new
  end

  # GET /deco_errors/1/edit
  def edit; end

  # POST /deco_errors
  # POST /deco_errors.json
  def create
    @deco_error = DecoError.new

    # The if/else clause determines if the request was sent from Error Master
    # or from a third party site.
    excluded_fields = %w[id filter_id created_at updated_at]
    if params['authenticity_token']
      converted_json = JSON[params[:deco_error][:json]]
      @deco_error.attributes.each_key do |field|
        next if converted_json[field].nil?
        next if excluded_fields.include?(field)

        @deco_error[field] = converted_json[field]
        @deco_error['filter_id'] = 1
        @deco_error['folder_id'] = 1
      end
    else
      error_fields_and_values = {}
      params['json'].each do |pair|
        next if pair[1].nil? || pair[1] == ''
        next if excluded_fields.include?(pair[0])
        error_fields_and_values[pair[0]] = pair[1]
      end
      error_fields_and_values['filter_id'] = '1'
      error_fields_and_values['folder_id'] = '1'
      error_fields_and_values['created_at'] = "#{Time.now}"
      error_fields_and_values['updated_at'] = "#{Time.now}"
      sql_string = "INSERT INTO deco_errors (#{error_fields_and_values.keys.join(', ')}) " +
                   "VALUES ('#{error_fields_and_values.values.join("', '")}')"
      puts '====================================================================================='
      p sql_string
      puts '====================================================================================='      
      sql_return_value = DecoError.connection.query(sql_string)
      puts '====================================================================================='
      p sql_return_value
      puts '====================================================================================='
    end

    respond_to do |format|
      if @deco_error.save
        @deco_error.folders << Folder.find(1)
        @deco_error.folders << Folder.find(2)
        @folder = Folder.find(2)
        deco_error_show_action_variables
        format.js do
          render(template: '/deco_errors/show.js.erb',
                 layout: false
                )
        end
      else
        @failed_resource = @deco_error
        deco_error_show_action_variables
        @form_params = { deco_error: @deco_error }
        format.js do
          render(template: '/shared/form_submit_failure',
                 layout: false
                )
        end
      end
    end
  end

  # PATCH/PUT /deco_errors/1
  # PATCH/PUT /deco_errors/1.json
  def update
    @deco_errors&.each { |deco_error| deco_error.update!(deco_error_params) } unless deco_error_params.nil?
    @folder = Folder.find(params[:folder_id])
    redirect_to(@folder)
  end

  # DELETE /deco_errors/1
  # DELETE /deco_errors/1.json
  def destroy
    @deco_errors&.each(&:destroy!)
    @folder = Folder.find(params[:folder_id])
    redirect_to(@folder)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_deco_error
    if params[:id].nil?
      @deco_error = nil
      @deco_errors = nil
    elsif params[:id].instance_of?(Array)
      @deco_errors = DecoError.find(params[:id])
      @deco_error = @deco_errors.first
    elsif params[:id].instance_of?(String)
      @deco_error = DecoError.find(params[:id])
      @deco_errors = [@deco_error]
    else
      @deco_error = DecoError.first
      @deco_errors = [@deco_error]
    end
  end

  # Only allow a list of trusted parameters through.
  def deco_error_params
    return nil if params[:deco_error].nil?

    params.require(:deco_error).permit(:read, :json, 'json', 'title', 'controller')
  end
end
