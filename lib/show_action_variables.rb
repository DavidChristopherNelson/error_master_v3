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
    @rules = Rule.where(filter_id: @filter.id)
    @edit_filter_form_params = {
      filter: @filter,
      folders: @folders,
      folder: @folder
    }
    @new_rule_form_params = {
      rule: Rule.new,
      filter: @filter,
      fields: DecoError.new.attributes.keys
    }
    @edit_rule_form_params = {}
    @rules.each do |rule|
      @edit_rule_form_params[rule.id.to_s] = {
        rule: rule,
        fields: DecoError.new.attributes.keys
      }
    end
  end

  def deco_error_show_action_variables
    side_bar_variables
    top_bar_variables

    @deco_error_display_info = DecoError.display_info
  end

  def home_show_action_variables
    side_bar_variables
    top_bar_variables
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
    @new_folder_form_params = {
      folder_new: @folder_new,
      folders: @folders
    }
  end

  def top_bar_variables
    @deco_error_new = DecoError.new
    @filters = Filter.order(:execution_order)
    @filter_new = Filter.new
    @folders = Folder.hierarchy_order
    @new_filter_form_params = {
      filter_new: @filter_new,
      folders: @folders
    }
    @new_error_form_params = {}
  end
end
