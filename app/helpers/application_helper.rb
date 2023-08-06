# frozen_string_literal: true

module ApplicationHelper
  def avatar_url(staff)
    "https://api.dicebear.com/6.x/adventurer/svg?backgroundColor=b6e3f4,c0aede,d1d4f9,ffd5dc,ffdfbf&size=48&seed=#{staff.name.parameterize}"
  end

  def nav_link(text, route)
    base_classes = 'font-medium min-[820px]:py-6'

    if current_page?(route)
      link_to(text, route, 'aria-current': 'page', class: "#{base_classes} text-blue-600 dark:text-blue-500")
    else
      link_to(text, route,
              class: "#{base_classes} text-gray-500 hover:text-gray-400 dark:text-gray-400 dark:hover:text-gray-500")
    end
  end
end
