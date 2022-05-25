# frozen_string_literal: true

require 'avm/gitlab/rest_api/node'
require 'avm/gitlab/rest_api/project'
require 'eac_rest/api'
require 'eac_ruby_utils/core_ext'

module Avm
  module Gitlab
    class RestApi < ::EacRest::Api
      class Group < ::Avm::Gitlab::RestApi::Node
        FIELDS = %w[id web_url name path description visibility share_with_group_lock
                    require_two_factor_authentication two_factor_grace_period project_creation_level
                    auto_devops_enabled subgroup_creation_level emails_disabled lfs_enabled
                    avatar_url request_access_enabled full_name full_path parent_id].freeze

        FIELDS.each do |field|
          define_method field do
            data.fetch(field)
          end
        end

        def api_prefix
          "/groups/#{encode_id(id)}"
        end

        def to_s
          full_path
        end

        private

        def members_uncached
          fetch_entities(
            "#{api_prefix}/members",
            ::Avm::Gitlab::RestApi::Member
          )
        end

        def projects_uncached
          fetch_entities(
            "#{api_prefix}/projects?order_by=path&sort=asc&per_page=9999",
            ::Avm::Gitlab::RestApi::Project
          )
        end
      end
    end
  end
end
