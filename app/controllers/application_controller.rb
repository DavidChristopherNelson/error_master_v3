class ApplicationController < ActionController::Base

  def hello
    render html: "Welcome to Error Master"
  end
end
