class RemoveshortDomainurls < ActiveRecord::Migration[5.2]
  def change
  	remove_column :urls , :short_domain
  end
end
