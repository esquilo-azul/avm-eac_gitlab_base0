# frozen_string_literal: true

require 'avm/gitlab/rest_api/base_entity'
require 'avm/gitlab/rest_api/project'
require 'eac_rest/api'
require 'eac_ruby_utils/core_ext'

module Avm
  module Gitlab
    class RestApi < ::EacRest::Api
      class Root < ::Avm::Gitlab::RestApi::BaseEntity
        def group(id)
          fetch_entity(
            "/groups/#{encode_id(id)}?with_projects=false",
            ::Avm::Gitlab::RestApi::Group,
            '404 Group Not Found'
          )
        end

        def project(id)
          fetch_entity(
            "/projects/#{encode_id(id)}",
            ::Avm::Gitlab::RestApi::Project,
            '404 Project Not Found'
          )
        end
      end
    end
  end
end
