# Infra

## Via Argo
Argo Bootstrap (braucht repo von git.ctdo.de)
```
cue -t app=infra dump > init.yaml
kubectl apply -f init.yaml
```

1. Argo Bootstrap
2. Argo macht fetch auf infra
3. Argo called `cue argo_apps`
4. Argo findet alle Apps
5. Argo called bei den Apps immer `cue -t app=$APP dump`

---

## Manuell

```
cue dump > all.yaml
kubectl apply -f all.yaml
```