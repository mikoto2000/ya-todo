class TodoStatusesController < ApplicationController
  include Pagy::Backend
  before_action :set_todo_status, only: %i[show edit update destroy]

  # GET /todo_statuses
  def index
    @todo_statuses = TodoStatus
      .all
    @q = @todo_statuses.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @todo_statuses = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /todo_statuses/1
  def show
  end

  # GET /todo_statuses/new
  def new
    @todo_status = TodoStatus.new
  end

  # GET /todo_statuses/1/edit
  def edit
  end

  # POST /todo_statuses
  def create
    @todo_status = TodoStatus.new(todo_status_params)

    if @todo_status.save
      redirect_to @todo_status, notice: t("controller.create.success", model: TodoStatus.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todo_statuses/1
  def update
    if @todo_status.update(todo_status_params)
      redirect_to @todo_status, notice: t("controller.edit.success", model: TodoStatus.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /todo_statuses/1
  def destroy
    @todo_status.destroy
    redirect_to todo_statuses_url, notice: t("controller.destroy.success", model: TodoStatus.model_name.human)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_todo_status
      @todo_status = TodoStatus
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_status_params
      params.require(:todo_status).permit(:name)
    end
end
