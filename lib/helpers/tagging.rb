# Override link_for_tag functionality (to add .to_slug)
module Nanoc3::Helpers
  module Tagging
    def link_for_tag(tag, base_url)
      %[<a href="#{h base_url}#{h tag.to_slug}" rel="tag">#{h tag}</a>]
    end
  end
end
