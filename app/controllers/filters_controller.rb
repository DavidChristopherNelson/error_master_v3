require 'show_action_variables'
class FiltersController < ApplicationController
  include ShowActionVariables
  before_action :set_filter, only: %i[show edit update destroy]

  # GET /filters
  # GET /filters.json
  def index
    @filters = Filter.all
  end

  # GET /filters/1
  # GET /filters/1.json
  def show
    filter_show_action_variables

    respond_to do |format|
      format.js do
        render(template: '/filters/show.js.erb',
               layout: false
              )
      end
    end
  end

  # GET /filters/new
  def new
    @filter = Filter.new
    filter_show_action_variables
  end

  # GET /filters/1/edit
  def edit; end

  # POST /filters
  # POST /filters.json
  def create
    @filter = Filter.new(filter_params)
    filter_show_action_variables

    respond_to do |format|
      if @filter.save
        format.js do
          render(template: '/filters/show.js.erb',
                 layout: false
                )
        end
      else
        @failed_resource = @filter
        @form_params = {
          filter_new: @filter,
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

  # PATCH/PUT /filters/1
  # PATCH/PUT /filters/1.json
  def update
    filter_show_action_variables

    respond_to do |format|
      if @filter.update(filter_params)
        format.js do
          render(template: '/filters/show.js.erb',
                 layout: false
                )
        end
      else
        @failed_resource = @filter
        @form_params = @edit_filter_form_params
        format.js do
          render(template: '/shared/form_submit_failure',
                 layout: false
                )
        end
      end
    end
  end

  # DELETE /filters/1
  # DELETE /filters/1.json
  def destroy
    @filter.destroy!
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
  def set_filter
    @filter = Filter.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def filter_params
    params.require(:filter).permit(:folder_id,
                                   :name,
                                   :execution_order,
                                   :logic,
                                   rules_attributes: %i[filter_id field value]
                                  )
  end
end
