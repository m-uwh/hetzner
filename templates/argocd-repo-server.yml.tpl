apiVersion: apps/v1
kind: Deployment
metadata:
  name: argocd-repo-server
spec:
  template:
    spec:

      # Mount SA token for Kubernets auth
      # Note: In 2.4.0 onward, there is a dedicated SA for repo-server (not default)
      # Note: This is not fully supported for Kubernetes < v1.19
      automountServiceAccountToken: true

      # Each of the embedded YAMLs inside cmp-plugin ConfigMap will be mounted into it's respective plugin sidecar
      volumes:
        - configMap:
            name: cmp-plugin
          name: cmp-plugin
        - name: custom-tools
          emptyDir: {}

      # Download tools
      initContainers:
      - name: download-tools
        image: registry.access.redhat.com/ubi8
        env:
          - name: AVP_VERSION
            value: 1.11.0
        command: [sh, -c]
        args:
          - >-
            curl -L https://github.com/argoproj-labs/argocd-vault-plugin/releases/download/v$(AVP_VERSION)/argocd-vault-plugin_$(AVP_VERSION)_linux_amd64 -o argocd-vault-plugin &&
            chmod +x argocd-vault-plugin &&
            mv argocd-vault-plugin /custom-tools/
        volumeMounts:
          - mountPath: /custom-tools
            name: custom-tools

      # argocd-vault-plugin with Helm
      containers:
      - name: avp-helm
        command: [/var/run/argocd/argocd-cmp-server]
        image: quay.io/argoproj/argocd:${argocd_version}
        securityContext:
          runAsNonRoot: true
          runAsUser: 999
        volumeMounts:
          - mountPath: /var/run/argocd
            name: var-files
          - mountPath: /home/argocd/cmp-server/plugins
            name: plugins
          - mountPath: /tmp
            name: tmp

          # Register plugins into sidecar
          - mountPath: /home/argocd/cmp-server/config/plugin.yaml
            subPath: avp-helm.yaml
            name: cmp-plugin

          # Important: Mount tools into $PATH
          - name: custom-tools
            subPath: argocd-vault-plugin
            mountPath: /usr/local/bin/argocd-vault-plugin

      # argocd-vault-plugin with Kustomize
      - name: avp-kustomize
        command: [/var/run/argocd/argocd-cmp-server]
        image: quay.io/argoproj/argocd:${argocd_version}
        securityContext:
          runAsNonRoot: true
          runAsUser: 999
        volumeMounts:
          - mountPath: /var/run/argocd
            name: var-files
          - mountPath: /home/argocd/cmp-server/plugins
            name: plugins
          - mountPath: /tmp
            name: tmp

          # Register plugins into sidecar
          - mountPath: /home/argocd/cmp-server/config/plugin.yaml
            subPath: avp-kustomize.yaml
            name: cmp-plugin

          # Important: Mount tools into $PATH
          - name: custom-tools
            subPath: argocd-vault-plugin
            mountPath: /usr/local/bin/argocd-vault-plugin

      # argocd-vault-plugin with plain YAML
      - name: avp
        command: [/var/run/argocd/argocd-cmp-server]
        image: quay.io/argoproj/argocd:${argocd_version}
        securityContext:
          runAsNonRoot: true
          runAsUser: 999
        volumeMounts:
          - mountPath: /var/run/argocd
            name: var-files
          - mountPath: /home/argocd/cmp-server/plugins
            name: plugins
          - mountPath: /tmp
            name: tmp

          # Register plugins into sidecar
          - mountPath: /home/argocd/cmp-server/config/plugin.yaml
            subPath: avp.yaml
            name: cmp-plugin

          # Important: Mount tools into $PATH
          - name: custom-tools
            subPath: argocd-vault-plugin
            mountPath: /usr/local/bin/argocd-vault-plugin