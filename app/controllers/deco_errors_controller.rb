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
    @deco_error.update(read: true)
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
    # or from a third party site. (The third party site won't have an
    # authenticity_token)
    excluded_fields = %w[id folder_id filter_id created_at updated_at]
    fields_to_convert_to_hash = %w[parameters, session_data]
    if params['authenticity_token']
      process_user_generated_error(excluded_fields, fields_to_convert_to_hash)
    else
      sql_insert_success = process_api_generated_error(excluded_fields)
    end

    respond_to do |format|
      if sql_insert_success
        format.json do
          render(status: :ok)
        end
      elsif @deco_error.save
        @folder = Folder.find(@deco_error.folder_id)
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
    folder_show_action_variables
    respond_to do |format|
      format.js do
        render(template: '/folders/show.js.erb',
               layout: false
              )
      end
    end
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

  def time_it(experiment_name)
    time_before = Time.now
    yield if block_given?
    time_after = Time.now
    puts('======================================================================')
    puts("It took #{time_after - time_before} seconds to run #{experiment_name}.")
  end

  # This method saves the data in params into @deco_error. Since @deco_error
  # has scope outside of this method nothing is returned.
  #
  # @param [array of strings] These are field names like 'id' that need to be
  #                           determined by Error Master and not from the input
  #                           data.
  def process_user_generated_error(excluded_fields, fields_to_convert_to_hash)
    converted_json = JSON(params[:deco_error][:json])
    @deco_error.attributes.each_key do |field|
      next if converted_json[field].nil?
      next if excluded_fields.include?(field)
      if fields_to_convert_to_hash.include?(field)
        @deco_error[field] = convert_string_to_hash(converted_json[field])
      else
        @deco_error[field] = converted_json[field]
      end
    end
    @deco_error['filter_id'] = 1
    @deco_error['folder_id'] = 1
  end

  # This method saves the data in params into @deco_error. Since @deco_error
  # has scope outside of this method nothing is returned.
  #
  # @param [array of strings] These are field names like 'id' that need to be
  #                           determined by Error Master and not from the input
  #                           data.
  # @return [boolean] true if error is saved, false otherwise.
  def process_api_generated_error(excluded_fields)
    error_fields_and_values = {}
    params['json'].each do |pair|
      next if pair[1].nil? || pair[1] == ''
      next if excluded_fields.include?(pair[0])

      # The gsub removes all ' and " from the string. I do this because
      # can't figure out how to escape and sql INSERT these characters.
      error_fields_and_values[pair[0]] = pair[1].gsub(/'|"/, '')
    end
    error_fields_and_values['filter_id'] = '1'
    error_fields_and_values['folder_id'] = '1'
    error_fields_and_values['created_at'] = Time.now.to_s
    error_fields_and_values['updated_at'] = Time.now.to_s
    keys = error_fields_and_values.keys.join(', ')
    values = error_fields_and_values.values.join("', '")
    sql_string = "INSERT INTO deco_errors (#{keys}) " +
      "VALUES ('#{values}')" +
      'RETURNING id'

    # I can't figure out how to get the status of a PG::result object
    # directly so I do this instead to determine if the error has been saved.
    error_id = DecoError.connection.execute(sql_string)[0]['id']
    sql_insert_success = !!error_id
    resource = { controller: params[:controller], id: error_id }
    RuleEngineWorker.perform_async(resource)
    return sql_insert_success
  end

  # Error data can contain fields that are strings which represent hashes. 
  # However, these strings might not follow JSON convention, for instance they 
  # might be generated from using Ruby’s .to_s method on a hash. This method 
  # tries a few common patterns to convert the string into a hash. 
  #
  # @param [string] the string to attempt to turn into a hash.
  # @return [hash or string] the hash representation of the string if 
  #                          conversion occurred otherwise the parameter string
  #                          is returned.
  def convert_string_to_hash(data_as_string)
    begin
      data_as_hash = JSON(data_as_string)
    rescue JSON::ParserError
      data_as_string[1..-2] = data_as_string[1..-2].gsub(/[\{]/, ' (open curly brace) ')
      data_as_string[1..-2] = data_as_string[1..-2].gsub(/[\}]/, ' (close curly brace) ')
      data_as_string.gsub!(/"/,"") # converts " into '
      data_as_string.gsub!(/([\:\w\-\/\']+)\=\>([\w\-\/\s\'\:\(\)\+\.]+)/, '"\1": "\2"')
      data_as_string.gsub!(/\n/, '')
      begin
        data_as_hash = JSON(data_as_string)
      rescue JSON::ParserError
        return data_as_string
      else 
        return data_as_hash.to_json
      end
    else
      return data_as_hash.to_json
    end
  end
end
