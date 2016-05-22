set :branch, 'master'

namespace :git do
  desc 'Clones the Git repository to the release path.'
  task :clone do
    ensure!(:repository)
    ensure!(:deploy_to)
    if set?(:commit)
      comment "Using git commit '#{fetch(:commit)}'"
      command "git clone '#{fetch(:repository)}' . --recursive"
      command "git checkout -b current_release '#{fetch(:commit)}' --force"
    else
      command "if [ ! -d '#{fetch(:deploy_to)}/scm/objects' ]; then"
      comment '-----> Cloning the Git repository'
      command "git clone '#{fetch(:repository)}' '#{fetch(:deploy_to)}/scm' --bare"
      command 'else'
      comment 'Fetching new git commits'
      in_path "#{fetch(:deploy_to)}/scm" do
        command "git fetch '#{fetch(:repository)}' '#{fetch(:branch)}:#{fetch(:branch)}' --force"
      end
      command 'fi'
      comment "Using git branch '#{fetch(:branch)}'"
      command "git clone '#{fetch(:deploy_to)}/scm' . --recursive --branch '#{fetch(:branch)}'"
      # %{
      #   if [ ! -d "#{deploy_to}/scm/objects" ]; then
      #     echo "-----> Cloning the Git repository"
      #     #{echo_cmd %[git clone "#{repository}" "#{deploy_to}/scm" --bare]}
      #   else
      #     echo "-----> Fetching new git commits"
      #     #{echo_cmd %[(cd "#{deploy_to}/scm" && git fetch "#{repository!}" "#{branch}:#{branch}" --force)]}
      #   fi &&
      #   echo "-----> Using git branch '#{branch}'" &&
      #   #{echo_cmd %[git clone "#{deploy_to}/scm" . --recursive --branch "#{branch}"]} &&
      # }
    end

    comment 'Using this git commit'
    command 'git rev-parse HEAD > .mina_git_revision'
    command "git --no-pager log --format='%aN (%h):%n> %s' -n 1"
    command 'rm -rf .git'
    binding.pry
  end

  task :revision do
    ensure!(:deploy_to)
    command "cat #{fetch(:deploy_to)}/#{fetch(:current_path)}/.mina_git_revision"
  end
end
