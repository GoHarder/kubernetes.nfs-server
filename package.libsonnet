{
  values:: {
    common: {
      name: 'nfs-client',
      namespace: 'default',
    },
  },
  'cluster-role-binding': {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRoleBinding',
    metadata: {
      name: $.values.common.name,
    },
    subjects: [
      {
        kind: 'Service-Account',
        name: $['service-account'].metadata.name,
        namespace: $.values.common.namespace,
      },
    ],
    roleRef: {
      kind: 'ClusterRole',
      name: $['cluster-role'].metadata.name,
      apiGroup: 'rbac.authorization.k8s.io',
    },
  },
  'cluster-role': {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    metadata: {
      name: $.values.common.name,
    },
    rules: [
      {
        apiGroups: [''],
        resources: ['nodes'],
        verbs: ['get', 'list', 'watch'],
      },
      {
        apiGroups: [''],
        resources: ['persistentvolumes'],
        verbs: ['get', 'list', 'watch', 'create', 'delete'],
      },
      {
        apiGroups: [''],
        resources: ['persistentvolumeclaims'],
        verbs: ['get', 'list', 'watch', 'update'],
      },
      {
        apiGroups: ['storage.k8s.io'],
        resources: ['storageclasses'],
        verbs: ['get', 'list', 'watch'],
      },
      {
        apiGroups: [''],
        resources: ['events'],
        verbs: ['create', 'update', 'patch'],
      },
    ],
  },
  'role-binding': {},
  role: {},
  'service-account': {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: {
      name: $.values.common.name,
      namespace: $.values.common.namespace,
    },
  },
}
