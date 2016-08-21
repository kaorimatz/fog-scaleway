module Fog
  module Scaleway
    class Compute
      class Real
        def list_bootscripts(filters = {})
          get('/bootscripts', filters)
        end
      end

      class Mock
        def list_bootscripts(filters = {})
          bootscripts = data[:bootscripts].values

          if (arch = filters[:arch])
            bootscripts.select! { |b| b['architecture'] == arch }
          end

          response(status: 200, body: { 'bootscripts' => bootscripts })
        end
      end
    end
  end
end
