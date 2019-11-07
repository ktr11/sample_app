class ApplicationController < ActionController::Base
    perfect_from_forgery with: :exception

    def hello
        render html: "hello world!"
    end
end
