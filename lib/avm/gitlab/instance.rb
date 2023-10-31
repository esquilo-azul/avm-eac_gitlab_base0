# frozen_string_literal: true

require 'avm/instances/base'
require 'avm/eac_gitlab_base0/api'
require 'eac_ruby_utils/core_ext'

module Avm
  module Gitlab
    class Instance < ::Avm::Instances::Base
      # @return [Avm::EacGitlabBase0::Api]
      def rest_api
        @rest_api ||= ::Avm::EacGitlabBase0::Api.new(web_url)
      end
    end
  end
end
