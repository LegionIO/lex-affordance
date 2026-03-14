# frozen_string_literal: true

require 'legion/extensions/affordance/version'
require 'legion/extensions/affordance/helpers/constants'
require 'legion/extensions/affordance/helpers/affordance_item'
require 'legion/extensions/affordance/helpers/affordance_field'
require 'legion/extensions/affordance/runners/affordance'
require 'legion/extensions/affordance/client'

module Legion
  module Extensions
    module Affordance
      extend Legion::Extensions::Core if Legion::Extensions.const_defined?(:Core)
    end
  end
end
