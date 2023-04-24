local defaults = {
  local defaults = self,

  name:: error 'must provide name',
  namespace:: error 'must provide namespace',

  commonLabels:: {
    'app.kubernetes.io/name': defaults.name,
    'app.kubernetes.io/component': 'server',
    'app.kubernetes.io/part-of': 'nfs-client',
  },
  path: '/',
  selectorLabels:: {
    [labelName]: defaults.commonLabels[labelName]
    for labelName in std.objectFields(defaults.commonLabels)
    if !std.setMember(labelName, ['app.kubernetes.io/version'])
  },
};

function(params) {
  local this = self,
  _config:: defaults + params,

  _metadata:: {
    labels: this._config.commonLabels,
    name: this._config.name,
    namespace: this._config.namespace,
  },

  deployment: {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: this._metadata,
    spec: {
      replicas: 1,
      strategy: {
        type: 'Recreate',
      },
      selector: {
        matchLabels: this._config.selectorLabels,
      },
      template: {
        metadata: this._metadata,
        spec: {
          serviceAccountName: this._config.name,
          containers: [{
            name: this._config.name,
            image: 'k8s.gcr.io/sig-storage/nfs-subdir-external-provisioner:v4.0.2',
            env: [
              {
                name: 'PROVISIONER_NAME',
                value: 'k8s-sigs.io/nfs-subdir-external-provisioner',
              },
              {
                name: 'NFS_SERVER',
                value: 'nfs-server',
              },
              {
                name: 'NFS_PATH',
                value: this._config.path,
              },
            ],
            volumeMounts: [{
              name: $.deployment.spec.template.spec.volumes[0].name,
              mountPath: '/persistentvolumes',
            }],
          }],
          volumes: [{
            name: 'nfs-client',
            nfs: {
              server: 'nfs-server',
              path: this._config.path,
            },
          }],
        },
      },
    },
  },

  'storeage-class': {
    apiVersion: 'storage.k8s.io/v1',
    kind: 'StorageClass',
    metadata: this._metadata {
      namespace:: null,
      labels:: null,
    },
    provisioner: 'k8s-sigs.io/nfs-subdir-external-provisioner',
    parameters: {
      archiveOnDelete: 'false',
    },
  },
}
