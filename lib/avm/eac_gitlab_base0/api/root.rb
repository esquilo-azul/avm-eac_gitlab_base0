# frozen_string_literal: true

require 'avm/eac_gitlab_base0/api/base_entity'
require 'avm/eac_gitlab_base0/api/project'
require 'eac_rest/api'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacGitlabBase0
    class Api < ::EacRest::Api
      class Root < ::Avm::EacGitlabBase0::Api::BaseEntity
        def group(id)
          fetch_entity(
            "/groups/#{encode_id(id)}?with_projects=false",
            ::Avm::EacGitlabBase0::Api::Group,
            '404 Group Not Found'
          )
        end

        def project(id)
          fetch_entity(
            "/projects/#{encode_id(id)}",
            ::Avm::EacGitlabBase0::Api::Project,
            '404 Project Not Found'
          )
        end
      end
    end
  end
end
