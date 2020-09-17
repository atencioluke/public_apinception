class PublicApinception::CLI
    attr_accessor :categories, :ascii, :prompt

    # upon initializing, two threads will start
    # t1 gives a loading screen animation and resizing window
    # t2 loads data from API and creates objects
    def initialize
        t1 = Thread.new do
            system "printf '\e[8;50;130t'" #resizes window xterm
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

    # Plays ASCII welcome animation, greeting and displays categories
    def call
        @ascii.welcome_screen
        puts "Hi! Welcome to Public APInception! What kind of API are you looking for today?"
        list_categories
    end

    # formats and lists categories
    def list_categories
        header
        input = list(@categories)
        input == "Exit" ? exit : list_apis(input)
    end

    # clears console 
    def clear
        ascii.clear
    end

    # formats screen and displays API titles
    def list_apis(input)
        clear
        puts ascii.title_screen
        apis = PublicApinception::API.title_by_category(input)
        choice = api_list_menu(apis)

        toggle(choice) || api_info(choice, input)
    end

    # Used to determine selected options and actions needed to get to next page
    def toggle(input,api_link=nil)
        if input == "Exit"
            exit
        elsif input == "Go back to Categories"
            list_categories
        elsif input == "Open API homepage" && !api_link.nil?
            open_api_link(api_link)
        end
    end
    
    # Opens API link and restates current API selection/menu
    def open_api_link(api_link)
        system "open #{api_link}"
        api = PublicApinception::API.find_by_link(api_link)
        api_title = api.title
        api_category = api.category
        api_info(api_title, api_category)
    end
    
    # formats screen and displays selected APIs data with navigation menu at bottom
    def api_info(input, previous_choice)
        ascii.api_header
        info = PublicApinception::API.find_by_title(input)

        ascii.api_title
        puts info.title
        ascii.api_description
        puts info.description

        selection = <<~HERE
        Auth_type:   #{info.auth_type == "" ? "None" : info.auth_type }
        HTTPS:       #{info.https}
        Cors:        #{info.cors}
        Link:        #{info.link}
        Category:    #{info.category}

        HERE

        puts selection
        choice = end_menu(previous_choice)

        toggle(choice,info.link) || list_apis(choice)

    end

    # adds Go back to categories option to list for api list and api info menus
    def api_list_menu(other_options)

        options = ["Go back to Categories", other_options]

        input = list(options)
    end

    # adds Go back to categories option to list for api list and api info menus
    def end_menu(other_options)
        options = ["Open API homepage", other_options]

        input = list(options)
    end

    # formats header to sit above text
    def header
        ascii.title_screen
    end

    # Navigation menu that lists options
    def list(options)
        options.include?("Exit") || options << "Exit"
        input = prompt.select(ascii.directions, options, cycle: true, per_page: 10, filter: true)
    end

    # Gives randomized exit screen and closes program
    def exit
        clear
        ascii.exit_screen
        sleep(3)
        clear
    end
end