cd spec/e2e/
chmod 600 ssh
PUBLIC_KEY="$(cat ssh.pub)" docker-compose up -d mina-ssh \
  && docker exec mina-ssh sh -c "while [ ! -f /tmp/ready.txt ]; do sleep 2; done"
cd -
[[ -z "${CI}" ]] && ssh-keygen -R \[0.0.0.0\]:2222
bundle exec rspec --tag e2e --order defined
status=$?
cd spec/e2e
docker-compose down
exit $status
