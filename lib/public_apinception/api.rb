class PublicApinception::API
    def initialize(title=nil, description=nil, auth_type=nil, https=nil, cors=nil, link=nil, category=nil)
        @title = title
        @description = description
        @auth_type = auth_type
        @https = https
        @cors = cors
        @link = link
        @category = category
    end

    def new_from_hash()
        
    end
end