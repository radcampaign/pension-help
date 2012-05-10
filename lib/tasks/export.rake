task :export => :environment do
  require "fastercsv"

  FasterCSV.open("./tmp/partners.csv", "w") do |csv|

    attributes = Partner.new.attributes.keys.sort

    csv << attributes.map(&:humanize) + [
      "Professions",
      "Sponsor Types",
      "Plan Types",
      "Referral Fees",
      "Claim Types",
      "NPLN Additional Areas",
      "NPLN Participation Levels",
      "PAL Additional Areas",
      "PAL Participation Levels",
      "Search Plan Types",
      "Help Additional Areas",
      "Jurisdictions",
      "Geo Areas",
      "User"
    ]

    Partner.find(:all).each do |partner|
      data = []

      attributes.each do |attribute|
        data << partner.attributes[attribute]
      end

      data << partner.professions.map(&:name).join(", ")
      data << partner.sponsor_types.map(&:name).join(", ")
      data << partner.plan_types.map(&:name).join(", ")
      data << partner.referral_fees.map(&:name).join(", ")
      data << partner.claim_types.map(&:name).join(", ")
      data << partner.npln_additional_areas.map(&:name).join(", ")
      data << partner.npln_participation_levels.map(&:name).join(", ")
      data << partner.pal_additional_areas.map(&:name).join(", ")
      data << partner.pal_participation_levels.map(&:name).join(", ")
      data << partner.search_plan_types.map(&:name).join(", ")
      data << partner.help_additional_areas.map(&:name).join(", ")
      data << partner.jurisdictions.map(&:name).join(", ")
      data << partner.geo_areas.map(&:name).join(", ")
      data << (partner.user.email rescue "")

      csv << data
    end
  end
end