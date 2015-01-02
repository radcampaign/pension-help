#Creating/Updating/Deleting functionality for Location and Plans
module RestrictionsUpdater

  #returns Array of empty Restrictions or ones filled with data from last Restriction
  def get_empty_restrictions
    #find last restriction - we will fill with its data 'new' restrictions
    org_restriction = restrictions.last

    #use -4, -3, -2, -1 as ids to distinguish new restrictions from existing ones
    (-4..-1).collect do |index|
      r = Restriction.new
      if org_restriction
        #copy attributes and collections to new restriction
        r.attributes = org_restriction.attributes
        #could cause a big problem
        r.states = org_restriction.states
        r.counties = org_restriction.counties
        r.cities = org_restriction.cities
        r.zips = org_restriction.zips
      end
      r.id = index
      r
    end
  end

  #adds params from request to model
  def restriction_attr=(attr)
    @restriction_attr = attr
  end

  #called to save restrictions to db, should be called in transaction
  def update_restrictions(params)
    if (@restriction_attr)
      #for each restriction
      @restriction_attr.keys.each do |key|
        #find existing restriction
        restriction = restrictions.detect {|r| r.id == key.to_i}

        #if updating exisiting restriction OR creating a new one.
        if (restriction || !@restriction_attr[key][:create_new].blank?)
          #loking for geographic restrictions(States, Counties, Cities, Zips select boxes),
          state_abbrevs_ids = params[:"#{key}_state_abbrevs"]
          counties_ids = params[:"#{key}_county_ids"]
          cities_ids = params[:"#{key}_city_ids"]
          zips_ids = params[:"#{key}_zip_ids"]

          #create a new restriction or update attributes of exisitng one.
          if restriction.nil?
            restriction = Restriction.new(@restriction_attr[key])
          else
            restriction.attributes = @restriction_attr[key]
          end

          #update collections
          restriction.states = (state_abbrevs_ids.nil? || state_abbrevs_ids.empty? || state_abbrevs_ids[0].blank?) ? [] : State.find(state_abbrevs_ids)
          restriction.counties = (counties_ids.nil? || counties_ids.empty? || counties_ids[0].blank?) ? [] : County.find(counties_ids)
          restriction.cities = (cities_ids.nil? || cities_ids.empty? || cities_ids[0].blank?) ? [] : City.find(cities_ids)
          restriction.zips = (zips_ids.nil? || zips_ids.empty? || zips_ids[0].blank? ) ? [] : Zip.find(zips_ids)

          #restriction is marked for deletion, however we skip 'new' restriction, that has not been saved yet.
          if (restriction.should_be_destroyed? && !restriction.should_be_created?)
            restriction.destroy
          else
            #update exisiting restriction, but leave creation to a new to one to calling save! on Location/Plans
            if @restriction_attr[key][:create_new] == 'true' || !(-4..-1).to_a.include?(key.to_i)
              restrictions << restriction
              restriction.save!
            end
          end
        end
      end
    end
  end
end
