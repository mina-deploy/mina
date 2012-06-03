describe "Invoking the 'vh' command in a project" do
  describe "to do a simulated deploy" do
    before :each do
      vh 'deploy', 'simulate=1'
    end
    
    it "should take care of the lockfile" do
      stdout.should =~ /ERROR: another deployment is ongoing/
      stdout.should =~ /touch ".*deploy\.lock"/
      stdout.should =~ /rm -f ".*deploy\.lock"/
    end

    it "should honor release_path" do
      stdout.should include "#{Dir.pwd}/releases"
      stdout.should =~ /cd ".*releases\/#{Time.now.strftime('%Y-%m-%d')}/
    end

    it "should symlink the current_path" do
      stdout.should =~ /ln -s ".*releases\/#{Time.now.strftime('%Y-%m-%d')}.*current/
    end

    it "should include deploy directives" do
      stdout.should include "bundle exec rake db:migrate"
    end

    it "should include 'to :restart' directives" do
      stdout.should include "sudo /opt/sbin/nginx -s reload"
    end
  end
end
