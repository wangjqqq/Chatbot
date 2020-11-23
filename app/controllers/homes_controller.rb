class HomesController < ApplicationController
    protect_from_forgery with: :exception
	include SessionsHelper
  def home
  	redirect_to chats_path if logged_in?
    #redirect_to chats_path
  end
end
