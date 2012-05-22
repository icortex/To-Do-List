module TasksHelper

  def task_row_class(task)
    task.status
  end

  def is_active_date?(filter)
    'active' if params.has_value?(filter.to_s)
  end

  def is_active_any_date?
    'active' if !params.has_key?('f')
  end

  def date_filter_path(filter)
    if params[:q]
      case filter
        when :today
          params.merge(q: {deadline_eq: Date.today, name_cont: params[:q][:name_cont], s: params[:q][:s]}, 
                       f: :today).except(:page)
        when :week
          params.merge(q: {deadline_gteq: Date.today.beginning_of_week, deadline_lteq: Date.today.end_of_week, 
                           name_cont: params[:q][:name_cont], s: params[:q][:s]}, f: :week).except(:page)
        when :month
          params.merge(q: {deadline_gteq: Date.today.beginning_of_month, deadline_lteq: Date.today.end_of_month, 
                           name_cont: params[:q][:name_cont], s: params[:q][:s]}, f: :month).except(:page)
        when :any
          params[:q].except(:deadline_gteq, :deadline_lteq, :page, :name_cont, :s)
        else
          nil
      end
    end
  end
end
