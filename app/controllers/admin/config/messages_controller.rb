class Admin::Config::MessagesController < Admin::Config::BaseController
  
  def index
    @notices = Notice.all
  end
  
  def new
    @notice = Notice.new
  end
  
  def create
    @notice = Notice.new params[:notice]
    if @notice.save
      redirect_to(admin_config_messages_url, :notice => 'Message was successfully created.')
    else
      render :new
    end
  end
  
  def edit
    @notice = Notice.find params[:id]
  end
  
  def update
    @notice = Notice.find params[:id]
    if @notice.update_attributes params[:notice]
      redirect_to(admin_config_messages_url, :notice => 'Message was successfully updated.')
    else
      render :edit
    end
  end
end
