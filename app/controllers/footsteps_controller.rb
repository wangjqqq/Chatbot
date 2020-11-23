class FootstepsController < ApplicationController
  include SessionsHelper
  include ChatsHelper
	def create
		if params[:post][:body] == ""
			redirect_to article_path(params[:user_id]), flash: {"error": "还没有留下足迹"}
			return
		end
		footst = Footstep.new(user_id: params[:user_id], content: params[:post][:body], footstepuser_id: params[:footstepuser_id])
		if footst.save
			redirect_to article_path(params[:user_id]), flash: {"success": "足迹成功留下"}
		else
			redirect_to article_path(params[:user_id]), flash: {"error": "留下足迹失败"}
		end
	end
end
