# Crowdin

This library is using [_Crowdin API_](https://support.crowdin.com/api/api-integration-setup/) to perform the following operations againts _travel_management_platform_ translation files:
  - _download_
  - _sync_
  - _update_

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'crowdin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crowdin

## Usage

### Project initialization
##### Adding folders to the remote project
#
```ruby
bundle exec rake crowdin:translations:add_dirs[locale]
```

##### Adding files to the remote project
#
```ruby
bundle exec rake crowdin:translations:add_files[locale]
```

##### Setting up the remote project with a single command
#
```ruby
bundle exec rake crowdin:translations:setup[locales]
```

> Warning: These commands must be run only once (at the moment of creation). To avoid translation progress losses better use: ` sync ` and ` update_files ` when remote project is already initialized
#
> Warning: `setup` command does the following in background:
- removes __/download__ folder if present
- removes remote folders
- adds remote folders
- adds remote files

### Translations fetching

##### Export translations (_build latest changes on Crowdin_)
#
```ruby
bundle exec rake crowdin:translations:export[locale]
```

##### Download translations
#
```ruby
bundle exec crowdin:translations:download[locale]
```

> Note: Run `export` command each time before `download`
#
> Note: `download` command will fetch the remote files, create a local folder __config/locales/download__ and store the fetched files there. Files can be manually copied to __config/locales/<locale>/...__
#

### Files synchronization

##### Synchronize folders
#
```ruby
bundle exec rake crowdin:translations:sync_dirs[locale]
```

##### Synchronize files
#
```ruby
bundle exec rake crowdin:translations:sync_files[locale]
```

##### Synchronize folders and files with a single command
#
```ruby
bundle exec rake crowdin:translations:sync[locale]
```

### Translation keys update
##### Update all remote files (_keeps translation progress_)
#
```ruby
bundle exec rake crowdin:translations:update_files[locale]
```

##### Update specific remote files
#
```ruby
bundle exec rake crowdin:translations:update_files[locale] -- --files <path to file>
```

> Note: Adds the missing keys to the remote project and keeps the **Crowdin** translation progress
#

> Note: It supports the optional argument `--files-max` which specifies the number of files to be updated per batch. The default and maximum value is __20__. However it happens that __Crowdin API__ fails and file history can be lost. For this purpose `--files-max 1` can be used along to the specified `--files` to be updated. 

In the following example the specified files will be uploaded `one by one` which adds a bit of reliability but cuts down the performance.
```ruby
bundle exec rake crowdin:translations:update_files[locale] -- --files <path to file> --files-max 1
```

Here no `--files` are specified so it will update all of them `one by one`.
```ruby
bundle exec rake crowdin:translations:update_files[locale] -- --files-max 1
```

### Translations status
```ruby
bundle exec rake crowdin:translations:status[locale]
```

> Note: This command will return the information about translation progress
#


### Example of usage
Ex: *API endpoint*: ` <api_url>/update-file?key=<api_key> ` maps to:
```ruby
Crowdin::Translations::Endpoints::UpdateFileEndpoint
```

> Note: Each endpoint has it's own class.

> Note: Current implementation uses **rake tasks** to invoke **call** method for each of the endpoint's created object.
> Note: Use **endpoint** helper to get an object of a certain endpoint.

Ex: `endpoint(:update_file).call(locale: locale, files: files)` will return the result of:
```ruby
Crowdin::Translations::Endpoints::UpdateFileEndpoint#call(locale: locale, files: files)
```

Here are the endpoints with the signature of **call** method:
```ruby
 - Crowdin::Translations::Endpoints::UpdateFileEndpoint#call(locale:, files:)
 - Crowdin::Translations::Endpoints::AddDirectoryEndpoint#call(locale:)
 - Crowdin::Translations::Endpoints::AddFilesEndpoint#call(locale:)
 - Crowdin::Translations::Endpoints::ChangeDirectoryEndpoint#call
 - Crowdin::Translations::Endpoints::DeleteDirectoryEndpoint#call(locales:)
 - Crowdin::Translations::Endpoints::DownloadEndpoint#call(locale:)
 - Crowdin::Translations::Endpoints::ExportEndpoint#call
 - Crowdin::Translations::Endpoints::InfoEndpoint#call(locale:)
 - Crowdin::Translations::Endpoints::DeleteFileEndpoint#call(file:)
 - Crowdin::Translations::Endpoints::LanguageStatusEndpoint#call(locale:)
 - Crowdin::Translations::Endpoints::PreTranslateEndpoint#call(languages:, files:, method: :tm, engine: :microsoft, approve_translated: false, import_duplicates: true, apply_untranslated_strings_only: false, perfect_match: false)
```

An example of **rake task**:

```ruby
namespace :crowdin do
  namespace :translations do
    task :add_dirs, [:locale] => :environment do |_, args|
      Crowdin::Translations::Logger.info "Adds the folders to Crowdin project...", color: :green
      add_dirs(locale: args[:locale])
    end
  end
end

```

> Note: `Crowdin::Translations::Endpoints::DownloadEndpoint#call(locale:)` **waits for a block** to specify how it should handle the **Crowdin's API** response (**.zip** file).

> Info: Current **TMP rake task** deletes **config/locales/downloads** folder if it exists, creates it again and extracts everything from the **.zip** file.

> Note: For more information check TMP's **lib/tasks/crowdin/translations/** implementation of the **rake tasks**.

#### Starting point. Phase 1
- ##### Initialization
  - 1st option
    ```ruby
    bundle exec rake crowdin:translations:add_dirs[locale]
    ```
    ```ruby
    bundle exec rake crowdin:translations:add_files[locale]
    ```
  - 2nd option
    ```ruby
    bundle exec rake crowdin:translations:setup[locale]
    ```

#### Phase 2
Working with translations is a continuous process. It is a matter of time when some member of the development team will add a new translation file or a new translation key to an existing file, or even both of them at the same time. Hence one needs to synchronize periodically the local files with the remote ones so that the *Crowdin* translator sees the new files/strings and performs the translation process.

```ruby
bundle exec rake crowdin:translations:sync[locale]
```

> Note: The `sync` and `update_files` commands must be used to let the translator keep track of the new translation files and keys.
#
> Note: The `status` command may be used to keep track of translator's progress.
#

#### Phase 3
This is not actually a phase. Whenever is needed one can run the `export` and `download` commands and fetch the translations from __Crowdin__.


### What can be improved?
- Add validation for `add_dirs`, `add_files` and `setup` commands. Skip the execution if remote project had been already initialized
- Move **rake tasks** to a separate `gem`. Ex: **crowdin-cli**
- Implement branching strategy

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/locomote/crowdin.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
