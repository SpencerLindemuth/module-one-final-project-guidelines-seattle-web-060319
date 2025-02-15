def user_history_menu(symbol, cache = {}, rerun = 0)
    system('clear')
    if rerun != 0
        puts "Please enter a valid command"
    end
    puts "-----------------------------------------"
    puts "1) 1 Week          2) 1 Month"
    puts "3) 3 Months        4) 6 Months"
    puts "5) 1 Year          6) 5 Years"
    puts 'or type "back" to go back'
    puts
    input = gets.chomp
    if input == "back"
        user_stock_profile_menu(symbol, cache)
    else
        input = input.to_i
    end
    duration = 0

    case input
    when 1
        duration = 7
        print_history(symbol, duration)
    when 2
        duration = 30
        print_history(symbol, duration)
    when 3
        duration = 90
        print_history(symbol, duration)
    when 4
        duration = 180
        print_history(symbol, duration)
    when 5
        duration = 365
        print_history(symbol, duration)
    when 6
        duration = 2000
        print_history(symbol, duration)
    else
        puts "Please enter a valid command"
        user_history_menu(symbol, cache, 1)
    end
end


def print_history(symbol, duration, rerun=0, added=0)
    system('clear')
    status = $CurrentUser.stocks.find_by symbol: symbol
    if status
        added = 2
    end
    if rerun != 0
        puts "Please Enter a valid command!"
    end
    history = stock_history(symbol, duration)
    rows = []
    if history["change_direction"] == "up"
        puts "#{symbol.upcase}".magenta + " History:".red
        rows << ["Closing price", "#{history["first_date"]}".blue, "#{history["first_close"]}"]
        rows << ["Highest Price", "#{history["historical_high_date"]}".blue, "$#{(history["historical_high"]).round(2)}".green]
        rows << ["Lowest Price", "#{history["historical_low_date"]}".blue, "$#{(history["historical_low"]).round(2)}".red ]
        rows << ["Total Growth", "", "$#{(history["current_close"] - history["first_close"]).round(2)}".green]
        rows << ["Change Percent", "", "#{history["change_percent"].round(2)}%".green]
        rows << ["Close price ", "#{history["current_date"]}:".blue, "#{history["current_close"]}"]
        table = Terminal::Table.new :rows => rows
    elsif history["change_direction"] == "down"
        puts "#{symbol.upcase}".magenta + " History:".red
        rows << ["Closing price", "#{history["first_date"]}".blue, "#{history["first_close"]}"]
        rows << ["Highest Price", "#{history["historical_high_date"]}".blue, "$#{(history["historical_high"]).round(2)}".green]
        rows << ["Lowest Price", "#{history["historical_low_date"]}".blue, "$#{(history["historical_low"]).round(2)}".red ]
        rows << ["Total Growth", "", "$#{(history["current_close"] - history["first_close"]).round(2)}".red]
        rows << ["Change Percent", "", "#{history["change_percent"].round(2)}%".red]
        rows << ["Close price ", "#{history["current_date"]}:".blue, "#{history["current_close"]}"]
        table = Terminal::Table.new :rows => rows
    end
    puts table
    if added == 0
        puts
        puts "-----------------------------------------"
        puts "1) Change history duration  2) New search"
        puts "3) Add to portfolio         4) Main Menu"
        puts
    else 
        puts
        puts "-----------------------------------------"
        puts "1) Change history duration  2) New search"
        puts "3) Remove from portfolio    4) Main Menu"
        puts
    end
    input= gets.chomp.to_i
    case input
    when 1
        user_history_menu(symbol)
    when 2
        user_stock_research_menu
    when 3
        if added == 0
            added = 1
            add_to_portfolio(symbol)
            print_history(symbol, duration, 0, 1)
        elsif added == 1 || added == 2
            added = 0
            remove_from_portfolio(symbol)
            print_history(symbol, duration, 0, 0)
        end
    when 4
        show_menu
    else
        print_history(symbol, duration, 1)
    end
end


