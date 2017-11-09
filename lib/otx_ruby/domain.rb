module OTX
  class Domain < OTX::Base
    def get_general(domain)
      uri = "/api/v1/indicators/domain/#{domain}/general"

      json_data = get(uri)

      general = OTX::Indicator::IP::General.new(json_data)

      return general
    end

    def get_geo(domain)
      uri = "/api/v1/indicators/domain/#{domain}/geo"

      json_dat = get(uri)

      geo = OTX::Indicator::IP::Geo.new(json_data)

      return geo
    end

    def get_malware(domain)
      uri = "/api/v1/indicators/domain/#{domain}/malware"
      malwares = []

      begin
        json_data = get(uri)
        page = json_data['next']

        params = URI::decode_www_form(URI(page).query).to_h unless page.nil?

        malwares += json_data['data']
      end while !page.nil?

      results = []
      malwares.each do |malware|
        results << OTX::Indicator::IP::Malware.new(malware)
      end

      return results
    end

    def get_url_list(domain)
      uri = "/api/v1/indicators/domain/#{domain}/url_list"

      page = 0
      url_list = []
      begin
        page += 1
        params{limit: 20, page: page}
        json_data = get(uri, params)
        has_next = json_data['has_next']

        url_list += json_data['url_list']
      end while !has_next.nil?

      results = []
      url_list.each do |url|
        results << OTX::Indicator::IP::URL.new(url)
      end

      return results
    end

    def get_passive_dns(domain)
      uri = "/api/v1/indicators/domain/#{domain}/passive_dns"

      json_data = get(uri)

      results = []
      json_data['passive_dns'].each do |dns|
        results << OTX::Indicator::IP::DNS.new(dns)
      end

      return results
    end

    def get_http_scans(domain)
      uri = "/api/v1/indicators/domain/#{domain}/http_scans"

      json_data = get(uri)

      results = []
      json_data['data'].each do |http_scan|
        results << OTX::Indicator::IP::HTTPScan.new(http_scan)
      end

      return results
    end

    def whois(domain)
      uri = "/api/v1/indicators/domain/#{domain}/whois"

      json_data = get(uri)

      whois = OTX::Indicator::IP::Whois.new(json_data)

      return whois
    end
  end
end