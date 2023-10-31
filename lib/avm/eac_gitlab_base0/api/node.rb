# frozen_string_literal: true

require 'avm/eac_gitlab_base0/api/base_entity'
require 'avm/eac_gitlab_base0/api/file'
require 'eac_rest/api'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacGitlabBase0
    class Api < ::EacRest::Api
      class Node < ::Avm::EacGitlabBase0::Api::BaseEntity
        compare_by :id

        def remove_member(user_id)
          delete("#{api_prefix}/members/#{encode_id(user_id)}")
        end
      end
    end
  end
end
