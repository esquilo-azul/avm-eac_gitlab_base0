# frozen_string_literal: true

require 'eac_rest/api'
require 'eac_rest/entity'
require 'eac_ruby_utils/core_ext'

module Avm
  module EacGitlabBase0
    class Api < ::EacRest::Api
      class BaseEntity < ::EacRest::Entity
        enable_simple_cache

        def delete(url_suffix)
          api.request(url_suffix).verb(:delete).response.body_data
        end

        def encode_id(id)
          return id if id.is_a?(::Integer)

          ::CGI.escape(id.to_s)
        end

        def fetch_entity(suffix, klass, not_found_message = nil)
          validate_response_data(
            dump_response(api.request_json(suffix).response),
            not_found_message
          ).if_present { |v| klass.new(api, v) }
        end

        def fetch_entities(suffix, klass)
          r = []
          request = api.request_json(suffix)
          while request
            response = request.response
            r += validate_response_data(response).map { |rr| klass.new(api, rr) }
            request = response.link('next').if_present do |v|
              api.request_json(v)
            end
          end
          r
        end

        def dump_response(response)
          basename = response.url.to_s.variableize[0..99]
          { data: response.body_data, headers: response.headers, links: response.links }
            .each { |part, value| dump_debug("#{basename}_#{part}", value) }
          response
        end

        def dump_debug(basename, data)
          file = ::Pathname.new('/tmp').join('gitlab_temp', basename + '.yaml')
          file.parent.mkpath
          ::EacRubyUtils::Yaml.dump_file(file, data)
        end

        def validate_response_data(response, not_found_message = nil)
          if response.body_data.is_a?(::Hash)
            response.body_data['error'].if_present do |v|
              raise "URL: #{response.url}, Data: #{v}"
            end

            response.body_data['message'].if_present do |v|
              return nil if v == not_found_message
            end
          end

          response.body_data
        end
      end
    end
  end
end
