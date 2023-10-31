# frozen_string_literal: true

require 'eac_rest/api'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacGitlabBase0
    class Api < ::EacRest::Api
      require_sub __FILE__

      API_SUFFIX = '/api/v4'

      def auth_token
        ENV.fetch('TRF1_GITLAB_PRIVATE_TOKEN')
      end

      def build_service_url_suffix(suffix)
        r = super(suffix)
        r.path = API_SUFFIX + r.path
        r
      end

      def custom_headers
        {
          'PRIVATE-TOKEN' => auth_token
        }
      end

      # @return [Avm::EacGitlabBase0::Api::ProjectsSet]
      def nodes_set(*projects_ids)
        ::Avm::EacGitlabBase0::Api::NodesSet.new(self, *projects_ids)
      end

      def request(service_url_suffix, headers = {}, &body_data_proc)
        super(service_url_suffix, custom_headers.merge(headers), &body_data_proc)
      end

      def root
        @root ||= ::Avm::EacGitlabBase0::Api::Root.new(self, {})
      end
    end
  end
end
