set :chruby_path, '/etc/profile.d/chruby.sh'

task :chruby, :env do |_, args|
  unless args[:env]
    puts "Task 'chruby' needs a Ruby version as an argument."
    puts "Example: invoke :'chruby[ruby-1.9.3-p392]'"
    exit 1
  end

  comment %{chruby to version: \\"#{args[:env]}\\"}
  command %{
    if [[ ! -s "#{fetch(:chruby_path)}" ]]; then
      echo "! chruby.sh init file not found"
      exit 1
    fi
  }
  command %{source #{fetch(:chruby_path)}}
  command %{chruby "#{args[:env]}" || exit 1}
end
