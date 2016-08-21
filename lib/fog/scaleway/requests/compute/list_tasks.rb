module Fog
  module Scaleway
    class Compute
      class Real
        def list_tasks
          get('tasks')
        end
      end

      class Mock
        def list_tasks
          tasks = data[:tasks].values

          response(status: 200, body: { 'tasks' => tasks })
        end
      end
    end
  end
end
