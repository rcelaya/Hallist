class AuthenticationsController < ApplicationController

  def create
      omniauth = request.env['omniauth.auth']
      authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      #puts 'modelooo_face' + omniauth.to_yaml
      #puts 'modelooo_face' + authentication.to_yaml
      if authentication
        #puts 'authentication'
        # User is already registered with application        
        flash[:info] = 'Signed in successfully.'

        sign_in_and_redirect(authentication.user)
      elsif current_user.user
        #puts 'current user'
        # User is signed in but has not already authenticated with this social network
        current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
        current_user.apply_omniauth(omniauth)
        current_user.save

        flash[:info] = 'Authentication successful.'
        redirect_to root_url
      else
        #puts 'entro new to aplication'
        # User is new to this application
        user = User.find_or_initialize_by_email(omniauth['extra']['raw_info']['email'])
        #puts 'userrr' + user.to_yaml
        user.apply_authorization

        if user.save!
          #puts 'save'
          user.apply_omniauth(omniauth)
          flash[:info] = 'User created and signed in successfully.'
          sign_in_and_redirect(user)
        else
          session[:omniauth] = omniauth.except('extra')
          redirect_to signup_path
        end
      end
    end

    def destroy
      @authentication = current_user.authentications.find(params[:id])
      @authentication.destroy
      flash[:notice] = 'Successfully destroyed authentication.'
      redirect_to authentications_url
    end

    private
    def sign_in_and_redirect(user)
      create_session(user)
      redirect_to root_path
    end
    
    def create_session(user)
      @user_session = UserSession.new(user, true)
      if @user_session.save
        cookies[:hadean_uid] = @user_session.record.access_token
        session[:authenticated_at] = Time.now
        cookies[:insecure] = true
        ## if there is a cart make sure the user_id is correct
        set_user_to_cart_items
      end
    end    
    
    def set_user_to_cart_items
      if session_cart.user_id != @user_session.record.id
        session_cart.update_attributes(:user_id => @user_session.record.id )
      end
      session_cart.cart_items.each do |item|
        item.update_attributes(:user_id => @user_session.record.id ) if item.user_id != @user_session.record.id
      end
    end
end