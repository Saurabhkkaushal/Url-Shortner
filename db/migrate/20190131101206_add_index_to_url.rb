class AddIndexToUrl < ActiveRecord::Migration[5.2]
  def change
  	add_index :urls , :short_url 
  	add_index :urls , :long_url
  end
end
