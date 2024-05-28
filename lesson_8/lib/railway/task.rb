# frozen_string_literal: true

module Railway
  class Task
    attr_accessor :stations, :routes, :pass_trains, :cargo_trains

    def start
      choice = show_menu
      send(choice)
    end

    def initialize(app_dir: nil, main_menu: nil)
      raise 'app_dir or main_menu must be present' if app_dir.nil? && main_menu.nil?

      @app_dir = app_dir
      @stations = []
      @routes = []
      @pass_trains = []
      @cargo_trains = []
      yaml = app_dir ? YAML.safe_load_file("#{@app_dir}/cfg/menu.yaml", symbolize_names: true) : nil
      @main_menu = yaml || main_menu
    end

    def user_input(description: nil, prompt: '> ', convert: :to_i)
      puts description unless description.nil?
      print prompt
      choice = gets.chomp
      choice.send(convert)
    end

    def show_menu(key = :main)
      @main_menu[key].each_with_index { |item, index| puts "#{index + 1}. #{item.last}" }
      @main_menu[key][user_input - 1].first
    end

    def create_station
      station_name = user_input description: 'Введите название станции', convert: :to_s
      @stations << Station.new(station_name)
    rescue StandardError => e
      puts
      puts "ОШИБКА: #{e}"
      puts
      retry
    ensure
      repeat_or_main ? create_station : start
    end

    def create_train
      train_name = user_input description: 'Введите название поезда', convert: :to_s
      train_number = user_input(
        description: 'введите номер поезда в формате 3 буквы или цифры, тире(опционально) и 2 цифры',
        convert: :to_s
      )
      train_type = nil
      until [1, 2].include? train_type
        train_type = user_input description: "Выберите тип поезда \n1. пассажирский\n2. грузовой"
        @pass_trains << PassengerTrain.new(train_number, train_name) if train_type == 1
        @cargo_trains << CargoTrain.new(train_number, train_name) if train_type == 2
      end
    rescue StandardError => e
      puts
      puts "ОШИБКА: #{e}", e.full_message
      puts
      retry
    ensure
      puts 'Поезд создан'
      repeat_or_main ? create_train : start
    end

    def manage_route
      choice = show_menu(:route)
      send(choice)
    end

    def create_route
      start_station = select_station
      end_station = select_station(start_station)
    rescue StandardError => e
      puts
      puts "ОШИБКА: #{e}", e.full_message
      puts
      retry
    ensure
      @routes << Route.new(start_station, end_station)
      puts 'Маршрут создан'
      manage_route
    end

    def append_station
      if routes.empty?
        puts 'Неоходимо добавить хотя бы 1 маршрут'
        create_route
      else
        routes_list = routes.map.with_index { |r, index| "#{index + 1}. #{r.stations.join(' - ')} " }.join("\n")
        route_number = user_input description: "Выберите маршрут для добавления станции\n#{routes_list}", convert: :to_i
        pp routes
        station = select_station(*routes[route_number - 1].stations)
        routes[route_number - 1].add_station(station)
      end
      puts '1. Добавить еще одну станцию?'

      repeat_or_main ? append_station : manage_route
    end

    def remove_station
      if @routes.empty?
        puts 'Нет маршрутов для отображения'
        create_route
      else
        routes_list = @routes.map.with_index { |r, index| "#{index + 1}. #{r.stations.join(' - ')} " }.join("\n")
        route_number = user_input description: "Выберите маршрут для удаления станции\n#{routes_list}", convert: :to_i

        puts 'Введите название станции для удаления'
        station_index = @routes[route_number - 1].stations.index(gets.chomp.to_s)

        if station_index.nil?
          puts 'Нет такой станции'
        elsif station_index.zero? || station_index == routes[route_number - 1].stations.rindex
          puts 'Начальную и конечную станцию удалить нельзя'
        else
          @routes[route_number - 1].stations.delete_at(station_index)
        end
        puts '1. Удалить еще одну станцию?'

        repeat_or_main ? remove_station : manage_route
      end
    end

    def select_station(*used_stations)
      puts "stations: #{stations.inspect}"
      puts "used stations: #{used_stations.inspect}"
      if stations.size > 1
        stations_name = stations.map(&:name) - used_stations
        stations_list = stations_name.map.with_index { |t, index| "#{index + 1}. #{t}" }.join("\n")
        station_number = user_input description: "Выберите станцию\n#{stations_list}", convert: :to_i
        stations_name[station_number - 1]
      else
        puts 'Неоходимо добавить хотя бы 2 станции'
        create_station
      end
    end

    def set_route
      if @routes.size.positive? && (@pass_trains.size.positive? || @cargo_trains.size.positive?)
        routes_list = @routes.map.with_index { |r, index| "#{index + 1}. #{r.stations.join(' - ')} " }.join("\n")
        route_number = user_input description: "Выберите маршрут для назначения\n#{routes_list}", convert: :to_i
        select_train.set_route(@routes[route_number - 1])
        puts 'Маршрут назначен'

        repeat_or_main ? set_route : start
      elsif @pass_trains.empty? && @cargo_trains.empty?
        puts 'Неоходимо добавить хотя бы 1 поезд'
        create_train
      else
        puts 'Неоходимо добавить хотя бы 1 маршрут'
        create_route
      end
    end

    def select_train(with_route = nil)
      trains = @pass_trains + @cargo_trains
      trains = trains.select(&:route) if with_route

      if trains.size.positive?
        trains_list = trains.map.with_index { |t, index| "#{index + 1}. #{t.name}" }.join("\n")
        train_number = user_input description: "Выберите поезд\n#{trains_list}", convert: :to_i
        trains[train_number - 1]
      elsif trains.empty? && with_route.nil?
        puts 'Неоходимо добавить хотя бы 1 поезд'
        create_train
      else
        puts 'Необходим поезд c назначеным маршрутом'
        set_route
      end
    end

    def manage_wagon
      choice = show_menu(:wagon)
      send(choice)
    end

    def add_wagon
      train = select_train
      pass_train = train.type == :passenger ? 1 : 0
      puts "Ведите #{pass_train == 1 ? 'количество мест в вагоне' : 'обьем вагона'}"
      places_volume = gets.chomp.to_i
      if pass_train == 1
        train.add_wagon(PassengerWagon.new(places_volume))
      else
        train.add_wagon(CargoWagon.new(places_volume))
      end
      puts 'вагон добавлен'
      manage_wagon
    end

    def delete_wagon
      puts 'Выберите поезд для отцепления вагона'
      train = select_train

      if train.wagons_number.zero?
        puts 'У поезда нет прицепленных вагонов'
      else
        puts "Поезд #{train.name} состоит из #{train.wagons_number} вагонов,",
             'введите номер вагона который необходимо отцепить'
        train.delete_wagon(gets.chomp.to_i - 1)
      end

      manage_wagon
      # station_train_list
    end

    def load_wagon
      train = select_train
      puts "В проезде #{train.wagons_number} вагонов, введите номер вагона для посадки пассажира/загрузки"
      wagon_number = gets.to_i - 1

      if train.type == :cargo
        puts 'Какой обьем загрузить?'
        train.wagons[wagon_number].take_volume(gets.chomp.to_i)
      else
        train.wagons[wagon_number].take_place
      end

      puts "Выполнено, свободно #{train.wagons[wagon_number].free_places}"

      manage_wagon
    end

    def move_train
      train = select_train(1)
      forward_back = user_input description: "Введите направления движения поезда:\n1. Вперед\n2. Назад", convert: :to_i
      forward_back == 1 ? train.go_next_station : train.go_previous_station
      puts "Поезд #{train.name} прибыл на станцию #{train.current_station}"

      start
    end

    def check_station(train, station)
      curr_index = @stations.index(station)
      stations[curr_index].accept_train(train) if curr_index
      previous_index = @stations.index(train.previous_station)
      stations[previous_index].send_train(train) unless previous_index
    end

    def station_train_list
      stations.each do |station|
        puts station.name
        station.station_trains do |train|
          puts "Номер поезда - #{train.number},
            тип поезда - #{train.type == :cargo ? 'грузовой' : 'пассажирский'}, количество вагонов: #{train.wagons_number}"
        end
      end

      start
    end

    def show_train_wagons
      train = select_train
      if train.type == :cargo
        cargo_pass = 'грузовой'
        place_volume = 'объем'
        used = 'занятый'
        free = 'свободный'
      else
        cargo_pass = 'пассажирский'
        place_volume = 'мест'
        used = 'занятых'
        free = 'свободных'
      end

      train.train_wagons do |wagon, _index|
        puts "Номер вагона - #{train.wagons.index(wagon) + 1},
      тип вагона - #{cargo_pass}, #{"#{free} #{place_volume}"} - #{wagon.free_places},
      #{"#{used} #{place_volume}"} - #{wagon.used_places}"
      end

      start
    end

    def repeat_or_main
      choice = user_input description: 'введите 1 для повторения операции или любую клавишу для возврата в главное меню'
      choice == 1
    end

    def get_trains_list; end
  end
end
