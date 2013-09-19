# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

def git_dev_branch?
  # TODO: What about feature branches? And tag branches?
  `git branch|grep -F '*'`.chomp == '* develop'
end

def sorted_drafts
  sorted_articles.select { |a| a[:status] == 'draft' }
end

def build_tag_pages
  all_tags = articles.map { |a| a[:tags] }.flatten.compact.uniq

  # Get tags that already have pages
  tags_with_pages = articles.map { |p| p.attributes[:tags] }

  # Get tags without pages
  tags_without_pages = all_tags - tags_with_pages

  # Build pages for each tag
  tags_without_pages.each do |t|
    @items << Nanoc3::Item.new(
      "",
      { :title => "Articles tagged \"#{t}\"", :layout => "tag-page", :tag => t },
      "/tag/#{t.to_slug}/"
    )
  end
end

def articles_by_year_month
  result = {}
  current_year = current_month = year_h = month_a = nil

  sorted_articles.each do |item|
    d = Date.parse(item[:created_at])

    if current_year != d.year
      current_month = nil
      current_year = d.year
      year_h = result[current_year] = {}
    end

    if current_month != d.month
      current_month = d.month
      month_a = year_h[current_month] = []
    end

    month_a << item
  end

  # why don't these come out sorted? bah.
  result.each do |year, month|
    result[year] = month.sort { |a,b| b[0]<=>a[0] }
  end
  result.sort { |a,b| b[0]<=>a[0] }
end

# String extensions
# TODO: use unidecode instead? https://github.com/pjg/ruby_extensions/blob/master/lib/ruby_extensions.rb
String.class_eval do
  def to_slug
    # strip the string
    ret = self.strip

    # blow away apostrophes
    ret.gsub! /['`]/,""

    # @ --> at, and & --> and
    ret.gsub! /\s*@\s*/, " at "
    ret.gsub! /\s*&\s*/, " and "

    # replace all non alphanumeric, underscore or periods with dash
    ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '-'

    # convert double underscores to single
    ret.gsub! /-+/,"-"

    # strip off leading/trailing underscore
    ret.gsub! /\A[-\.]+|[-\.]+\z/,""

    ret.downcase
  end
end
