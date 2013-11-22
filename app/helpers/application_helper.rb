module ApplicationHelper

  ### The next three helpers are great to use to add and remove nested attributes in forms.
  #  LOK AT THIS WEBPAGE FOR REFERENCE
  ## http://openmonkey.com/articles/2009/10/complex-nested-forms-with-rails-unobtrusive-jquery
=begin
EXAMPLE USAGE!!
  <% form.fields_for :properties do |property_form| %>
    <%= render :partial => '/admin/merchandise/add_property', :locals => { :f => property_form } %>
  <% end %>
  <p><%= add_child_link "New Property", :properties %></p>
  <%= new_child_fields_template(form, :properties, :partial => '/admin/merchandise/add_property')%>
=end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def site_name
    I18n.t(:company)
  end

  def remove_child_link(name, f)
    f.hidden_field(:_destroy) + link_to(name, "javascript:void(0)", :class => "remove_child")
  end

  def add_child_link(name, association)
    link_to(name, "javascript:void(0);", :class => "add_child", :"data-association" => association)
  end
  
  def add_child_button(name, association)
    link_to(name, "javascript:void(0);", :class => "add_child button", :"data-association" => association)
  end
  
  def artwork_index_title
    if params[:filters] && params[:filters][:product_type_id].present?
      product_type = ProductType.find(params[:filters][:product_type_id])
      "Category: #{product_type.name}"
    elsif params[:filters] &&  params[:filters][:property_values_id].present?
      property_value = PropertyValue.find(params[:filters][:property_values_id])
      "Color: #{property_value.name}"
    elsif params[:filters] && params[:filters][:price].present?
      "Price: #{number_to_currency(params[:filters][:price][:from])} #{"- " + number_to_currency(params[:filters][:price][:to]) if params[:filters][:price][:to].present?}"
    elsif params[:filters] && params[:filters][:search].present?
      "Search: #{params[:filters][:search]}"
    else
      "Recent Artworks"
    end
  end

  def new_child_fields_template(form_builder, association, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new
    options[:partial] ||= association.to_s.singularize
    options[:locals] ||= {}
    options[:form_builder_local] ||= :f

    content_tag(:div, :id => "#{association}_fields_template", :style => "display: none") do
      form_builder.fields_for(association, options[:object], :child_index => "new_#{association}") do |f|
        raw(render(:partial => options[:partial], :locals => {options[:form_builder_local] => f }.merge(options[:locals])) )
      end
    end
  end
  
  def collection_button(product)
    if current_user.user
      content_tag :div, class: 'btn btn-mini add-to-collection-button', 'data-product-id' => product.friendly_id do
        content_tag(:span) do
          'To Hall'
        end
      end
    else
      content_tag :div, class: 'btn btn-mini add-to-collection-button', 'data-user-login' => false do
        content_tag(:span) do
          'To Hall'
        end
      end
    end
  end
  
  def like_button(product)
    options = if current_user.user
      {class: "btn btn-mini like-button #{'liked' if current_user.likes?(product)}", 'data-product-id' => product.friendly_id, 'data-like-action' => (current_user.likes?(product) ? 'unlike' : 'like' )}
    else
      {class: 'btn btn-mini like-button', 'data-user-login' => false, 'data-product-id' => product.friendly_id}
    end
    content_tag :div, options do
      content_tag(:span) do
        (current_user.user && current_user.likes?(product)) ? 'Unlike' : 'Like'
      end
    end
  end
  
  def follow_link(artist)
    if current_user.user
      link_to (current_user.follows?(artist) ? 'Unfollow' : 'Follow'), artist_follows_path(artist), method: (current_user.follows?(artist) ? :delete : :post), remote: true, id: 'follow-link'
    else
      link_to  'Follow', '', 'data-user-login' => false, id: 'follow-link', class: 'login-link'
    end
  end
  
  def url_with_protocol(url)
    /^http/.match(url) ? url : "http://#{url}"
  end

end
