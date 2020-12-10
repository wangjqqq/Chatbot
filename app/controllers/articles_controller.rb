class ArticlesController < ApplicationController
  include SessionsHelper
  include ChatsHelper
	def create
 		if params[:article][:content] == "" && params[:article][:picture].nil?
			redirect_to chats_path, flash: {"error": "还没有写心情呢"}
			return
		end
 		article = Article.new(get_params)
		if article.save!
			redirect_to chats_path, flash: {"success": "发送成功"}
		else
			redirect_to chats_path, flash: {"warning": "发送失败"}
		end
	end

	def destroy
		article = Article.find_by_id(params[:id])
		article.destroy
		redirect_to chats_path, flash: {"success": "刪除成功"}
	end

	def show
		if params[:id].to_s == current_user.id.to_s
			redirect_to chats_path
			return
		end
    @friends=current_user.friends+current_user.inverse_friends
    @userinfo = User.find_by_id(params[:id])
    @onlineusers = @userinfo.friends+@userinfo.inverse_friends-[current_user]-current_user.friends-current_user.inverse_friends
    @selfarticle = @userinfo.articles
    @currentallchat = current_user.chats
    @onlinefriends = @friends-[@userinfo]-(User.all-@userinfo.friends-@userinfo.inverse_friends)
    @newfootstep = Footstep.new
    @footstepall = @userinfo.footsteps
	end

	def update
		art = Article.find_by_id(params[:id])
		cnt = art[:like] + 1;
		art.update_attributes(like: cnt)
		respond_to do |format|
			format.json {render json: {success: cnt}}
		end
	end

	def get_params
		params[:article][:user_id] = params[:user_id]
		params.require(:article).permit(:user_id, :content, :picture)
	end
end
