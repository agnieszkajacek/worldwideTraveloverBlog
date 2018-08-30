module Users
  class SessionsController < Devise::SessionsController
   def new
     cookies[:username] = ENV["COOKIES"]
     super
   end
  end
end
