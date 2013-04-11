require "yaml"

module Skylight
  class SanityChecker
    def initialize
      @problems = Hash.new { |h,k| h[k] = [] }
    end

    def smoke_test(yaml_file)
      return @problems unless check_yaml_exists(yaml_file)
      return @problems unless check_yaml_is_hash(yaml_file)
    end

    def sanity_check(config)
      return @problems unless check_config_contents(config)
    end

  private
    def yaml_contents
      @yaml_contents ||= YAML.load_file(@yaml_file)
    end

    def check_yaml_exists(yaml_file)
      return true if File.exist?(yaml_file)

      @problems["skylight.yml"] << "does not exist"
      false
    end

    def check_yaml_is_hash(yaml_file)
      yaml_contents = YAML.load_file(yaml_file)
      return true if yaml_contents.is_a?(Hash)

      @problems["skylight.yml"] << "is not in the correct format"
      false
    end

    def check_config_contents(config)
      unless config.app_id
        @problems["skylight.yml"] << "does not contain an app id - please run `skylight create`"
        return false
      end

      unless config.authentication_token
        @problems["skylight.yml"] << "does not contain an app token - please run `skylight create`"
        return false
      end

      true
    end
  end
end
