module Fog
  module Scaleway
    class Compute
      class Task < Fog::Model
        identity :id

        attribute :description
        attribute :href_from
        attribute :progress
        attribute :started_at
        attribute :status
        attribute :terminated_at

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
