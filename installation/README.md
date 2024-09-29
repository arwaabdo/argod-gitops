# argod-gitops
## installation

```bash
helm install argo-cd argo/argo-cd -f value.yml
```

- edit the argocd admin pass by editing the secret named `argocd-secret`
- add the `--insecure` flag to the argocd args 
