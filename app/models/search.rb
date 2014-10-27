
class Search
  attr_accessor :company_name
  attr_accessor :state
  attr_accessor :zip_code

  def initialize(args = nil)
    unless args.nil?
      @company_name = args[:company_name]
      @state = args[:state]
      @zip_code = args[:zip_code]
    end
  end
  
  def self.get_states
    [['Select a State', 'None'],
	['Alabama', 'AL'], 
	['Alaska', 'AK'],
	['Arizona', 'AZ'],
	['Arkansas', 'AR'], 
	['California', 'CA'], 
	['Colorado', 'CO'], 
	['Connecticut', 'CT'], 
	['Delaware', 'DE'], 
	['District Of Columbia', 'DC'], 
	['Florida', 'FL'],
	['Georgia', 'GA'],
	['Hawaii', 'HI'], 
	['Idaho', 'ID'], 
	['Illinois', 'IL'], 
	['Indiana', 'IN'], 
	['Iowa', 'IA'], 
	['Kansas', 'KS'], 
	['Kentucky', 'KY'], 
	['Louisiana', 'LA'], 
	['Maine', 'ME'], 
	['Maryland', 'MD'], 
	['Massachusetts', 'MA'], 
	['Michigan', 'MI'], 
	['Minnesota', 'MN'],
	['Mississippi', 'MS'], 
	['Missouri', 'MO'], 
	['Montana', 'MT'], 
	['Nebraska', 'NE'], 
	['Nevada', 'NV'], 
	['New Hampshire', 'NH'], 
	['New Jersey', 'NJ'], 
	['New Mexico', 'NM'], 
	['New York', 'NY'], 
	['North Carolina', 'NC'], 
	['North Dakota', 'ND'], 
	['Ohio', 'OH'], 
	['Oklahoma', 'OK'], 
	['Oregon', 'OR'], 
	['Pennsylvania', 'PA'], 
	['Rhode Island', 'RI'], 
	['South Carolina', 'SC'], 
	['South Dakota', 'SD'], 
	['Tennessee', 'TN'], 
	['Texas', 'TX'], 
	['Utah', 'UT'], 
	['Vermont', 'VT'], 
	['Virginia', 'VA'], 
	['Washington', 'WA'], 
	['West Virginia', 'WV'], 
	['Wisconsin', 'WI'], 
	['Wyoming', 'WY']]
  end
end
