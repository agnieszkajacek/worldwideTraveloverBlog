module Users
  class SessionsController < Devise::SessionsController
   def new
     cookies[:username] = "agnieszka"
     super
   end
  end
end
