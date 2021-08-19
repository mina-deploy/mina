# frozen_string_literal: true

task :reset_task do
  command 'echo Hello there'
  reset!
  command 'echo New command'
end

task :one_run_inside_another do
  run :local do
    run :remote do
      puts "I shouldn't execute"
    end
  end
end

task :local_run do
  run :local do
    comment 'I am a comment'
    command 'echo Hello there'
  end
end

task :remote_run do
  run :remote do
    comment 'I am a comment'
    command 'echo Hello there'
  end
end

task :nonexistent_run do
  run :nonexistent do
    comment "I shouldn't run"
  end
end

task :on_stage_task do
  deploy do
    on :launch do
      command 'echo Hello there'
    end
  end
end

task :in_path_task do
  in_path '/path' do
    command 'echo Hello there'
  end
end

task :deploy_block_task do
  deploy do
    command 'echo Hello there'
  end
end
