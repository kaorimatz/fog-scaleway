module Fog
  module Scaleway
    class Compute
      class Real
        def list_tasks
          get('tasks')
        end
      end
    end
  end
end
