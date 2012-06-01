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
      set :current_path, "#{deploy_to}/current"
      set :lock_file, "#{deploy_to}/deploy.lock"

      old, @codes = @codes, nil
      yield
      new_code, @codes = @codes, old

      p new_code
      prepare = new_code[:default].map { |s| "(\n#{indent 2, s}\n)" }.join(" && ")
      restart = new_code[:restart].map { |s| "(\n#{indent 2, s}\n)" }.join(" && ")
      clean   = new_code[:clean].map { |s| "(\n#{indent 2, s}\n)" }.join(" && ")
      queue "deploy && ( #{prepare} ) && ( symlink ) && ( #{restart} ) || ( #{clean} )"
    end

    # Deploys and runs.
    def deploy!(&blk)
      deploy &blk
      run!
    end

    # SSHs into the host and runs the code that has been queued.
    def run!
      validate_set :hostname

      code = "(\n\n#{indent 2, codes[:default].join("\n")}\n\n) | ssh #{hostname} -- bash -"
      puts "Running this code:"
      puts code
    end

    # Queues code to be ran.
    def queue(code)
      codes
      codes[@code_block] << code.gsub(/^ */, '')
    end

    def codes
      @codes ||= begin
        @code_block = :default
        Hash.new { |h, k| h[k] = Array.new }
      end
    end

    def to(name, &blk)
      old, @code_block = @code_block, name
      yield
      @code_block = old
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
