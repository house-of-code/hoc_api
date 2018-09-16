module Orderable
  extend ActiveSupport::Concern

  module ClassMethods
  end

  # A list of the param names that can be used for ordering the model list
  def ordering_params(params, model = nil)
    # For example it retrieves a list of tasks in descending order of title
    #
    # GET /api/v1/lists/1/tasks?sort=-title,created_at
    # ordering_params(params) # => { title: :desc, created_at: :asc }
    # Task.order(title: :desc, created_at: :asc)
    #
    ordering = {}
    if params[:sort]
      sort_order = { '-' => :asc, '+' => :desc }
      sorted_params = params[:sort].split(',')
      sorted_params.each do |attr|
        sort_sign = (attr =~ /\A[+-]/) ? attr.slice!(0) : '+'
        model = model ||= controller_name.titlecase.singularize.constantize
        if model.attribute_names.include?(attr)
          ordering[attr] = sort_order[sort_sign]
        end
      end
    end
    return ordering
  end
end
