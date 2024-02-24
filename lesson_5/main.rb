require_relative 'train.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'wagon.rb'
require_relative 'cargo_wagon.rb'
require_relative 'passenger_wagon.rb'
require_relative 'station.rb'
require_relative 'route.rb'

class Task
  
  def initialize
    @stations = []
    @routes = []
    @pass_trains = []
    @cargo_trains = []
    @main_info = ['Cозданиe станиций', 'Добавлениe поездов', 'Создание и управление маршрутами', 
      'Назначение маршрутов', 'Добавить вагон к поезду', 'Отцепить вагон от поезда',
      'Перемещение поезда по маршруту', 'Просмотр станций и поездов на станциях', 'Выход']
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
        add_wagon
      when 6
        delete_wagon
      when 7
        move_train     
      when 8
        station_train_list
      when 9 
        exit
    end

  end

  def station_creation#{}require_relative 'manufacturer'
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
    puts "Введите название поезда"
    train_name = gets.chomp.to_s
    puts "Выберите тип поезда \n1. пассажирский\n2. грузовой"
    gets.chomp.to_i == 1 ? @pass_trains << PassengerTrain.new(train_name) : 
      @cargo_trains << CargoTrain.new(train_name)          
    
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
      puts "Неоходим поезд c назначеным маршрутом"   
      set_route
    end

  end

  def add_wagon  
    puts "Выберите поезд для добавления вагона"
    train = select_train
    train.type == :passenger ? train.add_wagon(PassengerWagon.new) :
      train.add_wagon(CargoWagon.new)      
    
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

  def move_train
    train = select_train(1)
    puts "введите направления движения поезда:\n1. Вперед\n2.Назад"
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
    puts "Выберите станцию для просмотра поездов на ней",
    @stations[output_input(@stations, 'name') - 1].trains_by_name

    main_menu 
  end

end

Task.new.main_menu
