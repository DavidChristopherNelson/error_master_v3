class ApplicationController < ActionController::Base
  def hello
    render(html: 'Welcome to Error Master with a working database!')
  end
end
