module Crowdin
  module Translations
    module FolderDetector
      def find_all(resource, folders = [])
        detect_folders(resource).each do |entry|
          folders << sanitize_path(resource, entry)
          find_all Pathname.new(File.join(resource, entry)), folders
        end

        folders.sort
      end

      def detect_folders(resource)
        resource.entries.select do |entry|
          path = Pathname.new File.join(resource, entry)
          entry_name = entry.to_path
          File.directory?(path) && !%w(. ..).include?(entry_name)
        end
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

      module_function :find_all, :find_root, :sanitize_path, :detect_folders
      private_class_method :sanitize_path, :detect_folders
    end
  end
end
