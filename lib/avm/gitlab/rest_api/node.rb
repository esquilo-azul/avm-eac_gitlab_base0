# frozen_string_literal: true

require 'avm/gitlab/rest_api/base_entity'
require 'avm/gitlab/rest_api/file'
require 'eac_rest/api'
require 'eac_ruby_utils/core_ext'

module Avm
  module Gitlab
    class RestApi < ::EacRest::Api
      class Node < ::Avm::Gitlab::RestApi::BaseEntity
        compare_by :id

        def remove_member(user_id)
          delete("#{api_prefix}/members/#{encode_id(user_id)}")
        end
      end
    end
  end
end
