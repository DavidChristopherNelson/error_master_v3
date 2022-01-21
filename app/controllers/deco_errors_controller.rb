require 'show_action_variables'
class DecoErrorsController < ApplicationController
  include ShowActionVariables
  before_action :set_deco_error, only: %i[show edit update destroy]

  # GET /deco_errors
  # GET /deco_errors.json
  def index
    @deco_errors = DecoError.all
  end

  # GET /deco_errors/1
  # GET /deco_errors/1.json
  def show
    deco_error_show_action_variables

    @folder = @deco_error.folders.where.not(id: 1).first
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
    @deco_error = DecoError.new(deco_error_params)

    respond_to do |format|
      if @deco_error.save
        format.html do
          redirect_to(@deco_error,
                      notice: 'Deco error was successfully \
                                  created.'
                     )
        end
        format.json do
          render(:show,
                 status: :created,
                 location: @deco_error
                )
        end
      else
        format.html { render(:new) }
        format.json do
          render(json: @deco_error.errors,
                 status: :unprocessable_entity
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

    params.require(:deco_error).permit(:read)
  end
end
