module Fog
  module Scaleway
    class Compute
      class Real
        def get_task(task_id)
          get("/tasks/#{task_id}")
        end
      end

      class Mock
        def get_task(task_id)
          task = lookup(:tasks, task_id)

          if Time.now - Time.parse(task['started_at']) >= Fog::Mock.delay
            task['status'] = 'success'
            task['terminated_at'] = now
            task['progress'] = 100
          end

          response(status: 200, body: { 'task' => task })
        end
      end
    end
  end
end
