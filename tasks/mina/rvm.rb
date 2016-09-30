set :rvm_use_path, '$HOME/.rvm/scripts/rvm'

task :'rvm:use', :env do |_, args|
  unless args[:env]
    puts "Task 'rvm:use' needs an RVM environment name as an argument."
    puts "Example: invoke :'rvm:use', 'ruby-1.9.2@default'"
    exit 1
  end

  comment %{Using RVM environment \\\"#{args[:env]}\\\"}
  command %{
    if [[ ! -s "#{fetch(:rvm_use_path)}" ]]; then
      echo "! Ruby Version Manager not found"
      echo "! If RVM is installed, check your :rvm_use_path setting."
      exit 1
    fi
  }
  command %{source #{fetch(:rvm_use_path)}}
  command %{rvm use "#{args[:env]}" --create}
end

task :'rvm:wrapper', :env, :name, :bin do |_, args|
  unless args[:env] && args[:name] && args[:bin]
    puts "Task 'rvm:wrapper' needs an RVM environment name, an wrapper name and the binary name as arguments"
    puts "Example: invoke :'rvm:wrapper', 'ruby-1.9.2@myapp,myapp,unicorn_rails'"
    exit 1
  end

  comment %{creating RVM wrapper "#{args[:name]}_#{args[:bin]}" using \\"#{args[:env]}\\"}
  command %{
    if [[ ! -s "#{fetch(:rvm_use_path)}" ]]; then
      echo "! Ruby Version Manager not found"
      echo "! If RVM is installed, check your :rvm_use_path setting."
      exit 1
    fi
  }
  command %{source #{fetch(:rvm_use_path)}}
  command %{rvm wrapper #{args[:env]} #{args[:name]} #{args[:bin]} || exit 1}
end
