module ApplicationHelper
  def webpack_target_path
    Rails.env.development? ? "http://localhost:3035/main.js" : "/packs/main.js"
  end
end
