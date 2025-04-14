# This play is used to upgrade bdbs and crdbs following a cluster upgrade
# it will report errors for databases already on the latest version but will
# continue to process any remaining databases
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

# First, upgrade the BDBs and CRDBs for both clusters
ansible-playbook -i $re_inv/$1  $re_ansbase/playbooks/redis-upgrade-databases.yaml --tags upgrade_databases
if [[ $? -eq 0 ]]; then
  ansible-playbook -i $re_inv/$2  $re_ansbase/playbooks/redis-upgrade-databases.yaml --tags upgrade_databases
else
  echo "First ansible-playbook run failed. Aborting second run for secondary AA cluster."
  exit -1
fi

# Then, run the "Update CRDB feature sets" task for just the first cluster
# Only one cluster needs to run this task, as the feature sets are shared between the two clusters
ansible-playbook -i $re_inv/$1  $re_ansbase/playbooks/redis-upgrade-databases.yaml --tags update_crdb_feature_sets
