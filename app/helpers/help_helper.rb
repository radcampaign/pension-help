module HelpHelper
  def used_for_options
    Counseling::USED_FOR_OPTIONS.map { |key, value| [value, key] }
  end
end