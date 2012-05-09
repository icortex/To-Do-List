class TasksController < ApplicationController

  before_filter :initialize_task, only: [:index, :done, :pending, :expired]
  before_filter :apply_filters, only: [:index, :done, :pending, :expired]

  def index
    @title = :all_tasks
  end

  def edit
    @task = Task.find(params[:id])
    session[:return_to] = request.referer
  end

  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: t(:task_created) }
      else
        apply_filters
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
        redirect_to session[:return_to], notice: t(:task_updated)
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
    @tasks = @tasks.done

    render 'index'
  end

  def pending
    @title = :pending_tasks
    @tasks = @tasks.pending

    render 'index'
  end

  def expired
    @title = :expired_tasks
    @tasks = @tasks.expired

    render 'index'
  end

  private
  def initialize_task
    @task = Task.new
  end

  def apply_filters
    params[:q] = params[:q] ? params[:q].reverse_merge({ s: 'deadline asc' }) : { s: 'deadline asc' }
    @q = Task.search(params[:q])
    @tasks = @q.result.paginate(:page => params[:page], :per_page => 8)
  end
end
