# frozen_string_literal: true

require 'avm/gitlab/rest_api/base_entity'
require 'avm/gitlab/rest_api/project'
require 'eac_rest/api'
require 'eac_ruby_utils/core_ext'

module Avm
  module Gitlab
    class RestApi < ::EacRest::Api
      class NodesSet
        IDS_PREFIXES = {
          '@@' => :group_and_projects, '@-' => :group_projects, '@' => :group
        }.freeze

        GROUP_AND_PROJECTS_ID_PARSER = /\A\@@(.*)\z/.to_parser { |m| m[1] }
        GROUP_ID_PARSER = /\A\@(.*)\z/.to_parser { |m| m[1] }

        class << self
          def parse_id(id)
            IDS_PREFIXES.each do |prefix, type|
              /\A#{::Regexp.quote(prefix)}(.*)\z/.if_match(id, false) do |m|
                return [m[1], type]
              end
            end

            [id, :project]
          end
        end

        attr_reader :rest_api
        attr_writer :no_groups

        def initialize(rest_api, *ids)
          self.rest_api = rest_api
          ids.each { |id| add(id) }
        end

        def add(id)
          parsed_id, type = self.class.parse_id(id)

          send("add_by_#{type}_id", parsed_id)
        end

        # @return [Array<Avm::Gitlab::RestApi::Group>]
        def group
          nodes.select { |node| node.is_a?(::Avm::Gitlab::RestApi::Group) }
        end

        # @return [Array<Avm::Gitlab::RestApi::Project>]
        def projects
          nodes.select { |node| node.is_a?(::Avm::Gitlab::RestApi::Project) }
        end

        # @return [Array<Avm::Gitlab::RestApi::Node>]
        def nodes
          r = nodes_set
          r = r.reject { |g| g.is_a?(::Avm::Gitlab::RestApi::Group) } if no_groups?
          r.sort_by { |p| [p.full_path] }
        end

        def no_groups?
          @no_groups ? true : false
        end

        private

        attr_writer :rest_api

        # @return [Set<Avm::Gitlab::RestApi::Project>]
        def nodes_set
          @nodes_set ||= ::Set.new
        end

        # @return [Avm::Gitlab::RestApi::Node]
        def add_node(node)
          nodes_set.add(node)

          node
        end

        # @return [Array<Avm::Gitlab::RestApi::Group>]
        def add_by_group_id(id)
          group = rest_api.root.group(id)

          raise "No group found with ID = \"#{id}\"" unless group

          [add_node(group)]
        end

        # @return [Array<Avm::Gitlab::RestApi::Project>]
        def add_by_group_projects_id(id)
          group = rest_api.root.group(id)

          raise "No group found with ID = \"#{id}\"" unless group

          group.projects.map do |project|
            add_node(project)
          end
        end

        # @return [Array<Avm::Gitlab::RestApi::Node>]
        def add_by_group_and_projects_id(id)
          add_by_group_id(id) + add_by_group_projects_id(id)
        end

        # @return [Array<Avm::Gitlab::RestApi::Project>]
        def add_by_project_id(id)
          project = rest_api.root.project(id)

          raise "No project found with ID = \"#{id}\"" unless project

          [add_node(project)]
        end
      end
    end
  end
end
