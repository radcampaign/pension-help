namespace :backup do
  namespace :s3 do
    task :database => :environment do
      require "aws/s3"

      `sudo -i eybackup -d 0:phamerica`

      backup_filename = "#{`ls -at /mnt/tmp/*.sql.gz`.split("\n")[0]}"
      `sudo chmod 777 #{backup_filename}`

      AWS::S3::Base.establish_connection!(
        :access_key_id     => "AKIAIYXRYPP7JN6JUKRA",
        :secret_access_key => "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"
      )

      AWS::S3::S3Object.store "backups/database-#{Date.today}.sql.gz", open(backup_filename), "phamerica-#{RAILS_ENV}", :access => :private

      `sudo rm -f #{backup_filename}`
    end
  end
end