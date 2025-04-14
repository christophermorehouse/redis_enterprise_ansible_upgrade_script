# Update Redis Enterprise using inventory files 
# by default the release applied will be 're_url' defined in the group_vars
# for the selected inventory.  This can be overridden on the command line
# by adding '-e re_url=<url for download>'  (no quotes)
#
# arg 1 - selects the first inventory file in ./inventory
# arg 2 - selects the second inventory file in ./inventory
#
if [[ $# -ne 2 ]]; then
  echo "*****************************************************************"
  echo "Usage: $0 <inventory_file1> <inventory_file2> [-e 're_url=<download link>'"
  echo "note: the env var 're_inv' should be set to point to the subdir"
  echo "      containing <inventory_file1> and <inventory_file2>"
  echo "      re_url is defined in the group_vars file - it can be "
  echo "      overriden using -e 're_url=<download_link>'"
  echo "*****************************************************************"
  exit -1
fi

ansible-playbook -i $re_inv/$1  $re_ansbase/playbooks/redis-upgrade.yaml
if [[ $? -eq 0 ]]; then
  ansible-playbook -i $re_inv/$2  $re_ansbase/playbooks/redis-upgrade.yaml
else
  echo "First ansible-playbook run failed. Aborting second run for secondary AA cluster."
  exit -1
fi