require "kemal"

module AlgoBacktester
    module Api
        serve_static false
        before_all do |env|
            #  Setting response content type
            env.response.content_type = "application/json"
        end

        get "/" do
            "Hello"
        end
    end
end