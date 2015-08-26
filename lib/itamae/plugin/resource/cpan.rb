require "itamae/resource/base"

module Itamae
  module Plugin
    module Resource
      class Cpan < Itamae::Resource::Base
        define_attribute :action, default: :install
        define_attribute :cpan_binary, type: [String, Array], default: 'cpan'
        define_attribute :package_name, type: String, default_name: true
      end
    end
  end
end
