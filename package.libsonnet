local provisioner = import './components/provisioner.libsonnet';
local rbac = import './components/rbac.libsonnet';

{
  values:: {
    common: {
      name: 'nfs-client',
      namespace: 'default',
    },
    provisioner: {
      name: $.values.common.name,
      namespace: $.values.common.namespace,
    },
    rbac: {
      name: $.values.common.name,
      namespace: $.values.common.namespace,
    },
  },
  provisioner: provisioner($.values.provisioner),
  rbac: rbac($.values.rbac),
}
