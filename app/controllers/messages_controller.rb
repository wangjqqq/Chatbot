class MessagesController < ApplicationController
  include SessionsHelper
  before_action :set_message, only: [:update, :destroy]

  def create
    @message = current_user.messages.build(message_params)
    chat=Chat.find_by_id(params[:chat_room])
    # redirect_to chats_path, flash: {:warning => '此聊天不存在'} and return if chat.nil?
    # @message.chat=chat
    # if @message.save
    #   sync_new @message, scope: chat
    # else
    #   redirect_to chat_path(chat), flash: {:warning => '消息发送失败'} and return
    # end
    # redirect_to chat_path(chat)

    respond_to do |format|
      if chat.nil?
        format.json {render json: {success: "1", msg: "此聊天不存在"}}
      else
        @message.chat=chat
        if @message.save
          sync_new @message, scope: chat
          format.js
          format.json {render json: {success: "0", msg: "发送成功"}}
        else
          format.json {render json: {success: "1", msg: "消息发送失败"}}
        end
      end
    end
    
  end

  def destroy
    @message = Message.find(params[:id])
    chat=Chat.find_by_id(params[:chat_room])
    @message.destroy
    sync_destroy @message
    redirect_to chat_path(chat)
  end

  def destroyall
    chat=Chat.find_by_id(params[:chat_room])
    chat.messages.delete_all
    redirect_to chat_path(chat), flash: {info: '聊天记录已清空'}
  end

  def sendtorobot
    msg = Message.new(body: params[:body], user_id: current_user.id, chat_id: params[:chat_room])
    msg.save
    retmsg = post_turing(params[:targeturl], params[:body])
    retmsg = "" if retmsg.nil?
    robot = User.find_by(email: "robot@test.com")
    msg2 = Message.new(body: retmsg, user_id: robot[:id], chat_id: params[:chat_room])
    msg2.save unless retmsg == ""

    chat=Chat.find_by_id(params[:chat_room])
    respond_to do |format|
      sync_new msg, scope: chat
      sync_new msg2, scope: chat
      format.js
      format.json {render json: {ret_msg: retmsg}}
    end
  end

  private
  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end

# def update
#   respond_to do |format|
#     if @message.update(message_params)
#       format.html { redirect_to @message, notice: 'Message was successfully updated.' }
#       format.json { render :show, status: :ok, location: @message }
#     else
#       format.html { render :edit }
#       format.json { render json: @message.errors, status: :unprocessable_entity }
#     end
#   end
# end
