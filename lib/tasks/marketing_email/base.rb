# helper methods
def save_bulk(emails, url, force: false)
  if emails.count >= EMAIL_MAX or force
    site_model = MarketingSite.find(url: url)
    emails = emails.uniq
    marketing_emails = emails.map! {|ele| ele.unshift(site_model.id)}
    MarketingEmail.import [:site_id,:email], marketing_emails # note: marketing_emails changes afterwards
    emails = []
    return true
  end
  return false
end