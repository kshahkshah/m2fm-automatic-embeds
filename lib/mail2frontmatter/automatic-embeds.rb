require 'mail2frontmatter'
require 'auto_html'
require 'byebug'

module Mail2FrontMatter
  class AutomaticEmbed < PreProcessor
    require 'nokogiri'

    extend AutoHtml

    @all_filters = [:youtube, :soundcloud, :link, :ted, :twitter, :vimeo, :google_map, :gist, :flickr]

    def self.register(options = {})
      super

      # I *could* introspect on auto_html here but I haven't vetted them all yet
      if @options[:white_list]
        @filters = @options[:white_list].map(&:to_sym)
      elsif @options[:black_list]
        @filters = @all_filters - @options[:black_list].map(&:to_sym)
      else
        @filters = @all_filters
      end

    end

    def self.run(metadata, body)
      body = unwrap_links(body)

      body = auto_html(body, { filters: @filters, options: @options[:filters] }) { 
        # use options passed to us...
        @options[:filters].each do |filter|
          options_for_filter = @options[:options] ? (@options[:options][filter.to_sym] || {}) : {}
          self.send(filter.to_sym, options_for_filter)
        end

        # be sure to return @text here
        @text
      }

      return metadata, body
    end

    def self.unwrap_links(body)
      parsed_body = Nokogiri::HTML::DocumentFragment.parse(body)

      parsed_body.elements.css("a").each do |element|
        href = element.attributes["href"].value

        if href == element.inner_html
          body.gsub!(element.to_s, href)
        end
      end

      body
    end

  end
end
