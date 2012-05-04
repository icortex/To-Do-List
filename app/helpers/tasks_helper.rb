module TasksHelper

  def is_active_date?(filter)
    'active' if params.has_value?(filter.to_s)
  end

  def is_active_any_date?
    'active' if !params.has_key?('f')
  end
end
