class ApplicationController < ActionController::Base
  def home
    @folder_display_info = Folder.display_info
    @folders = Folder.hierarchy_order
    @folder = Folder.new
    @filters = Filter.order(:execution_order)
    @filter = Filter.new
    @deco_error = DecoError.new
  end

  def run_rule_engine; end
end
