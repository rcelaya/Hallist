class Myaccount::OverviewsController < Myaccount::BaseController
  layout 'no-responsive'

  def show
    redirect_to profile_path(current_user)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @username = params[:user][:profile_attributes][:username]
    if @username == @user.profile.username
      if @user.update_attributes(params[:user])
        redirect_to edit_myaccount_overview_path, notice: "Successfully updated user."
      else
        render :edit
      end
    else
      if Profile.find_by_username(@username)
        flash[:notice] = "Username already registered. Please enter a new username!"
        render :edit
      else
        if @user.update_attributes(params[:user])
          redirect_to edit_myaccount_overview_path, notice: "Successfully updated user."
        else
          render :edit
        end
      end
    end
  end

  private
  def selected_myaccount_tab(tab)
    tab == 'profile'
  end
end
