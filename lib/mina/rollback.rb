namespace :deploy do
    desc 'rollback to a previous version'
    task :rollback do
        queue! "cd #{deploy_to}"
        queue! "export LAST=$(cat last_version)"
        queue! "export PREVIOUS=$(ls -l releases/ | awk '/^d/ {print $NF}' | sort -nk1 | tail -2 | head -1)"
        queue! "rm current"
        queue! "ln -s releases/$PREVIOUS current"
        queue! "rm -fr releases/$LAST"
        queue! "echo $PREVIOUS > last_version"
    end
end
