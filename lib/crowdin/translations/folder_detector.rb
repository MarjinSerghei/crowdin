module Crowdin
  module Translations
    module FolderDetector
      # rubocop:disable Metrics/AbcSize
      # :reek:DuplicateMethodCall and :reek:TooManyStatements
      def find_all(resource, folders = [])
        path = ->(entry) { Pathname.new File.join(resource, entry) }

        entries = resource.entries.select do |entry|
          File.directory?(path[entry]) && !entry.to_path.in?(%w(. ..))
        end

        entries.each do |entry|
          folders << sanitize_path(resource, entry)
          find_all path[entry], folders
        end

        folders.sort
      end

      def find_root(resource, locales: %w())
        entries = resource.entries.map(&:to_s)
        if locales.any?
          entries.select do |entry|
            locales.map(&:to_s).include? entry
          end
        else
          entries.reject { |folder| %w(. ..).include? folder }
        end
      end

      def sanitize_path(core_path, entry)
        path = core_path.to_s.sub(%r{.*\/config\/locales}, "").sub(%r{^/}, "")
        entry = entry.to_s.sub(%r{^/}, "")

        (path + "/" + entry).to_s
      end

      module_function :find_all, :find_root, :sanitize_path
      private_class_method :sanitize_path
    end
  end
end
