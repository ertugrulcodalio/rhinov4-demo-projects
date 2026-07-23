class AddSlugToOrganizations < ActiveRecord::Migration[8.0]
  def change
    add_column :organizations, :slug, :string
    add_index :organizations, :slug, unique: true
  end
end