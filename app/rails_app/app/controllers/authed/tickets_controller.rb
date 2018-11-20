class Authed::TicketsController < AuthController
  layout 'authed/tickets'

  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = Ticket.where("project_id = ?", current_project_id)
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
    @users = User.all
  end

  # GET /tickets/1/edit
  def edit
    @users = User.all
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)
    @users = User.all

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /tickets/1/download_attachment_file
  def download_attachment_file
    @ticket = Ticket.find(params[:id])
    filepath = @ticket.attachment_file.current_path
    stat = File::stat(filepath)
    send_file(filepath, :filename => @ticket.attachment_file_identifier, :length => stat.size)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      #params.fetch(:ticket, {})
      params.require(:ticket).permit(:name,
                                     :summary,
                                     :status,
                                     :attachment_file,
                                     :attachment_file_cache,
                                     :remove_attachment_file,
                                     :work_time,
                                     :start_date,
                                     :end_date,
                                     :project_id,
                                     :assigned_user_id)
    end
end
