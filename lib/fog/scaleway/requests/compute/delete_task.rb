module Fog
  module Scaleway
    class Compute
      class Real
        def delete_task(task_id)
          delete("/tasks/#{task_id}")
        end
      end

      class Mock
        def delete_task(task_id)
          task = lookup(:tasks, task_id)

          data[:tasks].delete(task['id'])

          response(status: 204)
        end
      end
    end
  end
end
