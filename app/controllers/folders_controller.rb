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
  def show
    run_rule_engine if params['rule_engine']
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
    folder_show_action_variables

    respond_to do |format|
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
end
