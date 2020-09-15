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

    def self.title_by_category(input)
        apis = self.all.select {|api| api.category == input}
        apis.map { |api| api.title }
    end

    def self.find_by_title(input)
        self.all.find {|api| api.title.downcase == input.downcase}
    end

    def self.categories
        all.map { |api| api.category }.uniq
    end
end