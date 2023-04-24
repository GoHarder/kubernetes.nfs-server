local defaults = {
  local defaults = self,

  name:: error 'must provide name',
  namespace:: error 'must provide namespace',
};

function(params) {
  local this = self,
  _config:: defaults + params,

  _metadata:: {
    name: this._config.name,
    namespace: this._config.namespace,
  },

  'cluster-role-binding': {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRoleBinding',
    metadata: this._metadata {
      namespace:: null,
    },
    subjects: [
      {
        kind: 'Service-Account',
        name: this['service-account'].metadata.name,
        namespace: this._metadata.namespace,
      },
    ],
    roleRef: {
      kind: 'ClusterRole',
      name: this['cluster-role'].metadata.name,
      apiGroup: 'rbac.authorization.k8s.io',
    },
  },

  'cluster-role': {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    metadata: this._metadata {
      namespace:: null,
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

  'role-binding': {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRoleBinding',
    metadata: this._metadata,
    subjects: [
      {
        kind: 'ServiceAccount',
        name: this['service-account'].metadata.name,
        namespace: this._config.namespace,
      },
    ],
    roleRef: {
      kind: 'Role',
      name: this.role.metadata.name,
      apiGroup: 'rbac.authorization.k8s.io',
    },
  },

  role: {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'Role',
    metadata: this._metadata,
    rules: [
      {
        apiGroups: [''],
        resources: ['endpoints'],
        verbs: ['get', 'list', 'watch', 'create', 'update', 'patch'],
      },
    ],
  },

  'service-account': {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: this._metadata,
  },
}
