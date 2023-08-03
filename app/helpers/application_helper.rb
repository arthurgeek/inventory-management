# frozen_string_literal: true

module ApplicationHelper
  def avatar_url(staff)
    "https://api.dicebear.com/6.x/adventurer/svg?backgroundColor=b6e3f4,c0aede,d1d4f9,ffd5dc,ffdfbf&size=48&seed=#{staff.name.parameterize}"
  end
end
