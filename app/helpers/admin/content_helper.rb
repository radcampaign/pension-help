module Admin::ContentHelper

  #Creates drop-down for selecting parent site.
  # current_id - id of currently edited Content
  # selected_id - id of parent of currently edited Content
  def select_for_parent_contents(collection, current_id, selected_id)
    result = "<select id=\"parent_id\" name=\"parent_id\">"
    for c in collection
      result << "<option value=\"#{c.id unless c.id == current_id}\" #{'selected' if c.id == selected_id}>#{'&nbsp;' * c.level * 2}#{c.title}</option>"
    end
    result << "</select>"

    return result
  end
end
