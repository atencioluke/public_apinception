# require_relative '../public_apinception.rb'
# require_relative './category.rb'
class PublicApinception::Adapter
    @@BASE_URL = "https://api.publicapis.org"
    
    def initialize
        create_apis
        create_categories
    end
    
    # Get all APIs
    def get_apis
        response = Net::HTTP.get_response(URI.parse(@@BASE_URL + "/entries"))
        data = JSON.parse(response.body)
        apis = data["entries"]
    end

    # Use results from #get_apis to create API objects
    def create_apis
        get_apis.each do |api|
            title = api["API"]
            description = api["Description"]
            auth_type = api["Auth"]
            https = api["HTTPS"]
            cors = api["Cors"]
            link = api["Link"]
            category = api["Category"]
            PublicApinception::API.new(title, description, auth_type, https, cors, link, category)
        end
    end

    def create_categories
        PublicApinception::Category.new_from_array(PublicApinception::API.categories)
    end

end