module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !current_user.nil?
  end

  # 点击log_out,安全退出.只关闭浏览器时会保存cookie,安全退出后就没有了
  def log_out
    forget_user(current_user)
    session.delete(:user_id)
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if session[:user_id]
      @current_user||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.user_authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def remember_user(user)
    user.user_remember
    # Because it places the id as plain text, this method exposes the form of the application’s cookies
    # and makes it easier for an attacker to compromise user accounts. To avoid this problem,
    # we’ll use a signed cookie, which securely encrypts the cookie before placing it on the browser:
    cookies.signed[:user_id] = {value: user.id, expires: 5.minutes.from_now.utc}
    cookies[:remember_token] = {value: user.remember_token, expires: 5.minutes.from_now.utc}
  end

  def forget_user(user)
    user.user_forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def post_turing(url, params)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true
    end
    begin
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json;charset=utf-8'
      request['User-Agent'] = 'Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0'
      request['X-ACL-TOKEN'] = 'xxx_token'
      #request.set_form_data(params)

      request.body = {
          "reqType":0,
          "perception": {
              "inputText": {
                  "text": params
              },
          },
          "userInfo": {
              "apiKey": "b33d22578a874c58818ae875596d942a",
              "userId": "344199"
          }
      }.to_json
      response = http.start { |http| http.request(request) }
      puts response.body.inspect
      result = JSON.parse response.body
      cn_reg = /[\u4e00-\u9fa5]{1}/
      cn_arr=result.to_s.scan(cn_reg).join;
      return cn_arr
      # return result
      #return JSON.parse response.body
      #return request.body
    rescue =>err
      return nil
    end
  end

end
