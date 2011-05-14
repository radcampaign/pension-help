class Update2011PovertyLevels < ActiveRecord::Migration
  def self.up
    execute <<-SQL
    INSERT INTO poverty_levels (year, number_in_household, geographic, fpl) VALUES
    (2011, 1, 'US', 10890),
    (2011, 2, 'US', 14710),
    (2011, 3, 'US', 18530),
    (2011, 4, 'US', 22350),
    (2011, 5, 'US', 26170),
    (2011, 6, 'US', 29990),
    (2011, 7, 'US', 33810),
    (2011, 8, 'US', 37630),
    (2011, 1, 'AK', 13600),
    (2011, 2, 'AK', 18380),
    (2011, 3, 'AK', 23160),
    (2011, 4, 'AK', 27940),
    (2011, 5, 'AK', 32720),
    (2011, 6, 'AK', 37500),
    (2011, 7, 'AK', 42280),
    (2011, 8, 'AK', 47060),
    (2011, 1, 'HI', 12540),
    (2011, 2, 'HI', 16930),
    (2011, 3, 'HI', 21320),
    (2011, 4, 'HI', 25710),
    (2011, 5, 'HI', 30100),
    (2011, 6, 'HI', 34490),
    (2011, 7, 'HI', 38880),
    (2011, 8, 'HI', 43270)
    SQL
  end

  def self.down
    execute "delete from poverty_levels where year = 2011"
  end
end
