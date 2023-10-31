# frozen_string_literal: true

require 'avm/eac_gitlab_base0/api/base_entity'
require 'eac_rest/api'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacGitlabBase0
    class Api < ::EacRest::Api
      class File < ::Avm::EacGitlabBase0::Api::BaseEntity
        FIELDS = %w[file_name file_path size encoding content_sha256 ref blob_id commit_id
                    last_commit_id].freeze

        FIELDS.each do |field|
          define_method field do
            data.fetch(field)
          end
        end

        def content
          case encoding
          when 'base64' then ::Base64.decode64(encoded_content)
          else nyi("Unmapped encoding: #{encoding}")
          end
        end

        def encoded_content
          data.fetch('content')
        end
      end
    end
  end
end
