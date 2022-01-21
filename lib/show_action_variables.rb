module ShowActionVariables
  def folder_show_action_variables
    side_bar_variables
    top_bar_variables

    # @fields is for the search bar.
    @fields = DecoError.new.attributes.keys
    @pagelimit = 50
    @page_number = params[:move_to_page].nil? ? 0 : Integer(params[:move_to_page], 10)
    @max_page_num = @folder.deco_errors.count / (@pagelimit + 1)
    search_and_pagination
  end

  def filter_show_action_variables
    side_bar_variables
    top_bar_variables

    @folder = Folder.find(@filter.folder_id)
    @rule = Rule.new
    @rules = Rule.where(filter_id: @filter.id)
    @fields = DecoError.new.attributes.keys
  end

  def deco_error_show_action_variables
    side_bar_variables
    top_bar_variables

    @deco_error_display_info = DecoError.display_info
  end

  def search_and_pagination
    if params[:field].nil?
      @deco_errors = @folder.deco_errors
                            .limit(@pagelimit)
                            .offset(@page_number * @pagelimit)
    else
      field = params[:field]
      value = params[:value]
      @deco_errors = @folder.deco_errors
                            .where("#{field} like ?", "%#{value}%")
                            .limit(@pagelimit)
                            .offset(@page_number * @pagelimit)
    end
  end

  private

  def side_bar_variables
    @folders = Folder.hierarchy_order
    @folder_display_info = Folder.display_info
    @folder_new = Folder.new
  end

  def top_bar_variables
    @deco_error_new = DecoError.new
    @filters = Filter.order(:execution_order)
    @filter_new = Filter.new
    @folders = Folder.hierarchy_order
  end
end
