module PartnersHelper
  
  def consultation_fee_display
    @partner.consultation_fee_str || number_to_currency(@partner.consultation_fee.to_s, :precision => 2)
  end
  
  def hourly_rate_display
    @partner.hourly_rate_str || number_to_currency(@partner.hourly_rate.to_s, :precision => 2)
  end  
  
end
