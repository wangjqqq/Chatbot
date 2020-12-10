class UsersController < ApplicationController
#   include SessionsHelper
#    include UsersHelper
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_user, except: [:index, :new, :index_json, :create]
  before_action :logged_in, only: [:show]
  before_action :correct_user, only: :show

  def new
    @user=User.new
  end

  def create
    @user=User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to chats_path, flash: {success: "创建成功"}
    elsif @user.errors[:name].any? 
        flash[:warning] = "用户名长度应少于255个字符，请重试"
        redirect_to new_user_path
    elsif @user.errors[:email].any?
        flash[:warning] = "邮箱错误，请使用正确邮箱"
        redirect_to new_user_path
    elsif @user.errors[:password].any?
        flash[:warning] = "密码长度应在6到18个字符之间，请重试"
        redirect_to new_user_path
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash={:info => "更新成功"}
    else
      flash={:warning => "更新失败"}
    end
    redirect_to chats_path, flash: flash
  end

  def destroy
    @user.destroy
    redirect_to users_path(new: false), flash: {success: "用户删除"}
  end

  def index
    unless logged_in?
        redirect_to root_path
    end
    # @users=User.search(params).paginate(:page => params[:page], :per_page => 10)
  end

  def index_json
    @users=User.search_friends(params, current_user)
    render json: @users.as_json
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :sex, :department_id, :password, :password_confirmation,
                                 :phonenumber, :status, :essay, :picture)
  end

# Confirms a logged-in user.
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def correct_user
    unless current_user == @user or current_user.role == 5
      redirect_to user_path(current_user), flash: {:danger => '您没有权限浏览他人信息'}
    end
  end

  def set_user
    @user=User.find_by_id(params[:id])
    if @user.nil?
      redirect_to root_path, flash: {:danger => '没有找到此用户'}
    end
  end

end
