namespace :links do
  task :check, [:verbose] => :environment do |t, args|
    checks = [
        {:class => Agency, :fields => [[:url, "Url"]], :path => :edit_agency_url},
        {
            :class => Location,
            :fields => [[:url, "URL2"], [:url2, "URL2"]],
            :path => :edit_agency_location_url
        }
    ]

    verbose = args[:verbose]
    errors = []

    checks.each do |check|
      object_list = check[:class].all
      count = object_list.length
      i = 0


      object_list.each do |object|
        i+=1
        puts "#{check[:class]} id:#{object.id} #{i} of #{count}" if verbose
        next if (object.respond_to?(:is_active) and !object.is_active) or (object.respond_to?(:is_provider) and !object.is_provider)
        check[:fields].each do |pair|
          field = pair[0]
          label = pair[1]

          unless object.send(field).blank?
            url = object.send(field).strip
            entry = {:url => url, :error => nil}

            begin
              puts "\t #{url}" if verbose
              resource = test_url(url, verbose)
              entry[:error] = resource.message unless resource.is_a?(Net::HTTPOK)
              if resource.is_a?(Net::HTTPFound) or resource.is_a?(Net::HTTPMovedPermanently)
                new_location = url.merge resource['location'] unless resource['location'] =~ /\Ahttps?:\/\// and new_location = resource['location']
                entry[:error] << " --> #{new_location}"
              end

            rescue SocketError, Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::ECONNRESET, Errno::ENETUNREACH, Errno::EHOSTUNREACH => e
              entry[:error] = "Error connecting to server"
            rescue NoMethodError, URI::InvalidURIError => e
              entry[:error] = "Invalid link"
            rescue Timeout::Error => e
              entry[:error] = "Connection timeout"
            rescue OpenSSL::SSL::SSLError => e
              entry[:error] = "SSL Error (please check manually)"
            end

            unless entry[:error].nil?
              entry[:path] = check[:path]
              entry[:label] = label
              case object
                when Plan, Location
                  entry[:object] = {:agency_id => object.agency, :id => object}
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
      Mailer.links(errors).deliver
    end
  end


  def test_url(url, verbose)
    url = "http://#{url}" unless url =~ /\Ahttps?:\/\//
    url = URI.parse(URI.encode(url.gsub(" ", "%20")))


    if url.is_a?(URI::HTTPS)
      # sometimes server fails to answer to default :SSLv23 mode (may be ruby bug)
      # in that case try other options
      ssl_version_list = [:SSLv23, :SSLv3, :TLSv1, :TLSv1_1, :TLSv1_2]
      ssl_version_list.each_with_index do |ssl_version, index|
        request, resource = create_resource_and_request(url)
        resource.use_ssl = true
        resource.ssl_version = ssl_version
        resource.verify_mode = OpenSSL::SSL::VERIFY_NONE
        begin
          resource = resource.request request
          return resource
        rescue OpenSSL::SSL::SSLError => e
          # if last element raise same exception
          puts "SSL error for #{ssl_version}" if verbose
          if index == (ssl_version_list.length-1)
            raise e
          end
        end
      end
    else
      request, resource = create_resource_and_request(url)
      resource = resource.request request
      return resource
    end
  end

  def create_resource_and_request(url)

    request_url = URI.unescape url.path
    request_url += "?#{URI.unescape(url.query)}" unless url.query.blank?

    request_url = "/" if request_url.blank?

    request = Net::HTTP::Get.new request_url
    resource = Net::HTTP.new url.host, url.port
    return [request, resource]
  end

end
