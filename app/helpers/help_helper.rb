module HelpHelper
  def used_for_options
    Counseling::USED_FOR_OPTIONS.map { |key, value| [value, key] }
  end

  def gender_options
    Counseling::GENDER_OPTIONS.map { |key, value| [value, key] }
  end

  def marital_status_options
    Counseling::MARITAL_STATUS_OPTIONS.map { |key, value| [value, key] }
  end
end