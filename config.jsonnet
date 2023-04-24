local package = (import './package.libsonnet') + {
  values+:: {
    common+: {
      namespace: 'nfs-client',
    },
  },
};

{ ['setup/' + name]: package.rbac[name] for name in std.objectFields(package.rbac) } +
{ [name]: package.provisioner[name] for name in std.objectFields(package.provisioner) }
