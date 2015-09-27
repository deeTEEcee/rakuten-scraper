module Constant
  DELAY = 1 # delay between clicking each link
  EMAIL_MAX = 1000

  ITP_URL = 'http://itp.ne.jp/'
  EXHIBITOR_URL = 'http://exhibitor.f2ff.jp/dsj/companylist/'
  RAKUTEN_SHOP_URL = 'http://www.rakuten.co.jp/shop/'
  URLS = [RAKUTEN_SHOP_URL]

  EXCLUDE_EMAILS = ['no-reply-rakuten-box@rakuten.co.jp']
  EMAIL_REGEX = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i
  module CSS
    module Rakuten
      CATEGORY_LIST = 'div#RJSCategoryMenu div div div div dl.shpTpGenre span.shpTpGnrCategory a'
      SHOP_LIST = "td[width='80%'] table tr[valign='top'] > td" # more specifically, shop list and extra metadata
      SHOP_CURRENT_PAGE = SHOP_LIST + " > table[cellspacing='3'] td:not(nowrap) > font > b"
    end
  end
end