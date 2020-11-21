class FriendshipsController < ApplicationController
  include SessionsHelper
  before_action :logged_in

  def create
    existfriend = current_user.friendships
    puts existfriend
    existfriend.each do |friend|
      if friend.friend_id == params[:friend_id]
        flash[:info] = "好友已存在"
        redirect_to chats_path
        return
      end
    end
    existfriend = current_user.inverse_friendships
    existfriend.each do |friend|
      if friend.user_id == params[:friend_id]
        flash[:info] = "好友已存在"
        redirect_to chats_path
        return
      end
    end

    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    if @friendship.save
      flash[:info] = "添加好友成功"
      redirect_to chats_path
    else
      flash[:error] = "无法添加好友"
      redirect_to chats_path
    end
  end

  def destroy
    @friendship = current_user.friendships.find_by(friend_id: params[:id])
    if @friendship.nil?
      @friendship = current_user.inverse_friendships.find_by(user_id: params[:id]);
    end
    if @friendship.nil?
      flash[:success] = "删除好友成功"
      redirect_to chats_path
      return
    end
    @friendship.destroy

    user=User.find_by_id(params[:id])
    current_user.chats.each do |chat|
      if (chat.users-[user, current_user]).blank?
        chat.destroy
      end
    end

    flash[:success] = "删除好友成功"
    redirect_to chats_path
  end

  private
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

end
