module Fog
  module Scaleway
    class Compute
      class Real
        def get_task(task_id)
          get("/tasks/#{task_id}")
        end
      end
    end
  end
end
