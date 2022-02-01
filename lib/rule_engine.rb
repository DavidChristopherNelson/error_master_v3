require 'compute_logic'

module RuleEngine
  include ComputeLogic
  def run_rule_engine
    serialize_errors_and_filters
    match_errors_to_filters
  end

  private

  def serialize_errors_and_filters(resource)
    case resource['controller']
    when 'folders'
      @filters = Filter.serialize
      @deco_errors = DecoError.serialize_group(
        Folder.find(resource['id']).deco_errors
      )
    when 'filters'
      filter = Filter.find(resource['id'])
      @filters = Filter.serialize_group(
        Filter.where(execution_order: filter.execution_order..)
      )
      # Folder id 2 is the uncategorized folder.
      @deco_errors = DecoError.serialize_group(Folder.find(2).deco_errors)
      @filters.each do |filter|
        @deco_errors << DecoError.serialize_group(filter.deco_errors)
      end
    else
    end
    {
      deco_errors: @deco_errors,
      filters: @filters
    }
  end

  def match_errors_to_filters
    @deco_errors.each do |deco_error|
      @filters.each do |filter|
        if compute_match(deco_error, filter)
          active_record_error = DecoError.find(deco_error[:id])
          folder = active_record_error.folders.where.not(id: 1)
          active_record_error.folders.delete(folder)
          active_record_error.folders << Folder.find(filter[:folder_id])
          active_record_error.filter = Filter.find(filter[:id])
          break
        elsif filter == @filters[-1]
          active_record_error = DecoError.find(deco_error[:id])
          folder = active_record_error.folders.where.not(id: 1)
          # Avoids deleting and re-allocating the uncategorised folder
          break if folder.ids == [2]

          active_record_error.folders.delete(folder)
          DecoError.find(deco_error[:id]).folders << Folder.find(2)
          DecoError.find(deco_error[:id]).filter = Filter.find(1)
        else
        end
      end
    end
  end

  def match_error_to_filters(deco_error)
    @filters.each do |filter|
      if compute_match(deco_error, filter)
        active_record_error = DecoError.find(deco_error[:id])
        folder = active_record_error.folders.where.not(id: 1)
        active_record_error.folders.delete(folder)
        active_record_error.folders << Folder.find(filter[:folder_id])
        active_record_error.filter = Filter.find(filter[:id])
        break
      elsif filter == @filters[-1]
        active_record_error = DecoError.find(deco_error[:id])
        folder = active_record_error.folders.where.not(id: 1)
        # Avoids deleting and re-allocating the uncategorised folder
        break if folder.ids == [2]

        active_record_error.folders.delete(folder)
        DecoError.find(deco_error[:id]).folders << Folder.find(2)
        DecoError.find(deco_error[:id]).filter = Filter.find(1)
      else
      end
    end
  end
end
