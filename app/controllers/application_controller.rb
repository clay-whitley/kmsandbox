class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :km_init

  def after_sign_in_path_for(user)
    widgets_path
  end

  def generate_identifier
    now = Time.now.to_i  
    Digest::MD5.hexdigest(
      (request.referrer || '') + 
      rand(now).to_s + 
      now.to_s + 
      (request.user_agent || '')
    )
  end

  def km_init
    KM.init(
      '3129e84edb9ef6053b738625cd4855017c8e120b',
      log_dir: File.expand_path('./log/km')
      )

    unless identity = cookies[:km_identity]
      identity = generate_identifier
      cookies[:km_identity] = {
        :value => identity, :expires => 5.years.from_now
      }
    end
  
    if current_user
      unless cookies[:km_aliased]
        KM.alias(identity, current_user.email)
        cookies[:km_aliased] = {
          :value => true,
          :expires => 5.years.from_now
        }
      end
      identity = current_user.email
    end
    KM.identify(identity)
  end
end
