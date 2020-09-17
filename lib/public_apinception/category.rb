class PublicApinception::Category
    attr_reader :category
    
    @@categories = []

    def initialize(category)
        @category = category
        @@categories << @category
    end
    
    def self.new_from_array(categories)
        categories.each {|c| self.new(c)}
    end

    def self.categories
        @@categories
    end
end