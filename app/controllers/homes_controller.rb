class HomesController < ApplicationController
	include SessionsHelper
  def home
  	redirect_to chats_path if logged_in?
  end
end
