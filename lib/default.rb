# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::Tagging
#include Nanoc3::Helpers::Filtering
#include Nanoc3::Helpers::HTMLEscape
include Nanoc3::Helpers::LinkTo
#include Nanoc3::Helpers::Rendering
#include Nanoc3::Helpers::Text
#include Nanoc3::Helpers::XMLSitemap

def git_dev_branch?
  `git branch|grep -F '*'`.chomp == '* develop'
end

def sorted_posts
  if git_dev_branch? then
    sorted_articles.select { |a| ['publish', 'draft'].include? a[:status] }
  else
    sorted_articles.select { |a| a[:status] == 'publish' }
  end
end

def all_posts
  if git_dev_branch? then
    articles.select { |a| ['publish', 'draft'].include? a[:status] }
  else
    articles.select { |a| a[:status] == 'publish' }
  end
end

def build_tag_pages
  all_tags = all_posts.map { |a| a[:tags] }.flatten.compact.uniq

  # Get tags that already have pages
  tags_with_pages = all_posts.map { |p| p.attributes[:tags] }

  # Get tags without pages
  tags_without_pages = all_tags - tags_with_pages

  # Build pages for each tag
  tags_without_pages.each do |t|
    @items << Nanoc3::Item.new(
      "",
      { :title => "Articles tagged \"#{t}\"", :layout => "tag-page", :tag => t },
      "/tag/#{t}/"
    )
  end
end

