module ApplicationHelper



  def current_user
    super || guest_user
  end


  def sortable(column, title, model_class, default_column="name")
    title ||= column.titleize
    default_column ||= "name"
    css_class = column == sort_column(model_class,default_column) ? "current_sort #{sort_direction}" : nil
    direction = column == sort_column(model_class,default_column) && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  def sort_column model_class,default_column="name"
    default_column ||= "name"
    model_class::SORTABLE_FIELDS.include?(params["sort"]) ? params["sort"] : default_column
  end

  def sort_direction
    %w[asc desc].include?(params["direction"]) ? params["direction"] : "asc"
  end

  def core_paginate collection
    %(
        <div class='wrap_pagination'>
          <div class="page_info">
            #{page_entries_info collection}
          </div>
          #{will_paginate collection, {:container => false}}
        </div>
    ).html_safe
  end

  ## function to shorten a long string logically.
  # for example : we have a string as "Parts Operation and Sales"
  # for char_count = 10, result is "Parts..."
  # for char_count = 20, result is "Parts Operation.."
  def shorten_string (full_string, char_count = 20)
    if full_string.length >= char_count
      full_string_temp = full_string[0, char_count]
      split_full_string = full_string_temp.split(/\s/)
      fullWords = split_full_string.length
      split_full_string[0, fullWords-1].join(" ") + '...'
    else
      full_string
    end
  end

  private

  def guest_user
    begin User.find(session[:guest_user_id])
    rescue
      create_guest_user
    end
  end

  def create_guest_user
    u = User.create(:name => "guest",:is_guest => true, :email => "guest_#{Time.now.to_i}#{rand(99)}@example.com")
    u.save(:validate => false)
    session[:guest_user_id] = u.id
    u
  end

  def global_path path_helper, params_hash={}, engine = nil
    if engine.blank?
      Rails.application.routes.url_helpers.send(path_helper,params_hash)
    else
      engine::Engine.routes.url_helpers.send(path_helper,params_hash)
    end
  rescue
    nil
  end

end
