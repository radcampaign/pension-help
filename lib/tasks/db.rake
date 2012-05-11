namespace :db do
  task :seed => :environment do
    Expertise.create! :name => "Private pension plans"
    Expertise.create! :name => "403(b), 401(k) plans, & other DC-type plans"
    Expertise.create! :name => "Government pension plans"
    Expertise.create! :name => "IRAs, SEPs"
    Expertise.create! :name => "Keoghs"
    Expertise.create! :name => "Professional service providers"
    Expertise.create! :name => "Church plans"
    Expertise.create! :name => "Domestic relations orders"
    Expertise.create! :name => "Plan changes"
    Expertise.create! :name => "PBGC questions"

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