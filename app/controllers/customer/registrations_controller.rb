class Customer::RegistrationsController < ApplicationController
  
  layout 'no-responsive'
  
  def new
    @registration = true
    @user         = User.new
    @user.build_profile
    @user_session = UserSession.new
  end

  def create
    @user = User.new(params[:user])
    @user.format_birth_date(params[:user][:birth_date]) if params[:user][:birth_date].present?
    if Profile.find_by_username(params[:user][:profile_attributes][:username])
      flash[:notice] = "Username already registered. Please enter a new username!"
      redirect_to signup_path
    else
      # Saving without session maintenance to skip
      # auto-login which can't happen here because
      # the User has not yet been activated
      if @user.save_without_session_maintenance
        @user.create_username(params[:user][:profile_attributes][:username])
        @user.deliver_activation_instructions!
        UserSession.new(@user.attributes)
        flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
        redirect_to root_url
      else
        @registration = true
        @user_session = UserSession.new
        render :new
      end
    end
  end

end
