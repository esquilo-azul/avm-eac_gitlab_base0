# frozen_string_literal: true

require 'avm/instances/base'
require 'avm/gitlab/rest_api'
require 'eac_ruby_utils/core_ext'

module Avm
  module Gitlab
    class Instance < ::Avm::Instances::Base
      # @return [Avm::Gitlab::RestApi]
      def rest_api
        @rest_api ||= ::Avm::Gitlab::RestApi.new(web_url)
      end
    end
  end
end
