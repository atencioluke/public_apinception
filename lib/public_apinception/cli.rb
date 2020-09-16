class PublicApinception::CLI
    attr_accessor :categories, :ascii, :prompt

    def initialize
        # upon initializing, two threads will start, giving a loading screen animation
        # and resizing window, while also loading data from API and creating objects

        t1 = Thread.new do
            system "printf '\e[8;50;130t'"
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
        # Plays ASCII welcome animation, greeting and displays categories

        @ascii.welcome_screen
        puts "Hi! Welcome to Public APInception! What kind of API are you looking for today?"
        list_categories
    end

    def list_categories
        # formats and lists categories

        header
        input = list(@categories)
        input == "Exit" ? exit : list_apis(input)
    end

    def clear
        # clears console 

        system "clear"
    end

    def list_apis(input)
        # formats screen and displays API titles

        clear
        puts ascii.title_screen
        apis = PublicApinception::API.title_by_category(input)
        choice = end_menu(apis)

        toggle(choice) || api_info(choice, input)
    end

    def toggle(input)
        # Used to determine if user input was exit or navigate to Categories

        if input == "Exit"
            exit
        elsif input == "Go back to Categories"
            list_categories
        end
    end
    
    def api_info(input, previous_choice)
        # formats screen and displays selected APIs data with navigation menu at bottom

        clear
        info = PublicApinception::API.find_by_title(input)

        selection = <<~HERE
         █████╗ ██████╗ ██╗
        ██╔══██╗██╔══██╗██║
        ███████║██████╔╝██║
        ██╔══██║██╔═══╝ ██║
        ██║  ██║██║     ██║
        ╚═╝  ╚═╝╚═╝     ╚═╝
                           
        +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
                      Title
        +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

        #{info.title}

        +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
                    Description
        +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

        #{info.description}

        +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
                     Details
        +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

        Auth_type:   #{info.auth_type == "" ? "N/A" : info.auth_type }
        HTTPS:       #{info.https}
        Cors:        #{info.cors}
        Link:        #{info.link}
        Category:    #{info.category}

        HERE

        puts selection
        choice = end_menu(previous_choice)

        toggle(choice) || list_apis(choice)

    end

    def end_menu(other_options)
        # adds Go back to categories option to list for api list and api info menus

        options = ["Go back to Categories", other_options]

        input = list(options)
    end

    def header
        # formats header to sit above text

        clear
        puts ascii.title_screen
    end

    def list(options)
        # Navigation menu that lists options

        directions = <<~HERE
        
        +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
        
        ███████╗███████╗██╗     ███████╗ ██████╗████████╗     █████╗ ███╗   ██╗     ██████╗ ██████╗ ████████╗██╗ ██████╗ ███╗   ██╗   
        ██╔════╝██╔════╝██║     ██╔════╝██╔════╝╚══██╔══╝    ██╔══██╗████╗  ██║    ██╔═══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╗
        ███████╗█████╗  ██║     █████╗  ██║        ██║       ███████║██╔██╗ ██║    ██║   ██║██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║╚═╝
        ╚════██║██╔══╝  ██║     ██╔══╝  ██║        ██║       ██╔══██║██║╚██╗██║    ██║   ██║██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║██╗
        ███████║███████╗███████╗███████╗╚██████╗   ██║       ██║  ██║██║ ╚████║    ╚██████╔╝██║        ██║   ██║╚██████╔╝██║ ╚████║╚═╝
        ╚══════╝╚══════╝╚══════╝╚══════╝ ╚═════╝   ╚═╝       ╚═╝  ╚═╝╚═╝  ╚═══╝     ╚═════╝ ╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   
                                                                                                                                      
        Use the ⬆ /⬇ keys to navigate options and ⬅ /⮕ keys to navigate pages
        You can filter by typing what you want (e.g.Typing "Cat" will give you Cats & Cat Facts).
        Press enter to confirm your selection.
        +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
        HERE

        options.include?("Exit") || options << "Exit"
        input = prompt.select(directions, options, cycle: true, per_page: 10, filter: true)
    end

    def exit
        # Gives randomized exit screen and closes program

        clear
        ascii.exit_screen
        sleep(3)
        clear
    end
end