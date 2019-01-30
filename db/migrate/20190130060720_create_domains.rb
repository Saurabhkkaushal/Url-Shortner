class CreateDomains < ActiveRecord::Migration[5.2]
  def change
    create_table :domains do |t|
      t.string :long_domain , null: false , uniqueness: true
      t.string :short_domain , null: false , uniqueness: true
      t.timestamps
    end
  end
end
