class CounselAssistance
  
  def self.find_plan(id)
    case id
      when "PRV_PLAN"
        "Company or nonprofit"
      when "RR_PLAN"
        "Railroad"
      when "RI_PLAN"
        "Religious institution"
      when "GOV_PLAN"
        "Federal agency or office"
      when "MIL_SRV"
        "Military"
      when "ST_PLAN"
        "State agency or office"
      when "CO_PLAN"
        "County agency or office"
      when "LOC_PLAN"
        "City or other local government agency or office"
      else 
        "Unspecified Plan"
    end
  end
  
  def self.states
    [["GA","GA"]]
  end
  
  def self.counties
    [["Clarke","Clarke"],
     ["Cobb","Cobb"],
     ["Dekalb","Dekalb"],
     ["Fulton","Fulton"]]
  end
  
  def self.localities
    [["Acworth","Acworth"],
     ["Marietta","Marietta"],
     ["Roswell","Roswell"]]
  end

  def self.employer_types
    [["Private employer","PRV_EMP"],
     ["Government employer","GOV_EMP"],
     ["I don't know","IDK_EMP"]]
  end
  
  def self.private_employer_types
    [["Company or nonprofit","PRV_PLAN"],
     ["Railroad","RR_PLAN"],
     ["Religious institution","RI_PLAN"],
     ["I don’t know","IDK_PRV_EMP"]]
  end
  
  def self.government_employer_types
    [["Federal agency or office","GOV_PLAN"],
     ["Military","MIL_SRV"],
     ["State agency or office","ST_PLAN"],
     ["County agency or office","CO_PLAN"],
     ["City or other local government agency or office","LOC_PLAN"],
     ["I don't know","IDK_GOV_EMP"]]
  end
  
  def self.government_plans
    [["Federal Employee Retirement System (FERS)","FERS"],
     ["Civil Service Retirement System (CSRS)","CSRS"],
     ["Thrift Savings Plan (TSP)","TSP"],
     ["Other","FERS"],
     ["I don’t know","IDK_FED_PLAN"]]
  end
  
  def self.military_service_types
    [["Uniformed services Active duty","UNI_MIL"],
     ["Armed services Ready Reserve","UNI_MIL"],
     ["Armed services National Guard","UNI_MIL"],
     ["Civilian military employment","CIVIL_MIL"],
     ["I don’t know","UNI_MIL"]]
  end
  
  def self.military_employer_types
    [["Army and Air Force Exchange Service","AFES"],
     ["Navy Exchange Service Command","NESC"],
     ["Marine Corps Exchanges","MCE"],
     ["Non-Appropriated Funds Instrumentality","NAFI"],
     ["I don’t know","AFES"]]
  end
  
  def self.uniformed_service_branches
    [["Army","ARMY"],
     ["Navy","NAVY"],
     ["Air Force","AF"],
     ["Coast Guard","CG"],
     ["National Oceanic and Atmospheric Administration Commissioned Corps","NOAACC"],
     ["U.S. Public Health Service Commissioned Corps","PHSCC"],
     ["I don’t know","ARMY"]]    
  end
  
  def self.state_employer_types
    [["Teacher","T"],
     ["Judge","J"],
     ["Elected Official","EO"],
     ["Police","P"],
     ["Firefighter","FF"],
     ["Other public employee","OTHER"],
     ["I don’t know","OTHER"]]
  end
  
  def self.county_employer_types
    [["Teacher","T"],
     ["Judge","J"],
     ["Elected Official","EO"],
     ["Police","P"],
     ["Firefighter","FF"],
     ["Other public employee","OTHER"],
     ["I don’t know","OTHER"]]
  end
  
  def self.local_employer_types
    [["Teacher","T"],
     ["Judge","J"],
     ["Elected Official","EO"],
     ["Police","P"],
     ["Firefighter","FF"],
     ["Other public employee","OTHER"],
     ["I don’t know","OTHER"]]
  end
  
  def self.pension_earner_choices
    [["I earned the pension","1"],
     ["My (current, former or deceased) spouse earned the pension","2"],
     ["Other","3"]]
  end

end
