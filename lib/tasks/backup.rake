namespace :backup do
  namespace :s3 do
    task :database => :environment do
      require "aws/s3"

      `sudo -i eybackup -d 9:phamerica`

      backup_filename = "#{`ls -at /mnt/tmp/*.sql.gz`.split("\n")[0]}"
      `sudo chmod 777 #{backup_filename}`

      AWS::S3::Base.establish_connection!(
        :access_key_id     => "AKIAJE3G2MZ65T2RITUA",
        :secret_access_key => "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"
      )

      AWS::S3::S3Object.store "backups=#{RAILS_ENV}/database-#{Date.today}.sql.gz", open(backup_filename), "freeport-metrics-pha", :access => :private

      `sudo rm -f #{backup_filename}`
    end
  end
end