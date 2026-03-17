# frozen_string_literal: true

module Legion
  module Extensions
    module Affordance
      module Actor
        class Scan < Legion::Extensions::Actors::Every
          INTERVAL = 30

          def run
            Runners::Affordance.instance_method(:update_affordances).bind_call(runner_instance)
          end
        end
      end
    end
  end
end
