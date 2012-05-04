class TasksController < ApplicationController

  before_filter :initialize_task, only: [:index, :done, :pending, :expired]
  before_filter :initialize_query, only: [:index, :done, :pending, :expired]

  def index
    @title = :all_tasks
    @tasks = @q.result.paginate(:page => params[:page], :per_page => 10)
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
    @tasks = @q.result.done.paginate(:page => params[:page], :per_page => 10)

    render 'index'
  end

  def pending
    @title = :pending_tasks
    @tasks = @q.result.pending.paginate(:page => params[:page], :per_page => 10)

    render 'index'
  end

  def expired
    @title = :expired_tasks
    @tasks = @q.result.expired.paginate(:page => params[:page], :per_page => 10)

    render 'index'
  end

  private

  def initialize_task
    @task = Task.new
  end

  def initialize_query
    if params[:q]
      params[:q].reverse_merge!({s: 'deadline asc'})
    else
      params[:q] = {s: 'deadline asc'}
    end
    @q = Task.search(params[:q])
  end

end
