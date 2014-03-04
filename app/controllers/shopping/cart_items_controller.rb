class Shopping::CartItemsController < Shopping::BaseController


  # POST /shopping/cart_items
  # POST /shopping/cart_items.xml
  def create
    @cart_item = get_new_cart_item
    session_cart.save if session_cart.new_record?
    qty = params[:cart_item][:quantity].to_i
    qty = (qty > 0)? qty : 1
    @item = session_cart.add_variant(params[:cart_item][:variant_id], most_likely_user, qty)
    redirect_to checkout_shopping_order_url('checkout')
    #if current_user.nil?
     # redirect_to checkout_shopping_order_url('checkout')
    #else
     # js_redirect_to(checkout_shopping_order_url('checkout'))
    #end
    #respond_to do |format|
     # format.js {redirect_to checkout_shopping_order_url('checkout')}
    #end
  end

  def js_redirect_to(path)
    render js: %(window.location.href='#{path}') and return
  end

  # PUT /carts/1
  # PUT /carts/1.xml
  def update
    #@cart_item = session_cart.shopping_cart_items.find(params[:id])

    respond_to do |format|
      if session_cart.update_attributes(params[:cart])
        if params[:commit] && params[:commit] == "checkout"
          format.html { redirect_to( checkout_shopping_order_url('checkout')) }
        else
          format.html { redirect_to(shopping_cart_items_url(), :notice => I18n.t('item_passed_update') ) }
        end
      else
        format.html { redirect_to(shopping_cart_items_url(), :notice => I18n.t('item_failed_update') ) }
      end
    end
  end
## TODO
  ## This method moves saved_cart_items to your shopping_cart_items or saved_cart_items
  #   this method is called using AJAX and returns json. with the object moved,
  #   otherwise false is returned if there is an error
  #   method => PUT
  def move_to
      @cart_item = session_cart.cart_items.find(params[:id])

      respond_to do |format|
        if @cart_item.update_attributes(:item_type_id => params[:item_type_id])
          format.html { redirect_to(shopping_cart_items_url() ) }
        else
          format.html { redirect_to(shopping_cart_items_url(), :notice => I18n.t('item_failed_update') ) }
        end
      end
  end

  # DELETE /carts/1
  # DELETE /carts/1.xml
  def destroy
    session_cart.remove_variant(params[:variant_id]) if params[:variant_id]
  end

  private

  def get_new_cart_item
    if current_user.present?
      #puts 'session cart' + session_cart.cart_items.to_yaml
      session_cart.cart_items.new(params[:cart_item].merge({:user_id => current_user.try(:id)}))
    else
      ###  ADD to session cart
      session_cart.cart_items.new(params[:cart_item])
    end
  end

end
