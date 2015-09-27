require 'watir-webdriver'
require 'nokogiri'
require 'mechanize'
require 'activerecord-import'
require 'pry-byebug'
require 'pry-rails'
require 'pry-stack_explorer'
require 'pry-remote'

Dir[Rails.root.to_s+"/lib/tasks/marketing_email/*.rb"].each {|file| require file }
include Constant

Rails.logger = Logger.new(STDOUT) # for general messages
file_logger = Logger.new("#{Rails.root}/email_crawl.log") # for important messages like links we failed to go through


$agent = Mechanize.new { |agent|
  agent.robots = true
}

namespace :marketing_email do

  desc "init db seed for sites we're going to scrape"
  # initialize all the sites we're going to be scraping
  task init: :environment do
    for url in URLS
      if MarketingSite.where(url: url).empty?
        MarketingSite.create(url: url)
      end
    end
  end

 desc "get marketing mail from all the sites listed"
  task all: :environment do
    #emails = []
    for url in URLS
      case url
      when ITP_URL
        get_emails_from_itp
      when EXHIBITOR_URL
        get_emails_from_exhibitor
      when RAKUTEN_SHOP_URL
        process_rakuten
      else
        break
      end
    end
    #emails = emails.uniq
    #MarketingEmail.import [:email], emails
  end
end