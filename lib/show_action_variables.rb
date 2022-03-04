module ShowActionVariables
  def folder_show_action_variables
    side_bar_variables
    top_bar_variables

    search_and_pagination
    @pagelimit = 50
    @max_page_num = @deco_errors.count / (@pagelimit + 1)
    if params[:move_to_page].nil?
      @page_number = 0
    elsif params[:move_to_page].to_i < 0
      @page_number = 0
    elsif params[:move_to_page].to_i > @max_page_num
      @page_number = 0
    else
      @page_number = Integer(params[:move_to_page], 10)
    end
    @deco_errors = @deco_errors.limit(@pagelimit)
                               .offset(@page_number * @pagelimit)
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
    field = params[:field]
    value = params[:value]
    if params[:previous_searches].nil? # No pagination or search
      @previous_searches = nil
      @deco_errors = @folder.deco_errors
    elsif params[:previous_searches] == "" && field.nil? # pagination without search
      @previous_searches = nil
      @deco_errors = @folder.deco_errors  
    elsif params[:previous_searches] == "" # first search
      @previous_searches = [[field, value]].to_json
      @deco_errors = @folder.deco_errors
                            .where("#{field} like ?", "%#{value}%")
    else # previous searches
      @previous_searches = JSON(params[:previous_searches])
      @previous_searches << [field, value] unless field.nil?
      @deco_errors = @folder.deco_errors
      @previous_searches.each do |search|
        @deco_errors = @deco_errors
                         .where("#{search[0]} like ?", "%#{search[1]}%")
      end
      @previous_searches = @previous_searches.to_json
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

    @taken_execution_orders_array = []
    @filters.each do |filter|
      @taken_execution_orders_array << filter.execution_order
    end
    @taken_execution_orders = @taken_execution_orders_array[0..-2].join(", ") +
                              " and #{@taken_execution_orders_array[-1]}"

    @lowest_available_execution_order = nil
    (@taken_execution_orders_array.max + 2).times do |num|
      unless @taken_execution_orders_array.include? num
        @lowest_available_execution_order = num
        break
      end
    end

    @new_filter_form_params = {
      filter_new: @filter_new,
      folders: @folders,
      taken_execution_orders: @taken_execution_orders,
      lowest_available_execution_order: @lowest_available_execution_order
    }
    @new_error_form_params = {
      deco_error: @deco_error_new
    }
    @export = {
      export_data: 'XXXX'
    }
    @fields = DecoError.new.attributes.keys
  end
end
