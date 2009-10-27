module PartnersHelper
  
  def consultation_fee_display
    @partner.consultation_fee_str || number_to_currency(@partner.consultation_fee.to_s, :precision => 2)
  end
  
  def hourly_rate_display
    @partner.hourly_rate_str || number_to_currency(@partner.hourly_rate.to_s, :precision => 2)
  end

  def sponsor_type_class_display(item)
    html_class= ''
    html_class << (item.use_for_pal ? 'use_for_pal ' : '')  
    html_class << (item.use_for_search ? 'use_for_search ' : '')
    html_class << (item.use_for_npln ? 'use_for_npln ' : '')
    html_class << (item.use_for_help ? 'use_for_help' : '')
    html_class.strip
  end
  
  def plan_type_class_display(item)    
   if item.use_for_pal
     'use_for_pal use_for_npln use_for_help'
   else
     'use_for_npln use_for_help'
   end
  end

  def refferals_class_display(item)
     plan_type_class_display(item) 
  end
  
end
