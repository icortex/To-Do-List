class TasksController < ApplicationController

  def index
    @task = Task.new
    @tasks = case params[:status]
               when 'pending'
                 @title = :pending_tasks
                 Task.pending
               when 'done'
                 @title = :tasks_done
                 Task.done
               when 'expired'
                 @title = :expired_tasks
                 Task.expired
               else
                 @title = :all_tasks
                 Task
             end
    @tasks = @tasks.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end

  def edit
    @task = Task.find(params[:id])
    session[:return_to] ||= request.referer
  end

  def create
    @task = Task.new(params[:task])
    @tasks = Task.all

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
end
