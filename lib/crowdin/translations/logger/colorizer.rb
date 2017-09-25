module Colorizer
  module InstanceMethods
    def red
      "\e[31m#{self}\e[0m"
    end

    def green
      "\e[32m#{self}\e[0m"
    end

    def yellow
      "\e[33m#{self}\e[0m"
    end

    def blue
      "\e[34m#{self}\e[0m"
    end

    def violet
      "\e[35m#{self}\e[0m"
    end

    def cyan
      "\e[36m#{self}\e[0m"
    end

    def regular
      self
    end
  end

  def self.included(*)
    String.public_send(:include, InstanceMethods)
  end
end
