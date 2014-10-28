if node[:environment][:framework_env] != "production"
  run %Q{echo "User-agent: *\nDisallow: /" > #{release_path}/public/robots.txt}
end