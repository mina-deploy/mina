# # Helpers: Rsync helpers

module Mina
  module RsyncHelpers

    # ### rsync
    # Executes a command via rsync.
    #
    # STDOUT output of the Rsync progress.
    #
    # `mode` is a symbol of options:
    #
    #  - `:upload` - Upload files to remote.
    #  - `:download`  - Donwload files from remote.
    #
    # `options` is a hash of options:
    #
    #  - `:quiet`  - If set to true, no outputs.
    #
    # Example
    #
    #     rsync(:upload, "/tmp/something", "/var/www/flipstack.com")
    #     rsync(:download, "/var/www/flipstack.com", "/tmp/something")

    def rsync(mode, from, to, options = {})
      case mode
      when :upload
        command = "#{rsync_command options} #{from} #{rsync_remote to}"
      when :download
        command = "#{rsync_command options} #{rsync_remote from} #{to}"
      else
        die 1, "Incorrect rsync mode."
      end

      puts command

      result = Rsync.invoke(command)
      Rsync.ensure_successful result, self
    end

    # ### rsync_command
    # Returns the Rsync command to be executed.
    #
    # Example
    #
    #     set :ssh_options, "-o 'Compression yes'"
    #
    #     puts rsync_command
    #     #=> rsync -r -v -e --progress -e "ssh -o 'Compression yes'"

    def rsync_command(options = {})
      ssh_options = Rsync.ssh_options self
      ssh_options.gsub!('"') do
        '\\"'
      end
      args = ""
      args << "-n " if simulate_mode?
      args << "-q " if options[:quiet] == true
      args << "-r -v -e --progress -e \"ssh #{ssh_options}\""
      "rsync #{args}"
    end

    # ### rsync_remote
    # Returns the Rsync remote identifier to be executed.
    #
    # `path` is a remote location.
    #
    # Example
    #
    #     set :domain, 'foo.com'
    #     set :user, 'diggity'
    #
    #     puts rsync_remote("/var/www/flipstack.com")
    #     #=> 'diggity@foo.com:/var/www/flipstack.com'

    def rsync_remote(path)
      if user?
        "#{user}@#{domain}:#{path}"
      else
        "#{domain}:#{path}"
      end
    end

    # ## Private methods
    # `rsync` delegates to these.

    module Rsync

      extend self

      # ### Rsync.ssh_options
      # __Internal:__ Returns SSH options of rsync. Called by `rsync_command`.

      def ssh_options(this)
        args = ""
        args << " -i #{this.identity_file}" if this.identity_file?
        args << " -p #{this.port}" if this.port?
        args << " #{this.ssh_options}" if this.ssh_options?
        args
      end

      # ### Rsync.invoke
      # __Internal:__ Executes rsync by command `command`. Called by `rsync`

      def invoke(command)
        system command
        $?.to_i
      end

      # ### Rsync.ensure_successful
      # __Internal:__ Halts the execution if the given result code is not
      # successful (non-zero).

      def ensure_successful(result, this)
        this.die result if result.is_a?(Fixnum) && result > 0
        result
      end

    end

  end
end
