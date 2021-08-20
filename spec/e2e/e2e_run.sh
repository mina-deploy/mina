cd spec/e2e/
PUBLIC_KEY="$(cat ssh.pub)" docker-compose up -d mina-ssh \
  && docker exec -it mina-ssh sh -c "while [ ! -f /tmp/ready.txt ]; do sleep 2; done"
cd -
ssh-keygen -R \[0.0.0.0\]:2222
bundle exec rspec --tag e2e --order defined
status=$?
cd spec/e2e
docker-compose down
exit $status
