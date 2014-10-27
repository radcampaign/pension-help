class PageEmail < ActiveRecord::Base
  @@PAGE_TITLES = {
    'news' => 'Pensions in the News',
    'help' => 'Pension Help',
    'home' => 'Home',
    'search' => 'Pension Search',
    'pals' => 'Pension Pals',
    'about_us' => 'About PensionHelp America',
    'privacy' => 'Privacy Policy',
    'terms_of_use' => 'Terms of Use',
    'feedback' => 'Feedback'
  }

  #returns page title for given url path (eg '/help/counseling')
  def PageEmail.get_page_title(key)
    if (key.blank?)
      result = @@PAGE_TITLES['home']
    else
      #find a page title from /controller/action/....
      stripped_keys = key.split('/')
      key = stripped_keys.size < 2 ? 'home' : stripped_keys[1]
      result = @@PAGE_TITLES[key].nil? ? @@PAGE_TITLES['home'] : @@PAGE_TITLES[key]
    end
    return result
  end

  validates_presence_of :name, :message => "^Your name"
  validates_presence_of :recipient_name, :message => "^Your friend's name"
  validates_presence_of :recipient_email, :message => "^Your friend's email address"
end
