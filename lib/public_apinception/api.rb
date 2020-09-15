class PublicApinception::API
    attr_reader :title, :description, :auth_type, :https, :cors, :link, :category
    @@all = []

    def initialize(title=nil, description=nil, auth_type=nil, https=nil, cors=nil, link=nil, category=nil)
        @title = title
        @description = description
        @auth_type = auth_type
        @https = https
        @cors = cors
        @link = link
        @category = category

        @@all << self
    end

    def self.all
        @@all
    end

    def self.find_by_category(input)
        self.all.select {|api| api.title == input}
    end

    def self.categories
        all.map { |api| api.category }.uniq
    end
end