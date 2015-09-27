require_relative 'constants'
require_relative 'base'
include Constant

def get_emails_from_exhibitor
  puts "processing emails from exhibitor"
  emails = []
  links = []
  browser = Watir::Browser.new :firefox
  browser.goto EXHIBITOR_URL
  browser.td(:class=>"title").wait_until_present # once this happens, the ajax for the pages have been loaded
  browser.tbodys.each do |tbody|
    links += tbody.links.collect {|ele| ele.attribute_value('href')}
  end

  links[0..3].each do |link|
    puts '###### going to page with possible email %s' % link
    browser.goto(link)
    email_link = browser.div(:id=>"popemail").a
    begin
      email_link.wait_until_present(4)
      emails << [email_link.text]
    rescue
      puts 'timed out. probably no e-mail present'
    end
    sleep DELAY
  end
  save_bulk(emails, EXHIBITOR_URL, force:true)
  browser.close
  return emails
end