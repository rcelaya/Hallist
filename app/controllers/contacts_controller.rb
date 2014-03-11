class ContactsController < ApplicationController
  def index
  end

  def newsletter testing=false
    return true if (Rails.env.test? && !testing)
    list_id = 'e32567f442'

    response = Rails.configuration.mailchimp.lists.subscribe({
                                                                 id: list_id,
                                                                 email: {email: params[:email]},
                                                                 double_optin: false,
                                                             })
    response
    #gb = Gibbon::API.new("35b67fc98e8508fca88e64c945f273cd")
    #gb.lists.subscribe({:id => 'e32567f442', :email => {:email => params[:email]}, :merge_vars => {:FNAME => 'First Name', :LNAME => 'Last Name'}, :double_optin => false})
   #gb.lists.subscribe(:id => 'e32567f442', :email_address => params[:email])

    #puts Gibbon::API.lists.list.to_yaml

    redirect_to root_url
  end
end
