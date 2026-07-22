if [ -e "$1" ]; then
  echo Input Missing
  exit 1
fi
echo "Running Following Command"
echo "#######################"
echo ansible-playbook -i ${1}-dev.cubicletocharts.cloud, -e ansible_user=ec2-user -e ansible_password=DevOps321 ${1}.yml
echo "#######################"
git pull ; ansible-playbook -i ${1}-dev.cubicletocharts.cloud, -e ansible_user=ec2-user -e ansible_password=DevOps321 ${1}.yml