from kubernetes import client, config, watch


def load_config():
    if "in_cluster":
        config.load_incluster_config()
    else:
        config.load_kube_config()
        
def get_client():
    load_config()
    return client.CoreV1Api()


def list_resources():
    load_config()
    v1 = client.CoreV1Api()
    ret = v1.list_pod_for_all_namespaces(watch=False)
    # for i in ret.items:
    #     print("%s\t%s\t%s" % (i.status.pod_ip, i.metadata.namespace, i.metadata.name))
    return [{"ns": i.metadata.namespace, "name": i.metadata.name} for i in ret.items]

def watch_events():
    # Watchオブジェクトを作成
    watcher = watch.Watch()
    
    # クライアントを作成
    api_client = client.CoreV1Api()

    # すべての名前空間のイベントをストリーム
    # ストリームはHTTP long-pollingで実装されている。（HTTP接続したまま。一定時間経つと接続し直す）
    for event in watcher.stream(api_client.list_event_for_all_namespaces):
        print("Event: {} {} {} {}".format(event['type'], event['object'].kind, event['object'].metadata.name, event['object'].reason))
        

# if __name__ == "__main__":
#     load_config()
#     watch_events()
