module VanHelsing
  module Helpers
    # Invokes another Rake task.
    def invoke(task)
      Rake::Task[task.to_sym].invoke
    end

    # Wraps the things inside it in a deploy script.
    def deploy(&blk)
      validate_set :deploy_to

      set :current_version, Time.now.strftime("%Y-%m-%d--%H-%m-%S")
      set :release_path, "#{deploy_to}/releases/#{current_version}"

      old, @code = @code, Array.new
      yield
      new_code, @code = @code, old

      deploy_codes = new_code.map { |s| "(\n#{indent 2, s}\n)" }.join(" && ")
      queue "deploy && ( #{deploy_codes} ) || ( cleanup_on_failure )"
    end

    # Deploys and runs.
    def deploy!(&blk)
      deploy &blk
      run!
    end

    # SSHs into the host and runs the code that has been queued.
    def run!
      validate_set :hostname

      code = "(\n\n#{indent 2, @code.join("\n")}\n\n) | ssh #{hostname} -- bash -"
      puts "Running this code:"
      puts code
    end

    # Queues code to be ran.
    def queue(code)
      @code ||= Array.new
      @code << code.gsub(/^ */, '')
    end

    def set(key, value)
      settings.send :"#{key}=", value
    end

    def settings
      @settings ||= OpenStruct.new
    end

    def method_missing(meth, *args, &blk)
      @settings.send meth, *args
    end

    def indent(count, str)
      str.gsub(/^/, " "*count)
    end

    def error(str)
      $stderr.write "#{str}\n"
    end

    def validate_set(*settings)
      settings.each do |key|
        unless @settings.send(key)
          error "ERROR: You must set the :#{key} setting."
          exit 1
        end
      end
    end
  end
end
