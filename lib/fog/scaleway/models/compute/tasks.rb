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
          if (task = service.get_task(identity).body['task'])
            new(task)
          end
        rescue Fog::Scaleway::Compute::UnknownResource
          nil
        end
      end
    end
  end
end
