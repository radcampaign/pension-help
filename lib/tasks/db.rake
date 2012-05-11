namespace :db do
  task :seed => :environment do
    [
      Expertise,
      Assistance,
      Practice
    ].each { |klass| klass.destroy_all }

    Expertise.create! :name => "Private pension plans", :form => "pal"
    Expertise.create! :name => "403(b), 401(k) plans, & other DC-type plans", :form => "pal"
    Expertise.create! :name => "Government pension plans", :form => "pal"
    Expertise.create! :name => "IRAs, SEPs", :form => "pal"
    Expertise.create! :name => "Keoghs", :form => "pal"
    Expertise.create! :name => "Professional service providers", :form => "pal"
    Expertise.create! :name => "Church plans", :form => "pal"
    Expertise.create! :name => "Domestic relations orders", :form => "pal"
    Expertise.create! :name => "Plan changes", :form => "pal"
    Expertise.create! :name => "PBGC questions", :form => "pal"
    Expertise.create! :name => "Employment Discrimination/Labor Law (ED)", :form => "npln"
    Expertise.create! :name => "Health Care/COBRA (HC)", :form => "npln"
    Expertise.create! :name => "Social Security (SS)/Disability", :form => "npln"

    Assistance.create! :name => "Pro bono"
    Assistance.create! :name => "Reduced rate"
    Assistance.create! :name => "Standard fee"
    Assistance.create! :name => "Depends on the participant’s income and the time involved"

    Practice.create! :name => "Private entities: Single-employer"
    Practice.create! :name => "Private entities: Multi-employer"
    Practice.create! :name => "Federal Government (FERS/CSRS)"
    Practice.create! :name => "Military Retirement (DFAS)"
  end
end