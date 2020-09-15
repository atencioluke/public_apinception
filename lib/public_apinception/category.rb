class PublicApinception::Category
    attr_reader :category
    
    @@all = []
    @@categories = []

    def initialize(category)
        @category = category
        @@categories << @category
        @@all << self
    end
    
    def self.new_from_array(categories)
        categories.each {|c| self.new(c)}
    end

    def self.all
        @@all
    end

    def self.categories
        @@categories
    end
end