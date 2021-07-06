class AddAuthorIdToTales < ActiveRecord::Migration[6.0]
  def change
    add_column :tales, :author_id, :integer
  end
end
