require 'show_action_variables'
require 'rule_engine'
class FoldersController < ApplicationController
  include ShowActionVariables
  include RuleEngine
  before_action :set_folder, only: %i[show edit update destroy]

  # GET /folders
  # GET /folders.json
  def index
    @folders = Folder.all
  end

  # GET /folders/1
  # GET /folders/1.json
  # Displays the folder information. Uses ShowActionVariables.rb in /lib
  #
  # @param [hash] xxx
  # @option 'rule_engine' = truthy
  #   Pass this option in to run the rule engine on this folder
  # @option 'ignore' = {'field'=>'XXX', 'value'=>'XXX'}
  #   Pass this option in to create a rule to ignore errors with the field and
  #   value of the one just viewed.
  # @return app/views/folders/show.js.erb
  def show
    if params['rule_engine']
      resource = { controller: params[:controller], id: params[:id].to_i }
      @rule_engine_id = RuleEngineWorker.perform_async(resource)
    elsif params['ignore']
      field = params['ignore']['field']
      value = params['ignore']['value']
      Rule.create(filter_id: 2, field: field.to_s, value: value.to_s)
    end
    folder_show_action_variables
    respond_to do |format|
      format.js do
        render(template: '/folders/show.js.erb',
               layout: false
              )
      end
    end
  end

  # GET /folders/new
  def new
    @folder = Folder.new
  end

  # GET /folders/1/edit
  def edit; end

  # POST /folders
  # POST /folders.json
  def create
    @folder = Folder.new(folder_params)
    folder_show_action_variables

    respond_to do |format|
      if @folder.save
        format.js do
          render(template: '/folders/show.js.erb',
                 layout: false
                )
        end
      else
        @failed_resource = @folder
        @form_params = {
          folder_new: @folder,
          folders: @folders
        }
        format.js do
          render(template: '/shared/form_submit_failure',
                 layout: false
                )
        end
      end
    end
  end

  # PATCH/PUT /folders/1
  # PATCH/PUT /folders/1.json
  def update
    respond_to do |format|
      folder_show_action_variables
      if @folder.update(folder_params)
        format.js do
          render(template: '/folders/show.js.erb',
                 layout: false
                )
        end
      else
        @failed_resource = @folder
        @form_params = {
          folder: @folder,
          folders: @folders
        }
        format.js do
          render(template: '/shared/form_submit_failure',
                 layout: false
                )
        end
      end
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.json
  def destroy
    Folder.find(@folder.find_sub_folders([])).each do |folder|
      folder.deco_errors.each do |deco_error|
        DecoError.connection.exec_update(<<-EOQ, 'SQL', [[nil, '1']])
          UPDATE  deco_errors
          SET     folder_id = $1
          WHERE   id = #{deco_error['id']}
        EOQ
      end
    end
    @folder.destroy!
    # Display the 'All' folder upon deletion.
    @folder = Folder.find(1)
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
  def set_folder
    @folder = Folder.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def folder_params
    params.require(:folder).permit(:user_created, :name, :parent_id)
  end

  def time_it(experiment_name)
    # Delete this method. Created 1/2/22. Only intended for experimental purposes.
    time_before = Time.now
    yield if block_given?
    time_after = Time.now
    puts('======================================================================')
    puts("It took #{time_after - time_before} seconds to run #{experiment_name}.")
  end
end
