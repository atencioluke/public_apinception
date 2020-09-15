class PublicApinception::CLI
    attr_accessor :categories, :ascii, :prompt

    def initialize
        t1 = Thread.new do
            @ascii = PublicApinception::ASCIIIMAGES.new
            ascii.load_screen
        end

        t2 = Thread.new do
            @prompt = TTY::Prompt.new
            PublicApinception::Adapter.new
            @categories = PublicApinception::Category.categories
        end

        t1.join
    end

    def call
        welcome
    end

    def welcome
        @ascii.welcome_screen
        puts "Hi! Welcome to Public APInception! What kind of API are you looking for today?"
        list_categories
    end

    def loading
    end

    def list_categories
        # PublicApinception::Category.all.map {|c| c.category }
        input = list(@categories)

        if input == "Exit"
            exit
        else
            list_apis(input)
        end
    end

    def list_apis(input)
        apis = PublicApinception::API.title_by_category(input)
        apis << "Go back to categories"
        list(apis)

        if input == "Exit"
            exit
        elsif input == "Go back to categories"
            list_categories
        else
            api_info(input)
        end
    end
    
    def api_info(input)
        info = PublicApinception::API.find_by_title(input)

        selection = <<~HERE
        Title: 
        Description: 
        Auth_type: 
        HTTPS: 
        Cors: 
        Link: 
        Category: 
        HERE
        
    end

    def list(options)
        options << "Exit"
        input = prompt.select("Select an option using the arrow keys and press enter. (↑/↓ navigate options, ←/→ navigate pages)", options, cycle: true)
    end

    def exit
        ascii.load_screen
        puts "It's been real, it's been good, but it hasn't been real good."
    end
end