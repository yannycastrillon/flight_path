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
    puts params[:flight_path]



    render json: { "client_path": params[:flight_path] }
  end

  private
    def set_flight
      @flight = Flight.find(params[:id])
    end

    def flight_params
      params.require(:flight).permit(:source, :destination)
    end
end
