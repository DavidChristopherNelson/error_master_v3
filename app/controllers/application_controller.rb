class ApplicationController < ActionController::Base
  def home
    @folders = Folder.all
  end

  def run_rule_engine; end
end
