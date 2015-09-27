class CreateMarketingSites < ActiveRecord::Migration
  def change
    create_table :marketing_sites do |t|
      t.string :url

      t.timestamps
    end
  end
end
