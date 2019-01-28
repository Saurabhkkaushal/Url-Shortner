 class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :long_url,              null: false, default: ""
      t.string :short_url              null: false, default: ""

      ## Recoverable
      t.string   :domain_name          null: false, default: ""
      t.timestamps
    end
  end
end
