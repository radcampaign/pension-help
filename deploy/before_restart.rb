if config.node[:environment][:framework_env] != "production"
  run %Q{echo "User-agent: *\nDisallow: /" > #{config.release_path}/public/robots.txt}
end