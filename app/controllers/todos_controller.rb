class TodosController < ApplicationController
  include Pagy::Backend
  before_action :set_todo, only: %i[show edit update destroy]

  # GET /todos
  def index
    @todos = Todo
      .eager_load(:todo_status)
    @q = @todos.ransack(params[:q])
    @q.sorts = "id asc" if @q.sorts.empty?
    @pagy, @todos = pagy(@q.result, page: params[:page], items: params[:items])
  end

  # GET /todos/1
  def show
  end

  # GET /todos/new
  def new
    @todo = Todo.new
    @todo.todo_status_id = TodoStatusesHelper::NEW
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos
  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      redirect_to @todo, notice: t("controller.create.success", model: Todo.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todos/1
  def update
    if @todo.update(todo_params)
      redirect_to @todo, notice: t("controller.edit.success", model: Todo.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /todos/1
  def destroy
    @todo.destroy
    redirect_to todos_url, notice: t("controller.destroy.success", model: Todo.model_name.human)
  end

  # POST /todo_bulk_insert
  def bulk_insert
    errors = Todo.csv_import(params[:file])

    if errors.empty?
      flash.notice = t("controller.create.success", model: Todo.model_name.human)
    else
      flash.alert = errors
    end

    redirect_to todos_url
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo
        .eager_load(:todo_status)
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:name, :todo_status_id)
    end
end
