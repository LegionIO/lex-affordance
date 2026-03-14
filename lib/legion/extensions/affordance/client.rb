# frozen_string_literal: true

require 'legion/extensions/affordance/helpers/constants'
require 'legion/extensions/affordance/helpers/affordance_item'
require 'legion/extensions/affordance/helpers/affordance_field'
require 'legion/extensions/affordance/runners/affordance'

module Legion
  module Extensions
    module Affordance
      class Client
        include Runners::Affordance

        def initialize(field: nil, **)
          @field = field || Helpers::AffordanceField.new
        end

        private

        attr_reader :field
      end
    end
  end
end
