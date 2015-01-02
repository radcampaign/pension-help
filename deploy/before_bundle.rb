run "rm -rf #{config.release_path}/config/secrets.yml"
run "ln -nfs #{config.shared_path}/config/secrets.yml #{config.release_path}/config/secrets.yml"