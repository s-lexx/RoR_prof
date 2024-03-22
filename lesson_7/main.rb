require_relative 'train.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'wagon.rb'
require_relative 'cargo_wagon.rb'
require_relative 'passenger_wagon.rb'
require_relative 'station.rb'
require_relative 'route.rb'

class Task
  attr_accessor :stations, :routes, :pass_trains, :cargo_trains
  def initialize
    @stations = []
    @routes = []
    @pass_trains = []
    @cargo_trains = []
    @main_info = ['Cозданиe станиций', 'Добавлениe поездов', 'Создание и управление маршрутами', 
      'Назначение маршрутов', 'Добавить вагон к поезду', 'Отцепить вагон от поезда', 'Посадка пассажира/погрузка',
      'Перемещение поезда по маршруту', 'Просмотр станций и поездов на станциях', 'Просмотр список вагонов поезда', 'Выход']
    @station_action = ['Добавить станцию', 'Главное меню']
    @train_action = ['Добавить поезд', 'Главное меню']
    @route_action = ['Добавить маршрут', 'Добавить станцию в маршрут', 'Удалить станцию из маршрута', 'Главное меню']      

  end  

  def output_input(array, key = nil)
        
    case key
      when 'routes'
        array.each_with_index {|item, index| puts "#{index + 1}. #{item.stations}"}  
      when 'name'
        array.each_with_index {|item, index| puts "#{index + 1}. #{item.name}"}
      else 
        array.each_with_index {|item, index| puts "#{index + 1}. #{item}"}
      end  
    
    gets.chomp.to_i
  end

  def main_menu
    
    case output_input(@main_info)
      when 1 
        station_creation
      when 2  
        train_creation
      when 3
        route_creation  
      when 4
        set_route 
      when 5
        add_wagon#{}1 = PassengerTrain.new("027-мс", "123456")
      when 6
        delete_wagon
      when 7
        load_wagon
      when 8
        move_train     
      when 9
        station_train_list
      when 10 
        show_wagons
      when 11
        exit
        
    end

  end

  def station_creation

    puts "Введите название станции"
    @stations << Station.new(gets.chomp.to_s) 
    
    case output_input(@station_action) 
      when 1
        station_creation
      when 2
        main_menu  
      end      
  end

   def train_creation
    begin
      puts "Введите название поезда"
      train_name = gets.chomp.to_s
      puts "введите номер поезда в формате 3 буквы или цифры, тире(опционально) и 2 цифры"  
      train_number = gets.chomp.to_s
      puts "Выберите тип поезда \n1. пассажирский\n2. грузовой"
      gets.chomp.to_i == 1 ? @pass_trains << PassengerTrain.new(train_number, train_name) : 
        @cargo_trains << CargoTrain.new(train_number, train_name)
    rescue StandardError => e
      puts e
      retry            
    end 
      
    puts "Поезд создан"

  case output_input(@train_action) 
    when 1
      train_creation
    when 2
      main_menu  
  end 

   end

  def route_manage
    
    case output_input(@route_action) 
      when 1
        route_creation
      when 2
        route_add_station
      when 3
        route_remove_station    
      when 4
        main_menu  
    end   

    puts "Введите название поезда"
    train_name = gets.chomp.to_s
    puts "Выберите тип поезда \n1. пассажирский\n2. грузовой"
    gets.chomp.to_i == 1 ? @pass_trains << PassengerTrain.new(train_name) : 
      @cargo_trains << CargoTrain.new(train_name)
             
  end

  def route_creation
    puts "Введите название начальной станции"
    start_station = gets.chomp.to_s
    puts "Введите название конечной станции"    
    @routes << Route.new(start_station, gets.chomp.to_s)
    route_manage
  end
 
  def route_add_station
    
    unless @routes.size.zero?
      puts "Выберите маршрут для добавления станции"
      route_namber = output_input(@routes, 'routes')
      puts "Введите название промежуточной станции"
      @routes[route_namber - 1].add_station(gets.chomp.to_s)
      puts "1. Добавить еще одну станцию?"
      gets.chomp.to_i == 1 ? route_add_station : route_manage
    else 
      puts "Неоходимо добавить хотя бы 1 маршрут"
      route_creation
    end    

  end 

  def route_remove_station
    
    unless @routes.size.zero?
      puts "Выберите маршрут для удаления станции"
      route_namber = output_input(@routes, 'routes')
      puts "Введите название станции для удаления"
      station_index = @routes[route_namber - 1].stations_list.index(gets.chomp.to_s)
      
      if station_index.nil?
        puts "Нет такой станции"           
      elsif station_index == 0 || station_index == @routes[route_namber - 1].stations_list.rindex
        puts "Начальную и конечную станцию удалить нельзя"            
      else
        @routes[route_namber - 1].stations_list.delete_at(station_index)                      
      end

      route_manage

    else
      puts "Нет маршрутов для отображения"
      route_creation
    end

  end 

  def set_route
    
    if @routes.size > 0 && (@pass_trains.size > 0 || @cargo_trains.size > 0)
      puts "Выберите маршрут для назначения"
      route_namber = output_input(@routes, 'routes')
      puts "Выберите поезд для маршрута"
      trains = @pass_trains + @cargo_trains
      train_number = output_input(trains, 'name')     
      trains[train_number - 1].set_route(@routes[route_namber - 1])
      main_menu
    elsif @pass_trains.size.zero? && @cargo_trains.size.zero?
      puts "Неоходимо добавить хотя бы 1 поезд"  
      train_creation
    else 
      puts "Неоходимо добавить хотя бы 1 маршрут"
      route_creation
    end   

  end

  def select_train(with_route = nil)
    trains = @pass_trains + @cargo_trains
    trains = trains.select {|train| train.route} if with_route
    
    if trains.size > 0
      trains[output_input(trains, 'name') - 1]
    elsif trains.size.zero? && with_route.nil?      
      puts "Неоходимо добавить хотя бы 1 поезд"     
      train_creation
    else
      puts "Необходим поезд c назначеным маршрутом"   
      set_routet
    end

  end

  def add_wagon  
    puts "Выберите поезд для добавления вагона"
    train = select_train
    pass_train = train.type == :passenger ? 1 : 0
    puts "Ведите #{pass_train == 1 ? 'количество мест в вагоне' : 'обьем вагона'}"
    places_volume = gets.chomp.to_i
    pass_train == 1 ? train.add_wagon(PassengerWagon.new(places_volume)) :
      train.add_wagon(CargoWagon.new(places_volume))      
    puts "вагон добавлен"

    main_menu        
  end

  def delete_wagon
    puts "Выберите поезд для отцепления вагона"
    train = select_train
    
    unless train.wagon_number.zero?    
      puts "Поезд #{train.name} состоит из #{train.wagon_number} вагонов,", 
      "введите номер вагона который необходимо отцепить"
      train.delete_wagon(gets.chomp.to_i - 1)
      main_menu  
    else
      puts "У поезда нет прицепленных вагонов"  
      main_menu    
    end
    
    station_train_list
  end

  def load_wagon
    train = select_train
    puts "В проезде #{train.wagons_number} вагонов, введите номер вагона для посадки пассажира/загрузки"
    wagon_number = gets.to_i - 1

      if train.type == :cargo 
        puts "Какой обьем загрузить?"
        train.wagons[wagon_number].take_volume(volume = gets.chomp.to_i)
      else
        train.wagons[wagon_number].take_place
      end 
    
    puts "Выполнено, свободно #{train.wagons[wagon_number].free_places}"

    main_menu
  end

  def move_train
    train = select_train(1)
    puts "Введите направления движения поезда:\n1. Вперед\n2.Назад"
    gets.chomp.to_i == 1 ? train.go_next_station : train.go_previous_station
    puts "Поезд #{train.name} прибыл на станцию #{train.current_station}"
    
    main_menu
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
      station.station_trains {|train| puts "Номер поезда - #{train.number}, 
      тип поезда - #{train.type == :cargo ? 'грузовой' : 'пассажирский'}, количество вагонов: #{train.wagons_number}"}
    end  

    main_menu 
  end

  def show_wagons
    train = select_train
    wagon_number = 1
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

    train.train_wagons {|wagon, index| puts "Номер вагона - #{train.wagons.index(wagon) + 1},
      тип вагона - #{cargo_pass}, #{free + ' ' + place_volume} - #{wagon.free_places}, 
      #{used + ' ' + place_volume} - #{wagon.used_places}"}
  
    main_menu
  end

  
end

task = Task.new
task.main_menu
