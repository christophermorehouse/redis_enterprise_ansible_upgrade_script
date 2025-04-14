# set env for ansible_redis playbooks and scripts
# assumed to be run from the base subdir where scripts/ and playbooks/ are found
export re_ansbase=`pwd`
# there may be an existing inventory tree somewhere else
export re_inv=`pwd`'/inventory/'
echo "re_ansbase: " $re_ansbase
echo "re_inv: " $re_inv