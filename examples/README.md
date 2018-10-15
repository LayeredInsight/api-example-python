# Runtime client API scripts examples
This is a collection of example usages of the python scripts leveraging our Swagger library

## Registries
* Self signed registry certificate 
```
./li_add_registry --url api-demo.layeredinsight.net --username username --certificate "`cat /etc/docker/certs.d/registry-hostname/ca.crt`" --tls-verify ...
```
* docker private registry
```
./li_add_registry -v --name my-registry  --type private --url IPorFQDN --username user --password passwd
```
* docker.io public (pull only)
```
./li_add_registry -v --name docker.pull  --type docker.io --url "" --username "" --password ""
```
* docker.io private
```
./li_add_registry -v --name docker.io    --type docker.io --url "" --username dockeruser --password dockerpasswd
```
* Docker Trusted Registry 
```
./li_add_registry -v --name dockeree.dtr --type dtr --url ec2-public-ip.compute-1.amazonaws.com --username mydtr-user --password mydtr-passwd
```
* AWS ECR
```
./li_add_registry -v --name aws.ecr      --type ecr --url account_id.dkr.ecr.aws-region.amazonaws.com --username aws_access_key_id --password aws_secret_access_key
```

## Images
* Private registry
```
docker tag alpine:latest api-demo.layeredinsight.net/username/alpine:latest
docker push api-demo.layeredinsight.net/username/alpine:latest

./li_add api-demo.layeredinsight.net/username/alpine:latest
```
* Pull from public, push to private registry
```
./li_add docker.io/alpine:latest api-demo.layeredinsight.net username/alpine:latest
```

## Policies
* Create a policy that denies all network connections from an accept syscall rule, then add an exception.
```
policy_id=`./li_create_accept_policy`
src_ip=172.21.0.12
src_port=-1 \# '-1' is our any port wildcard
local_port=80
./li_add_rule_to_policy -v --id ${policy_id} --name "allow accept from ${src_ip} to local port: ${local_port}" --position 0 --type syscall --syscall sys_accept --arg1 ${src_port} --arg2 ${src_ip} --arg3 ${local_port} --action allow
```
* Export policy rules and import into another policy
```
export_policy_id=`./li_create_passwd_policy`
\# -v required to print rules
./li_get_policy -v --id ${export_policy_id} | grep -A 9999 '^policy.rules:' | tail -n +2 > ./export-policy-sys_name-rules.csv
./li_add_rule_to_policy -v --id "${policy_id}" --position 0 --rules-sys-csv ./export-policy-sys_name-rules.csv --rules-csv-fixed-name "import rules policy ${export_policy_id}"
```
* Build a behavioral policy from container logs
```
./li_build_policy --containerid 5a7b468efb212f000183a174
```
* Add a rule to a policy
```
\# Add a rule to a container policy (behavior policies by default deny unexpected behavior).
./li_add_rule_to_policy --policy-name 'Container 5a7b468efb212f000183a174 behavior' --name 'allow tail to open httpd logs' --program '/usr/bin/tail'  --action allow --syscall "sys_open" --arg1 '/var/log/httpd/*'
```
*  Add a set of rules from another policy.csv to an existing policy. 
```
./li_add_rule_to_policy --policy-name "Container 5a7b468efb212f000183a174 behavior" --rules-sys-csv rules-with-sys_names.csv --rules-csv-fixed-name 'all added rules have this fixed name'
```
* Remove all rules with a matching name from a policy
```
./li_delete_policy_rule --policy-name "Container 5a7b468efb212f000183a174 behavior" --name 'all added rules have this fixed name'
```
