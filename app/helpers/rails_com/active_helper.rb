module RailsCom::ActiveHelper



  # active_assert('notice' == 'notice', expected: 'ui info message', unexpected: 'ui negative message')
  def active_assert(assert, expected: 'item active', unexpected: 'item')
    if assert
      expected
    else
      unexpected
    end
  end

  # path: active_helper path: 'work/employees'
  # controller: active_helper controller: 'xxx'  or active_helper controller: ['xxx1', 'admin/xxx2']
  # action: active_helper 'work/employee': ['index', 'show']
  # params: active_params state: 'xxx'
  # active_page controller: 'users', action: 'show', id: 371
  def active_helper(paths: [], controllers: [], active_class: 'item active', item_class: 'item', **options)
    check_parameters = options.delete(:check_parameters)

    if paths.present?
      Array(paths).each do |path|
        return active_class if current_page?(path, check_parameters: check_parameters)
      end
    end

    if controllers.present?
      return active_class if (Array(controllers) & [controller_name, controller_path]).size > 0
    end

    return active_class if current_page?(options)

    if (options.keys.map(&:to_s) & [controller_name, controller_path]).present?
      options.each do |_, value|
        return active_class if value.include?(action_name)
      end
    end

    item_class
  end

  def active_params(options, active_class: 'item active', item_class: 'item')
    options.select { |_, v| v.present? }.each do |k, v|
      if params[k].to_s == v.to_s
        return active_class
      end
    end

    item_class
  end

  def filter_params(options = {})
    except = options.delete(:except)
    only = options.delete(:only)
    query = request.GET.dup

    if only.present?
      query.slice!(*only)
    else
      excepts = []
      if except.is_a? Array
        excepts += except
      else
        excepts << except
      end
      excepts += ['commit', 'utf8', 'page']

      query.except!(*excepts)
    end

    query.merge!(options)
    query.reject! { |_, value| value.blank? }
    query
  end

end