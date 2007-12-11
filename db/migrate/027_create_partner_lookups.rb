class CreatePartnerLookups < ActiveRecord::Migration
  class SponsorType < ActiveRecord::Base
  end
  class PlanType < ActiveRecord::Base
  end
  class ReferralFee < ActiveRecord::Base
  end
  class ClaimType < ActiveRecord::Base
  end
  class NplnAdditionalArea < ActiveRecord::Base
  end
  class NplnParticipationLevel < ActiveRecord::Base
  end
  class PalAdditionalArea < ActiveRecord::Base
  end
  class PalParticipationLevel < ActiveRecord::Base
  end
  class SearchPlanType < ActiveRecord::Base
  end
  class HelpAdditionalArea < ActiveRecord::Base
  end
  
  def self.up
    %w{
      sponsor_types
      plan_types
      referral_fees
      claim_types
      npln_additional_areas
      npln_participation_levels
      pal_additional_areas
      pal_participation_levels
      search_plan_types
      help_additional_areas
    }.each do |tbl|
      create_table tbl do |t|
        t.column :name, :string
        t.column :position, :integer
      end
    end
    
    [ 'Single-employer',
     	'Multiemployer',
     	'Multiple-employer',
     	'Federal government',
     	'Military',
     	'Railroad',
     	'State, county and other government plans',
     	'Church plans',
     	'Other:'
    ].each_with_index {|c, i| SponsorType.create(:id => i+1, :name => c, :position => i+1)}
    
    [ 'Defined benefit pensions',
    	'Cash balance and other hybrids',
    	'401(k) plans',
    	'403(b) plans',
    	'457 plans',
    	'Money purchase and target benefit plans',
    	'Other profit sharing plans',
    	'SEPs and SIMPLEs',
    	'Keoughs',
    	'IRAs',
     	'Other:'
    ].each_with_index {|c, i| PlanType.create(:id => i+1, :name => c, :position => i+1)}
    
    [ 'Individual claims',
    	'Class claims',
    	'PBGC claims',
    	'Pension claims',
    	'Health & disability claims',
    	'ERISA & IRC minimum standards',
    	'Fiduciary claims',
    	'Discrimination claims',
    	'Domestic relations orders',
     	'Other:'
    ].each_with_index {|c, i| ClaimType.create(:id => i+1, :name => c, :position => i+1)}
    
    [ 'Pro Bono or fee shifting',
  	  'Reduced fee or sliding scale.',
  	  'Contingency fee.'
    ].each_with_index {|c, i| ReferralFee.create(:id => i+1, :name => c, :position => i+1)}

    [ 'Labor Law',
  	  'Employment law',
  	  'Social Security',
  	  'Veterans Benefits',
   	  'Other:'
    ].each_with_index {|c, i| NplnAdditionalArea.create(:id => i+1, :name => c, :position => i+1)}

    [ 'Advise clients of their legal rights',
    	'Draft domestic relations orders dividing benefits at divorce',
    	'Represent clients in administrative claims and appeals',
    	'Represent clients at trial',
    	'Represent clients in appellate litigation',
    	'Provide technical assistance to other attorneys',
   	  'Other:'
    ].each_with_index {|c, i| NplnParticipationLevel.create(:id => i+1, :name => c, :position => i+1)}

    [ 'Domestic relations orders',
   	  'Plan changes',
   	  'PBGC questions',
   	  'Other:'
    ].each_with_index {|c, i| PalAdditionalArea.create(:id => i+1, :name => c, :position => i+1)}

    [ 'Advise individual clients on actuarial issues',
   	  'Advise attorneys on actuarial issues',
   	  'Provide technical assistance to other actuaries',
   	  'Other:'
    ].each_with_index {|c, i| PalParticipationLevel.create(:id => i+1, :name => c, :position => i+1)} 
    
    [ 'Single-employer',
    	'Multiemployer',
    	'Multiple employer',
    	'Church plans'
    ].each_with_index {|c, i| SearchPlanType.create(:id => i+1, :name => c, :position => i+1)}
    
    [ 'Benefit claims',
  	  'Minimum standards',
    	'Fiduciary obligations',
    	'Discrimination & interference',
    	'Terminations and the PBGC',
    	'Domestic relations orders',
   	  'Other:'
    ].each_with_index {|c, i| HelpAdditionalArea.create(:id => i+1, :name => c, :position => i+1)}     
  end

  def self.down
    %w{
      sponsor_types
      plan_types
      referral_fees
      claim_types
      npln_additional_areas
      npln_participation_levels
      pal_additional_areas
      pal_participation_levels
      search_plan_types
      help_additional_areas
    }.each {|tbl| drop_table tbl}
  end
end
