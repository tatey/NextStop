task :deploy do
  sh "rsync -rtzh --progress --delete --exclude #{File.path(__FILE__)} #{File.dirname(__FILE__)}/ tatey@tatey.com:~/var/www/nextstop.me/"
end
