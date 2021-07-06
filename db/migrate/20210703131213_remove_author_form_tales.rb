class RemoveAuthorFormTales < ActiveRecord::Migration[6.0]
  def change
    remove_column :tales, :autthor, :string
  end
end
