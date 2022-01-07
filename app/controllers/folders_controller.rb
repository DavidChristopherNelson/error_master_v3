class FoldersController < ApplicationController
  before_action :set_folder, only: %i[show edit update destroy]

  # GET /folders
  # GET /folders.json
  def index
    @folders = Folder.all
  end

  # GET /folders/1
  # GET /folders/1.json
  def show
    @page_num = params[:move_to_page].nil? ? 0 : params[:move_to_page]
    @deco_errors = paginator(@folder, @page_num)
    render(json: {
      main_content: render_to_string('show_main_content', layout: false),
      tool_bar: render_to_string('show_tool_bar', layout: false),
      side_bar_update_counts: Folder.serialize
    }
          )
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

    respond_to do |format|
      if @folder.save
        format.html do
          redirect_to(@folder,
                      notice: 'Folder was successfully \
                                  created.'
                     )
        end
        format.json do
          render(:show,
                 status: :created,
                 location: @folder
                )
        end
      else
        format.html { render(:new) }
        format.json do
          render(json: @folder.errors,
                 status: :unprocessable_entity
                )
        end
      end
    end
  end

  # PATCH/PUT /folders/1
  # PATCH/PUT /folders/1.json
  def update
    respond_to do |format|
      if @folder.update(folder_params)
        format.html do
          redirect_to(@folder,
                      notice: 'Folder was successfully \
                                  updated.'
                     )
        end
        format.json do
          render(:show,
                 status: :ok,
                 location: @folder
                )
        end
      else
        format.html { render(:edit) }
        format.json do
          render(json: @folder.errors,
                 status: :unprocessable_entity
                )
        end
      end
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.json
  def destroy
    @folder.destroy!
    respond_to do |format|
      format.html do
        redirect_to(folders_url,
                    notice: 'Folder was successfully \
                                destroyed.'
                   )
      end
      format.json { head(:no_content) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_folder
    @folder = Folder.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def folder_params
    params.fetch(:folder, {})
  end

  def paginator(folder, page_number = 0)
    page_number = 0 if page_number.nil?
    page_number = Integer(page_number, 10)
    pagelimit = 10
    # The following code will just query for the total and not return all errors
    # https://guides.rubyonrails.org/active_record_querying.html#total-of-grouped-items
    @max_page_num = folder.deco_errors.count / pagelimit
    folder.deco_errors.limit(pagelimit).offset(page_number * pagelimit)
  end
end
