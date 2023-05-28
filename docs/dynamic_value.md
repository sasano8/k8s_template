# valueFrom

動的に変数を設定することができ、次のリソースの値を参照できる。

- configMapKeyRef: ConfigMap の値を参照する
- secretKeyRef: Secret の値を参照する
- fieldRef: Pod自体のフィールドの値を参照する
- resourceFieldRef: コンテナのリソース要求や制限の値を参照する

```
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: my-container
      image: my-image
      env:
        - name: EMAIL
          valueFrom:
            configMapKeyRef:
              name: my-config
              key: email
```

# ConfigMap

Kubernetes における設定値を管理する。


設定値を定義するには

```
kubectl create configmap my-config --from-literal=email=example@example.com
```

または

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  email: example@example.com
```
