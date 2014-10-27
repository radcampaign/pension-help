module PartnersHelper
  def sponsor_type_class_display(item)
    html_class= ''
    html_class << (item.use_for_pal ? 'use_for_pal ' : '')
    html_class << (item.use_for_search ? 'use_for_search ' : '')
    html_class << (item.use_for_npln ? 'use_for_npln ' : '')
    html_class << (item.use_for_help ? 'use_for_help ' : '')
    html_class << 'remove_on_submit'
    html_class.strip
  end

  def plan_type_class_display(item)
   if item.use_for_pal
     'use_for_pal use_for_npln use_for_help remove_on_submit'
   else
     'use_for_npln use_for_help remove_on_submit'
   end
  end

  def refferals_class_display(item)
     plan_type_class_display(item)
  end
end