module HelpHelper
  def behalf_options
    Counseling::BEHALF_OPTIONS.map { |key, value| [value, key] }
  end

  def gender_options
    Counseling::GENDER_OPTIONS.map { |key, value| [value, key] }
  end

  def marital_status_options
    Counseling::MARITAL_STATUS_OPTIONS.map { |key, value| [value, key] }
  end

  def ethnicity_options
    Counseling::ETHNICITY_OPTIONS.map { |key, value| [value, key] }
  end
end