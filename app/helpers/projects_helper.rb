module ProjectsHelper

  # # get all of the active projects and put the users recent projects first in the list
  # # if project_id is provided, then select it by default
  # def projects_grouped_for_user(project_id=nil)
  #   html = "<option></option>"
  #   user_projects, projects = Project.grouped_by_recent(current_user.id)

  #   if user_projects.present?
  #     html += user_projects.map{|x|
  #       if x.id == project_id
  #         "<option value='#{x.id}' selected='selected'>#{x.full_name}</option>"
  #       else
  #         "<option value='#{x.id}'>#{x.full_name}</option>"
  #       end
  #     }.join
  #     html += "<option data-divider='true'></option>"
  #   end
  #   html += projects.map{|x|
  #       if x.id == project_id
  #         "<option value='#{x.id}' selected='selected'>#{x.full_name}</option>"
  #       else
  #         "<option value='#{x.id}'>#{x.full_name}</option>"
  #       end
  #   }.join

  #   return html.html_safe
  # end


  # show all of the active projects and their activities
  # if activity_id is provided, then select it by default
  def projects_with_grouped_activities(activity_id=nil)
    html = "<option value=''></option>"
    projects = Project.is_active.sorted_organization_activities

    if projects.present?
      projects.each do |project|
        html << "<optgroup label='#{project.full_name}' title='#{project.notes}'>"
        html << project.activities.map{|x|
          "<option value='#{x.id}' title='#{x.notes}' selected='#{x.id == activity_id ? 'selected' : ''}'>#{x.full_name}</option>"
        }.join
        html << "</optgroup>"
      end
    end

    return html.html_safe
  end

end
