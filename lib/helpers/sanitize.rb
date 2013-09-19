require 'sanitize'

module Nanoc3::Helpers
  module SanitizeHelper
    def sanitize(html)
      Sanitize.clean(html, Sanitize::Config::BASIC)
    end

    def simple_format(text, options={})
      text = '' if text.nil?
      text = text.dup
      start_tag = '<p>'
      text = sanitize(text) unless options[:sanitize] == false
      text = text.to_str
      text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
      text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  -> paragraph
      text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
      text.insert 0, start_tag
      text + '</p>'
    end
  end
end
