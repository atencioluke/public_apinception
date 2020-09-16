class PublicApinception::CLI
    attr_accessor :categories, :ascii, :prompt

    def initialize
        t1 = Thread.new do
            @ascii = PublicApinception::ASCIIIMAGES.new
            system "printf '\e[8;50;130t'"
            
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
        # system "printf '\e[8;48;130t'"
        @ascii.welcome_screen
        puts "Hi! Welcome to Public APInception! What kind of API are you looking for today?"
        list_categories
    end

    def list_categories
        input = list(@categories)

        input == "Exit" ? exit : list_apis(input)
    end

    def list_apis(input)
        system "clear"
        puts ascii.title_screen
        apis = PublicApinception::API.title_by_category(input)
        apis << "Go back to Categories"
        choice = list(apis)

        if choice == "Exit"
            exit
        elsif choice == "Go back to Categories"
            list_categories
        else
            api_info(choice, input)
        end
    end
    
    def api_info(input, previous_choice)
        # header
        system "clear"
        info = PublicApinception::API.find_by_title(input)

        selection = <<~HERE
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
        toggle = end_menu(previous_choice)

        if toggle == "Exit"
            exit
        elsif toggle == "Go back to Categories"
            list_categories
        else
            list_apis(toggle)
        end

    end

    def end_menu(other_options)
        options = ["Go back to Categories", other_options]

        input = list(options)
    end

    def header
        system "clear"
        puts ascii.title_screen
    end

    def list(options)
        directions = <<~HERE
        
        +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
        
        ███████╗███████╗██╗     ███████╗ ██████╗████████╗     █████╗ ███╗   ██╗     ██████╗ ██████╗ ████████╗██╗ ██████╗ ███╗   ██╗   
        ██╔════╝██╔════╝██║     ██╔════╝██╔════╝╚══██╔══╝    ██╔══██╗████╗  ██║    ██╔═══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╗
        ███████╗█████╗  ██║     █████╗  ██║        ██║       ███████║██╔██╗ ██║    ██║   ██║██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║╚═╝
        ╚════██║██╔══╝  ██║     ██╔══╝  ██║        ██║       ██╔══██║██║╚██╗██║    ██║   ██║██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║██╗
        ███████║███████╗███████╗███████╗╚██████╗   ██║       ██║  ██║██║ ╚████║    ╚██████╔╝██║        ██║   ██║╚██████╔╝██║ ╚████║╚═╝
        ╚══════╝╚══════╝╚══════╝╚══════╝ ╚═════╝   ╚═╝       ╚═╝  ╚═╝╚═╝  ╚═══╝     ╚═════╝ ╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   
                                                                                                                                      
        Use the ⬆/⬇ keys to navigate options, ⬅/⮕ keys to navigate pages
        You can filter by typing what you want. (E.g.Typing "Cat" will give you Cats & Cat Facts)
        Press enter to confirm your selection.
        +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
        HERE

        options.include?("Exit") || options << "Exit"
        input = prompt.select(directions, options, cycle: true, per_page: 10, filter: true)
    end

    def exit
        system "clear"
        ascii.exit_screen
        sleep(3)
        system "clear"
    end
end