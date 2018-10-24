class NotificationsMailer < ApplicationMailer
    default :from => 'dont-reply@stories-capture.io'
     # send a signup email to the user, pass in the user object that   contains the user's email address
    def password_reset(user)
        @user = user
        mail( :to => @user.email,
        :subject => 'Password reset token.' )
    end

    def reset_confirmation(user)
        @user = user
        mail( :to => @user.email,
        :subject => 'Confirm password reset!' )
    end

    def welcome(user)
        @user = user
        mail( :to => @user.email,
        :subject => 'Welcome to Stories.' )
    end
end
