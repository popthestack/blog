module Nanoc3

  class Site

    def tags
      collect_all_tags if @tags == nil
      @tags
    end

      def collect_all_tags
        if @tags == nil
          @tags = []
          non_unique_tags = []
          unique_tags = Set.new
          @items.each do |item|
            next if item[:tags].nil?
            item[:tags].each do |tag|
              unique_tags << tag.to_s
              non_unique_tags << tag.to_s
            end
          end
        end
        unique_tags.each do |tag_name|
          item = Nanoc3::Item.new(tag_name, {
                                    :title => "Posts tagged #{tag_name}",
                                    :name => tag_name,
                                    :kind => "tag"
                                  }, "/tags/#{tag_name}")
          @tags << item
          @items << item
        end
        count_all_tags(non_unique_tags)
        allocate_tag_sizes
        @tags.sort! {|b,a| a[:count] <=> b[:count] }
        @tags
      end

    private

      def count_all_tags(non_unique_tags)
        @tags.each do |tag|
          tag[:count] = non_unique_tags.count(tag[:name])
        end
      end

      def allocate_tag_sizes
        min = 0
        max = 0
        @tags.each do |tag|
          min = tag[:count] if tag[:count] < min
          max = tag[:count] if tag[:count] > max
        end
        distribution = (max - min) / 3
        @tags.each do |tag|
          if tag[:count] == min
            tag[:size] = 'not-very-popular'
          elsif tag[:count] == max
            tag[:size] = 'ultra-popular'
          elsif tag[:count] > (min + (distribution * 2))
            tag[:size] = 'popular'
          elsif tag[:count] > (min + distribution)
            tag[:size] = 'somewhat-popular'
          else
            tag[:size] = 'not-popular'
          end
        end
      end
  end
end

