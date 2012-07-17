namespace :links do
  task :check => :environment do
    checks = [
      { :class => Agency, :fields => [[:url, "Url"]], :path => :edit_agency_url },
      {
        :class => Location,
        :fields => [[:url, "URL2"], [:url2, "URL2"]],
        :path => :edit_agency_location_url
      },
      {
        :class => Plan,
        :fields => [[:url, "Url"], [:admin_url, "Admin Url"],
          [:tpa_url, "Tpa Url"], [:spd_url, "Spd Url"]],
        :path => :edit_agency_plan_url
      },
      { :class => Publication, :fields => [[:url, "Url"]], :path => :edit_agency_url }
    ]

    errors = []

    checks.each do |check|
      check[:class].find(:all).each do |object|
        check[:fields].each do |pair|
          field = pair[0]
          label = pair[1]

          unless object.send(field).blank?
            url = object.send(field).strip
            entry = { :url => url, :error => nil }

            begin
              url = "http://#{url}" unless url =~ /\Ahttps?:\/\//
              url = URI.parse(URI.encode(url.gsub(" ", "%20")))

              request_url = URI.unescape url.path
              request_url += "?#{URI.unescape(url.query)}" unless url.query.blank?

              request_url = "/" if request_url.blank?

              request = Net::HTTP::Get.new request_url
              resource = Net::HTTP.new url.host, url.port

              if url.is_a?(URI::HTTPS)
                resource.use_ssl = true
                resource.verify_mode = OpenSSL::SSL::VERIFY_NONE
              end

              resource = resource.request request

              unless resource.is_a?(Net::HTTPOK)
                case resource.class
                when Net::HTTPFound, Net::HTTPMovedPermanently
                  entry[:error] = "Page moved"

                when Net::HTTPForbidden
                  entry[:error] = "Access forbidden"

                when Net::HTTPNotFound
                  entry[:error] = "Not found"

                when Net::HTTPBadRequest, Net::HTTPUnsupportedMediaType, Net::HTTPServiceUnavailable, Net::HTTPInternalServerError
                  entry[:error] = "Invalid request"
                end
              end
            rescue SocketError, Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::ECONNRESET, Errno::ENETUNREACH, Errno::EHOSTUNREACH => e
              entry[:error] = "Error connecting to server"
            rescue NoMethodError, URI::InvalidURIError => e
              entry[:error] = "Invalid link"
            rescue Timeout::Error => e
              entry[:error] = "Connection timeout"
            end

            unless entry[:error].nil?
              entry[:path] = check[:path]
              entry[:label] = label
              case object
              when Plan, Location
                entry[:object] = { :agency_id => object.agency, :id => object }
              when Publication
                entry[:object] = object.agency
              else
                entry[:object] = object
              end
              errors << entry
            end
          end
        end
      end
    end

    if errors.any?
      Mailer.deliver_links(errors)
    end
  end
end