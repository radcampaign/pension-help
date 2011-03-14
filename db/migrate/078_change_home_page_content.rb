class ChangeHomePageContent < ActiveRecord::Migration
  def self.up

    text = "<p><img class=\"margbottom10\" src=\"/images/welcome-to-pha.png\" border=\"0\" width=\"508\" height=\"45\" /></p>
              <p class=\"border-bottom intro\">PensionHelp America is a network of non-profit organizations, government agencies, and private professionals dedicated to providing pension information and assistance to America's workers, retirees and their families.</p>
              <p><a href=\"/help/counseling\"><img class=\"margbottom10\" src=\"images/find-help-now.png\" border=\"0\" width=\"422\" height=\"92\" /></a></p>"
     content = Content.find_by_url_and_is_active('/', true)
     content.update_attribute :content, text
  end

  def self.down
    #no revert, use form
  end
end
