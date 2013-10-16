class UserObserver < ActiveRecord::Observer
  
  def after_save(user)
    if user.changed.include? 'sells_counter'
      Badge.find(7).grant_to(user) if user.sells_counter == 1
      Badge.find(8).grant_to(user) if user.sells_counter == 5
      Badge.find(9).grant_to(user) if user.sells_counter == 10
      Badge.find(10).grant_to(user) if user.sells_counter == 20
      Badge.find(11).grant_to(user) if user.sells_counter == 50
      Badge.find(12).grant_to(user) if user.sells_counter == 100
      Badge.find(13).grant_to(user) if user.sells_counter == 500
    end
    
    if user.changed.include? 'shoppings_counter'
      Badge.find(17).grant_to(user) if user.shoppings_counter == 10
      Badge.find(18).grant_to(user) if user.shoppings_counter == 25
      Badge.find(19).grant_to(user) if user.shoppings_counter == 50
    end
  end
end
