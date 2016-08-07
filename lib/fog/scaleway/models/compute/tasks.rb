module Fog
  module Scaleway
    class Compute
      class Tasks < Fog::Collection
        model Fog::Scaleway::Compute::Task

        def all
          tasks = service.list_tasks.body['tasks']
          load(tasks)
        end

        def get(identity)
          task = service.get_task(identity).body['task']
          new(task) if task
        end
      end
    end
  end
end
