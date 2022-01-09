# frozen_string_literal: true

module Mina
  class Application < Rake::Application
    include Configuration::DSL

    def initialize
      super
      @rakefiles = ['Minafile', '.deploy.rb', 'deploy.rb', 'config/deploy.rb', minafile]
    end

    def name
      'mina'
    end

    # :nocov:
    def run(*args)
      Rake.application = self
      super(*args)
    end
    # :nocov:

    def sort_options(options)
      options_not_applicable_to_mina = /--#{Regexp.union(['quiet', 'silent', 'verbose', 'dry-run'])}/

      mina_options = options.reject { |(switch, *)| switch =~ options_not_applicable_to_mina }
      mina_options += [version, verbose, simulate, debug_configuration_variables, no_report_time]

      super(mina_options)
    end

    def top_level_tasks
      return @top_level_tasks if @top_level_tasks.include?('init')

      @top_level_tasks << 'debug_configuration_variables'
      @top_level_tasks << 'run_commands'
    end

    private

    def minafile
      File.expand_path(File.join(File.dirname(__FILE__), '..', 'Minafile'))
    end

    def version
      [
        '--version', '-V',
        'Display the program version.',
        lambda do |_value|
          puts "Mina, version v#{Mina::VERSION}"
          exit
        end
      ]
    end

    def verbose
      [
        '--verbose', '-v',
        'Print more info',
        lambda do |_value|
          set(:verbose, true)
        end
      ]
    end

    def simulate
      [
        '--simulate', '-s',
        'Do a simulate run without executing actions',
        lambda do |_value|
          set(:simulate, true)
        end
      ]
    end

    def debug_configuration_variables
      [
        '--debug-configuration-variables', '-d',
        'Display the defined config variables before runnig the tasks.',
        lambda do |_value|
          set(:debug_configuration_variables, true)
        end
      ]
    end

    def no_report_time
      [
        '--no-report-time', nil,
        'Skip time reporting',
        lambda do |_value|
          set(:skip_report_time, true)
        end
      ]
    end
  end
end
