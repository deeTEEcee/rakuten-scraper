class CreateMarketingStores < ActiveRecord::Migration
  def change
    create_table :marketing_stores do |t|
      t.integer :site_id
      t.string :source_url
      t.string :email
      t.string :extra_emails
      t.text :extra_data

      t.timestamps
    end
  end
end
