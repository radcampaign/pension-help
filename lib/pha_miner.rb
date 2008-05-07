require 'net/http'
require 'uri'
require 'hpricot'

#Sending and receiving HTTP requests, pulling data from HTML responses.
module PhaMiner

  #Wrapper for Net::Http
  class HttpConnection

    #Creates a new HttpConnection, or throws HttpConnectionException
    def self.get_connection(host, path , post_separator = ';')
      begin
        url = [host, path].join
        uri = URI.parse url
        PhaMiner::HttpConnection.new(uri, post_separator)
      rescue URI::BadURIError
        raise PhaMiner::Exceptions::HttpConnectionException, $!
      end
    end

    #Sends POST request
    #args = fields in HTML form
    #returns Net::HTTPResponse
    def get_page_by_post(path, args = nil)
      begin
        req = prepare_post_request(path, args)
        fetch_page req
      rescue Net::HTTPFatalError
        close
        raise PhaMiner::Exceptions::HttpConnectionException, $!
      end
    end

    #Sends GET request
    #returns Net::HTTPResponse    
    def get_page_by_get(path)
      begin
        req = prepare_get_request(path)
        fetch_page req
      rescue Net::HTTPFatalError
        close
        raise PhaMiner::Exceptions::HttpConnectionException, $!
      end
    end

    #Closes connection
    def close
      @http_con.finish if @http_con.active?
    end

  private
    def initialize(uri, separator)
      @header = {
        'Referer' => 'http://' + uri.to_s,
        'Content-Type' => 'application/x-www-form-urlencoded',
        'User-Agent' => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1'
      }
      @post_separator = separator
      @http_con = Net::HTTP.new(uri.host, uri.port).start
    end

    def prepare_get_request(path)
      Net::HTTP::Get.new(path, @header)
    end

    def prepare_post_request(path, args)
      req = Net::HTTP::Post.new(path, @header)
      req.set_form_data(args,@post_separator)
      return req
    end

    #sends given requests, returns response
    def fetch_page(request)
      response = @http_con.request(request)

      #during first call adds Cookie to HTTP header
      #TODO stores only the session_id, probably it will useful to 
      #dynamically change this parameter
      @header['Cookie'] = (@header['Cookie'].nil?) ? response.response['set-cookie'] : @header['Cookie']

      case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then follow_redirect(response['location'])
      else
        raise PhaMiner::Exceptions::HttpConnectionException, response.error!
      end
    end

    #follows redirects
    def follow_redirect(url_str, limit = 10)
      uri = URI.parse(url_str)

      #TODO this may not work if url_str = 'http:/localhost:3000/index.html?param1=1&param2=2'
      #uri.path cuts '?param1=1&param2=2'
      req = prepare_get_request(url_str)

      response = @http_con.request(req)
      case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then follow_redirect(response['location'], limit - 1)
      else
        raise PhaMiner::Exceptions::HttpConnectionException, response.error!
      end
    end
  end

  class Miner
    def initialize(host, path, search_url, separator, result_parser, link_parser = nil)
      @results = ResultArray.new
      @search_url = search_url
      @con = HttpConnection.get_connection(host, path, separator)
      @result_parser = result_parser
      @link_parser = link_parser
    end

    #starts fetiching pages, returns ResultArray
    def get_results(args)
      start(args)
    end

    #If loggin in is nedeed override this function
    def login
    end

    def logout
    end

    protected

    #controls flow of fetching pages and parsing them, returns ResultArray
    def start(args)
      login

      resp =  @con.get_page_by_post(@search_url, args)
      @results.add_results(@result_parser.parse(resp.body))
      links = parse_links(resp)

      if (!links.empty?)
        for link in links
          resp = @con.get_page_by_get(link)
          @results.add_results(@result_parser.parse(resp.body))
        end
      end

      logout
      @con.close

      @results
    end

    #if results are divided into many pages, this should return an Array with
    #links to those pages
    def parse_links(resp)
      (@link_parser.nil?) ? Array.new : @link_parser.parse(resp.body)
    end
  end

  #Contains Miner implementations for different pages.
  module PageMiners
    #Pulls data from www.pbgc.gov
    class PbgcMiner < Miner
      def initialize
        super('http://search.pbgc.gov', '/mp/', '/mp/results.aspx', '&',
          PhaMiner::PageParsers::PbgcParser.new)
      end
    end

    #Pulls data from www.freeerisac.com
    class FreeErisaMiner < Miner
      def initialize
        super('http://www.freeerisa.com', '/5500/Form5500.asp?mode=SEARCH',
          '/5500/Form5500.asp?form=1', '&', PhaMiner::PageParsers::FreeErisaParser.new,
          PhaMiner::PaginationParsers::FreeErisaPaginationParser.new)
      end

      #Page reruires logging in
      def login
        @con.get_page_by_post('/Customer/check.asp', {'email' => 'dan@gradientblue.com', 'PWord' => 'test', 'redir' => 'Default', 'submit.x' => '33', 'submit.y' => '7'})
      end

      def logout
        @con.get_page_by_get('/default.asp?logout=true')
      end
    end
  end

  ## RESULTS ##
  #Holds results from parsing a page.
  class Result
    attr_accessor :company_name
    attr_accessor :url
    
    def initialize(company_name, url)
      @company_name = company_name
      @url = url
    end
    
    def to_s
      "[Result: company_name=#{company_name}, url=#{url}, id=#{object_id}"
    end
  end

  class PbgcResult
    attr_accessor :company_name
    attr_accessor :url
    attr_accessor :name
    
    def initialize(company_name, url, name)
      @company_name = company_name
      @url = url
      @name = name
    end
    
    def to_s
      "[Result: company_name=#{company_name}, url=#{url}, name=#{name}, id=#{object_id}"
    end
  end

  #Storage for results
  class ResultArray
    include Enumerable

    def initialize
      @results = Array.new
    end

    def add(result)
      @results << result unless result.nil?
    end

    def add_results(result_array)
      @results.concat(result_array.get_results) unless result_array.nil?
    end

    def each
      @results.each {|result| yield result}
    end
    
    def each_with_index
      @results.each_with_index { |item, index| yield item, index }
    end
    
    def empty?
      @results.empty?
    end

    def [](index)
      @results[index]
    end
    
    def clear
      @results.clear
    end

    def to_s
      "[ResultArray: object_id=#{object_id}\n\t" + @results.join("\n\t") + "]"
    end

    protected
    def get_results
      @results
    end
  end

  #--- EXCEPTIONS ---#
  module Exceptions
    class HttpConnectionException < Exception
      def initialize(ex)
        super ex
      end
    end
  end
  #------------------#
  
  #--- PARSERS ---#
  module Parsers
    class PageParser
      def initialize(elems_path)
        @elems_path = elems_path
      end

      protected
      #Returns ResultArray with data pulled from response_body
      def start response_body
        results = PhaMiner::ResultArray.new
        doc = Hpricot response_body
        elements = doc.search(@elems_path)
        elements.each do |elem|
          results.add(yield(elem))
        end
        #(elements/@link_path).each do |elem|
        #  results.add PhaMiner::Result.new(elem.inner_html, elem['href'])
        #end
        results
      end

    end

    #
    class LinkParser
      def initialize(elem_path)
        @elems_path = elem_path

        @results = Array.new
      end

      #returns Array of strings containing links' urls
      def parse response_body
        start response_body
      end

      private
      def start(response_body)
        doc = Hpricot response_body
        elements = doc.search(@elems_path)
        (elements/'//a').each do |elem|
          href = elem['href']
          href.insert(0, '/5500/') unless href[0] == '/'[0]
          @results << href
        end
        #remove repetitions and the first link(we already got first page)
        (@results.uniq!)
        @results.shift
        @results
      end
    end
  end

  #Contains implementations of PageParsers for every page
  module PageParsers
    #Parses data from www.pbgcgov
    class PbgcParser < PhaMiner::Parsers::PageParser
      def initialize
        super 'div#level3Page table.mp tr '#, '//td[1]/a'
      end
      
      def parse response_body
        start response_body do |elem|
          el = elem/'//td[1]/a'
          unless el.empty?
            name = el[0].inner_html
            url = el[0]['href']
            el = elem/'//td[2]'
            company_name = el[0].inner_html
            PbgcResult.new(company_name, 'http://search.pbgc.gov/mp/' + url, name) unless el.empty?
          end
        end
      end
    end

    class FreeErisaParser < PhaMiner::Parsers::PageParser
      def initialize
        super 'table tr td.searchResults'#, '//a'
      end
      
      def parse response_body
        start response_body do |elem|
          el = elem/'//a'
          Result.new(el[0].inner_html, 'http://www.freeerisa.com/5500/' + el[0]['href']) unless el.empty?
        end
      end
    end
  end

  #Contains implementations of pagination for pages that use it.
  module PaginationParsers
    #
    class FreeErisaPaginationParser < PhaMiner::Parsers::LinkParser
      def initialize
        #path to html tag containing links to other pages
        super '//div/table/tr/td/table/tr/td[@class="small" and @align="right"]'
      end
    end
  end
  #---------------#
 end
