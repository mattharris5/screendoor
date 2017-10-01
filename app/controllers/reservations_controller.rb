class ReservationsController < ApplicationController
  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.future

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reservations }
    end
  end

  def all
    @reservations = Reservation.all

    respond_to do |format|
      format.html { render action: 'index' }
      format.json { render json: @reservations }
    end
  end

  def housekeeping
    @reservations = Reservation.future #.needs_housekeeping_scheduled

    respond_to do |format|
      format.html
      format.json { render json: @reservations }
    end
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reservation }
    end
  end

  # GET /reservations/new
  # GET /reservations/new.json
  def new
    @reservation = Reservation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reservation }
    end
  end

  # GET /reservations/1/edit
  def edit
    @reservation = Reservation.find(params[:id])
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
        format.json { render json: @reservation, status: :created, location: @reservation }
      else
        format.html { render action: "new" }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reservations/1
  # PUT /reservations/1.json
  def update
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      if @reservation.update_attributes(reservation_params)
        format.html { redirect_to reservations_path, notice: 'Reservation was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy

    respond_to do |format|
      format.html { redirect_to reservations_url }
      format.json { head :no_content }
    end
  end

  def import
    if Reservation.import_from_ics
      flash[:notice] = "Successfully imported."
    else
      flash[:error] = "Error."
    end

    redirect_to :back
  end

  protected

  def reservation_params
    params.require(:reservation).permit(:cleaning_scheduled, :end_date, :name, :start_date, :status, :uid, :welcome_sent, :cleaning_completed)
  end
end
