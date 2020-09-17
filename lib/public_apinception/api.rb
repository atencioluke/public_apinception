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

    # gets array of titles by category name
    def self.title_by_category(input)
        apis = self.all.select {|api| api.category == input}
        apis.map { |api| api.title }
    end

    # finds API by title 
    def self.find_by_title(input)
        self.all.find {|api| api.title == input}
    end

    # finds API by link
    def self.find_by_link(input)
        self.all.find {|api| api.link == input}
    end
end