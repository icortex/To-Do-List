class TasksController < ApplicationController

  before_filter :initialize_task, only: [:index, :done, :pending, :expired]
  #before_filter :initialize_query, only: [:index, :done, :pending, :expired]

  def index
    @title = :all_tasks
    @q, @tasks = Task.search(params)
    #@tasks = @q.result.paginate(:page => params[:page], :per_page => 10)
  end

  def edit
    @task = Task.find(params[:id])
    session[:return_to] = request.referer
  end

  def create
    @task = Task.new(params[:task])
    @tasks = Task.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: 'Task was successfully created.' }
      else
        format.html { render action: "index" }
      end
    end
  end

  def update
    @task = Task.find(params[:id])

    if @task.update_attributes(params[:task])
      if request.xhr?
        render text: request.referer
      else
        redirect_to session[:return_to], notice: 'Task was successfully updated.'
      end
    else
      render action: "edit"
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
    end
  end

  def done
    @title = :tasks_done
    #@tasks = Task.done.order('deadline DESC').paginate(:page => params[:page], :per_page => 10)
    @q, @tasks = Task.search(params)
    render 'index'
  end

  def pending
    @title = :pending_tasks
    @tasks = Task.pending.order('deadline DESC').paginate(:page => params[:page], :per_page => 10)

    render 'index'
  end

  def expired
    @title = :expired_tasks
    @tasks = Task.expired.order('deadline DESC').paginate(:page => params[:page], :per_page => 10)

    render 'index'
  end

  private

  def initialize_task
    @task = Task.new
  end

  def initialize_query
    ap params

    if params[:q]
      params[:q] = {s: 'deadline asc'}.merge(params[:q])
    else
      params[:q] = {s: 'deadline asc'}
    end
    case params[:date]
      when 'any'
        ap 'vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvd'
        ap params
      when 'month'
        'd'
      when 'week'
        'd'
      when 'day'
        'd'
      else
        'ddd'
    end
    @date_link_class = 'disabled'
  end

end
