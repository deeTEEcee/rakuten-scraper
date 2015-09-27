require_relative 'constants'
require_relative 'base'
include Constant

# assuming we pass in the first page
def crawl_through_pagination_and_get_emails(current_page, count=3)
  puts '###### scraping page ######'
  sleep DELAY
  if count>=0
    emails = []
    current_page.search('.emailLink').each do |item|
      emails << [item.attributes["onclick"].value[/, '.*/].gsub(/[, ')]/,'')] # the element's link lies in a str attribute after the following characters: ', '
    end
    next_element = current_page.at('.bottomNav > ul > li.current').next_element.child # each element: <li> <a href> </li>
    if next_element
      next_page = Mechanize::Page::Link.new(next_element, $agent, $agent.page).click
      puts emails
      return emails + crawl_through_pagination_and_get_emails(next_page, count-1)
    else
      return emails
    end
  end
  return []
end

def get_emails_from_itp
  $agent.get(ITP_URL)
  puts "processing emails from itp"
  emails = []
  categories = $agent.page.links_with(:href=>%r{^\/genre_dir\/}).uniq {|obj| obj.href}
  categories.each do |category|
    puts '###### new category ######'
    sleep DELAY
    first_page = category.click
    emails += crawl_through_pagination_and_get_emails(first_page)
    save_bulk(emails, ITP_URL)
  end
  return emails
end