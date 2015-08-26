require "itamae/resource/base"

module Itamae
  module Plugin
    module Resource
      class Cpan < Itamae::Resource::Base
        define_attribute :action, default: :install
        define_attribute :cpan_binary, type: [String, Array], default: 'cpan'
        define_attribute :perl_binary, type: [String, Array], default: 'perl'
        define_attribute :package_name, type: String, default_name: true
        define_attribute :cpan_options, type: [String, Array], defulat: ''

        def pre_action
          case @current_action
          when :install
            attributes.installed = true
          end
        end

        def set_current_attributes
          installed = installed_cpan_modules.find do |cpan|
            cpan =~ /#{attributes.package_name}/
          end
          current.installed = !!installed
        end

        def action_install(action_install)
          return if current.installed
          install!
          updated!
        end

        private

        def installed_cpan_modules
          cpan = []
          run_command(find_cpan_module_command).stdout.each_line do |line|
            cpan << line
          end
          cpan
        end

        def find_cpan_module_command
          "find \`perl -e 'print \"@INC\"'` -name \"*.pm\" -print"
        end

        def build_cpan_command
          [*Array(attributes.cpan_binary), attributes.package_name]
        end

        def install!
          run_command(build_cpan_command)
        end
      end
    end
  end
end
