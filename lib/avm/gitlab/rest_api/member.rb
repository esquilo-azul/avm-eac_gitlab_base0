# frozen_string_literal: true

require 'avm/gitlab/rest_api/base_entity'
require 'eac_rest/api'
require 'eac_ruby_utils/core_ext'

module Avm
  module Gitlab
    class RestApi < ::EacRest::Api
      class Member < ::Avm::Gitlab::RestApi::BaseEntity
        FIELDS = %w[id name username state avatar_url web_url access_level expires_at].freeze

        FIELDS.each do |field|
          define_method field do
            data.fetch(field)
          end
        end

        def to_s
          [name, username, state, access_level].join(' / ')
        end
      end
    end
  end
end
