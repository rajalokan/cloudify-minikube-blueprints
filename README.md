# cloudify-playbox-blueprints

To install a single playbox instance run
```
cfy install \
    https://github.com/rajalokan/cloudify-playbox-blueprints/archive/master.zip \
    --blueprint-filename openstack.yaml \
    --blueprint-id playbox \
    --inputs server_name=mininet \
    --inputs flavor=m1.large
```

To install a three instance playbox cluster run
```
cfy install \
    https://github.com/rajalokan/cloudify-playbox-blueprints/archive/master.zip \
    --blueprint-filename openstack.yaml \
    --blueprint-id playbox_cluster \
    --inputs server_name=playbox \
    --inputs resource_count=3
```
