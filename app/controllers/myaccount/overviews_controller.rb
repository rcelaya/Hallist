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
    if @user.update_attributes(params[:user])
      redirect_to myprofile_path, notice: "Successfully updated user."
    else
      render :edit
    end
  end

  private

  def selected_myaccount_tab(tab)
    tab == 'profile'
  end

end
