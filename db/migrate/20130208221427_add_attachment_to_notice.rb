class AddAttachmentToNotice < ActiveRecord::Migration
  def change
    add_attachment :notices, :image
  end
end
