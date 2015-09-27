class MarketingSite < ActiveRecord::Base
  has_many :stores, foreign_key: 'site_id', class_name: 'MarketingStore'
  validates_uniqueness_of :url
end