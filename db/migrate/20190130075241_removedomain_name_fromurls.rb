class RemovedomainNameFromurls < ActiveRecord::Migration[5.2]
  def change
  	remove_column :urls, :domain_name , :string
  end
end
