class MessagesController < ApplicationController
  # protect_from_forgery with: :exception
  include SessionsHelper
  skip_before_action :verify_authenticity_token
  before_action :set_message, only: [:update, :destroy]

  def create
    @message = current_user.messages.build(message_params)
    # Rails.logger.info(current_user.id)
    # Rails.logger.info(@message.user_id)
    now_sender = User.find_by(id: @message.user_id)#根据id查询发送者的名字
    Rails.logger.info(current_user.id)
    Rails.logger.info(@message.body)
    Rails.logger.info(@message.body[0,10])
    Rails.logger.info(@message.body[-1])
    ret_str="0"
    if "!@#$%^&*()"==@message.body[0,10]
      if current_user.id.to_s==@message.body[-1]
        ret_str = "1"
      end
      respond_to do |format|
        #format.js
      format.json {render json: {isyourself: ret_str}}
      end
      return
    end

    chat=Chat.find_by_id(params[:chat_room])


    respond_to do |format|
      if chat.nil?
        format.json {render json: {success: "1", msg: "此聊天不存在"}}
      else
        @message.chat=chat
        if @message.save
          Rails.logger.info(@message.user_id)
          now_sender = User.find_by(id: @message.user_id)#根据id查询发送者的名字
          Rails.logger.info(now_sender.name)
          Rails.logger.info(current_user.id)
          # Rails.logger.info(@message.id)
          # Rails.logger.info(@message.body)
          # Rails.logger.info(@message.user_id)
          # Rails.logger.info(@message.chat_id)
          if current_user.id==@message.user_id
          ActionCable.server.broadcast "chat_channel" , chat:chat ,body:@message.body ,sender_name:now_sender.name,isyourself:true ,sender_id:@message.user_id
          else
          ActionCable.server.broadcast "chat_channel" , chat:chat ,body:@message.body ,sender_name:now_sender.name,isyourself:false ,sender_id:@message.user_id
          end
          # Rails.logger.info(@message)
          # Rails.logger.info(chat)
          sync_new @message, scope: chat
          format.js
          format.json {render json: {success: "0", msg: "发送成功"}}

        else
          Rails.logger.info('send failed')
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

