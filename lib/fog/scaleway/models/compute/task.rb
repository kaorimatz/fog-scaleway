module Fog
  module Scaleway
    class Compute
      class Task < Fog::Model
        identity :id

        attribute :status
        attribute :description
        attribute :terminated_at
        attribute :href_from
        attribute :progress
        attribute :started_at

        def pending?
          status == 'pending'
        end

        def success?
          status == 'success'
        end

        def destroy
          requires :identity

          service.delete_task(identity)
          true
        end
      end
    end
  end
end
