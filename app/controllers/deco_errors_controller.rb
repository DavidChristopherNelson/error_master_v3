class DecoErrorsController < ApplicationController
  before_action :set_deco_error, only: %i[show edit update destroy]

  # GET /deco_errors
  # GET /deco_errors.json
  def index
    @deco_errors = DecoError.all
  end

  # GET /deco_errors/1
  # GET /deco_errors/1.json
  def show; end

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
    unless @deco_errors.nil?
      if /mark_as_read/.match?(params[:submission_data])
        @deco_errors.each do |deco_error|
          deco_error.update!(read: true)
        end
      elsif /mark_as_unread/.match?(params[:submission_data])
        @deco_errors.each do |deco_error|
          deco_error.update!(read: false)
        end
      end
    end

    @folder = Folder.find(params[:folder_id])
    render(json: {
      main_content: render_to_string('folders/show_main_content', layout: false),
      tool_bar: render_to_string('folders/show_tool_bar', layout: false),
      side_bar_update_counts: Folder.serialize
    }
          )
  end

  # DELETE /deco_errors/1
  # DELETE /deco_errors/1.json
  def destroy
    @deco_errors&.each(&:destroy!)

    @folder = Folder.find(params[:folder_id])
    render(json: {
      main_content: render_to_string('folders/show_main_content', layout: false),
      tool_bar: render_to_string('folders/show_tool_bar', layout: false),
      side_bar_update_counts: Folder.serialize
    }
          )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_deco_error
    @deco_errors = params[:id].nil? ? nil : DecoError.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def deco_error_params
    params.fetch(:deco_error, {})
  end
end
