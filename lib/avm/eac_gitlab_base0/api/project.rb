# frozen_string_literal: true

require 'avm/eac_gitlab_base0/api/file'
require 'avm/eac_gitlab_base0/api/member'
require 'avm/eac_gitlab_base0/api/node'
require 'eac_rest/api'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacGitlabBase0
    class Api < ::EacRest::Api
      class Project < ::Avm::EacGitlabBase0::Api::Node
        FIELDS = %w[id description name name_with_namespace path path_with_namespace created_at
                    default_branch tag_list ssh_url_to_repo http_url_to_repo web_url readme_url
                    avatar_url star_count forks_count last_activity_at empty_repo archived
                    visibility resolve_outdated_diff_discussions container_registry_enabled
                    issues_enabled merge_requests_enabled wiki_enabled jobs_enabled snippets_enabled
                    issues_access_level repository_access_level merge_requests_access_level
                    wiki_access_level builds_access_level snippets_access_level
                    shared_runners_enabled lfs_enabled creator_id import_status
                    ci_default_git_depth public_jobs build_timeout auto_cancel_pending_pipelines
                    build_coverage_regex ci_config_path shared_with_groups
                    only_allow_merge_if_pipeline_succeeds request_access_enabled
                    only_allow_merge_if_all_discussions_are_resolved
                    remove_source_branch_after_merge printing_merge_request_link_enabled
                    merge_method auto_devops_enabled auto_devops_deploy_strategy].freeze

        FIELDS.each do |field|
          define_method field do
            data.fetch(field)
          end
        end

        def api_prefix
          "/projects/#{encode_id(id)}"
        end

        def full_path
          path_with_namespace
        end

        def file(path)
          fetch_entity(
            "#{api_prefix}/repository/files/#{encode_id(path)}?ref=#{default_branch}",
            ::Avm::EacGitlabBase0::Api::File,
            '404 File Not Found'
          )
        end

        def to_s
          path_with_namespace
        end

        private

        def members_uncached
          fetch_entities(
            "#{api_prefix}/members",
            ::Avm::EacGitlabBase0::Api::Member
          )
        end
      end
    end
  end
end
