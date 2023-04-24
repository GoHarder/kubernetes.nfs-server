local package = (import './package.libsonnet') + {
  values+:: {
    common+: {
      namespace: 'monitoring',
    },
  },
};

{
  [name]: package[name]
  for name in std.objectFields(package)
}
