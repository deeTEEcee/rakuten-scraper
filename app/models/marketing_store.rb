class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class MarketingStore < ActiveRecord::Base
  belongs_to :site, foreign_key: 'site_id', class_name: 'MarketingSite'

  serialize :extra_emails, Array
  validates :email, uniqueness: true, email:true
end
