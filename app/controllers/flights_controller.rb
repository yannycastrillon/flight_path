class FlightsController < ApplicationController
  before_action :set_flight, only: [:show, :update, :destroy]

  def index
    @flights = Flight.all

    render json: @flights
  end

  def show
    render json: @flight
  end

  def create
    @flight = Flight.new(flight_params)

    if @flight.save
      render json: @flight, status: :created, location: @flight
    else
      render json: @flight.errors, status: :unprocessable_entity
    end
  end

  def update
    if @flight.update(flight_params)
      render json: @flight
    else
      render json: @flight.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @flight.destroy
  end

  def calculate_path
    paths = format_path(params[:flight_path])
    final = calculate_source_destination(paths)

    render json: { "client_path": final }
  end

  private

    def calculate_source_destination(paths)
      # [["'ATL'", " 'EWR'"]|["'SFO'", " 'ATL'"]]
      source_destination = Hash.new
      # Build hash structure where 'sources' and 'destination'
      paths.each do |tuple|
        source_destination[tuple.first] = tuple.last
      end
      # Take out all spaces on values
      source_destination.each_value(&:strip!)
      validate_final_source_destination(source_destination)
    end

    def validate_final_source_destination(source_destination)
      arr_final = Array.new
      source_destination.keys.each do |src|
        unless source_destination.value?(src)
          @src = src
        end
      end
      source_destination.values.each do |destination|
        unless source_destination.key?(destination)
          @destination = destination
        end
      end
      arr_final << @src
      arr_final << @destination
    end

    # formats the current string to an array of tuples
    def format_path(str)
      first_format = str[1..str.length - 2].split('|') # => [ "['ATL', 'EWR'] ", " ['SFO', 'ATL']" ]
      second_format = first_format.map { |e| e[1..e.length - 2] } # => ["'ATL', 'EWR'", "'SFO', 'ATL'"]
      second_format.map { |e| e.strip.split(',') } # [["'ATL'", " 'EWR'"], ["'SFO'", " 'ATL'"]]
    end

    def set_flight
      @flight = Flight.find(params[:id])
    end

    def flight_params
      params.require(:flight).permit(:source, :destination)
    end
end
