class MyNewMigration < ActiveRecord::Migration[5.2]
  def change
  	change_column :urls, :long_url, :string, :null => false , uniqueness: true
  end
end
