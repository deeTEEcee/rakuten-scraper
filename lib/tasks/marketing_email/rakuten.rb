require_relative 'constants'
require_relative 'base'
include Constant

### helper methods for rakuten
def new_mech_link(node)
  return Mechanize::Page::Link.new(node, $agent, $agent.page)
end

# return true, false getting emails from the info page
def get_info_page_links(page)
  info_links = page.links_with(href: %r{info.html})
  if not info_links
    info_links = page.links_with(href: %r{aboutus.html})
  end
  if not info_links
    info_links = page.links_with(text: '会社概要')
  end
  return info_links
end

def get_company_info(outline_page)
  searchable_text = ['株式会社','有限会社']
  company_info = nil
  for text in searchable_text
    dt_nodes = outline_page.search("dt:contains('" + text + "')")
    for node in dt_nodes
      if node.parent and node.next_element
        company_info = node.parent.content
        break
      end
    end
  end
  return company_info

end

def create_store(outline_page)
  site = MarketingSite.find_by_url('http://www.rakuten.co.jp/shop/')
  store = MarketingStore.new(site: site,
                             source_url: outline_page.uri.to_s)
  emails = []
  emails_node = outline_page.search("a:contains('@')").select {|node| not EXCLUDE_EMAILS.include?(node.text)}

  # validate the emails
  for node in emails_node
    emails_from_node = node.text.split(',').select{|e| e[EMAIL_REGEX]}
    emails += emails_from_node
  end
  if emails
    store.email = emails[0]
    store.extra_emails = emails[1..-1]
    # get the company info only if we get the email
    store.extra_data = get_company_info(outline_page)
  end
  store.save
end

def process_rakuten
  $agent.get(RAKUTEN_SHOP_URL)
  main_page = $agent.page
  main_page.search(CSS::Rakuten::CATEGORY_LIST).each do |category|
    puts "New category"
    next_page = new_mech_link(category).click
    # in 1st page of a specific category
    while next_page
      shop_list_of_outline_links = next_page.links_with(text: '会社概要')
      for shop_link in shop_list_of_outline_links
        sleep DELAY
        outline_page = shop_link.click
        create_store(outline_page)
        binding.pry
      end
      current_page_ele = category_page.at(CSS::Rakuten::SHOP_CURRENT_PAGE)
      next_page_ele = current_page_ele.next_element
      if next_page_ele
        next_page = new_mech_link(next_page_ele).click if next_page_ele
      else
        next_page = nil
      end
    end
  end
end