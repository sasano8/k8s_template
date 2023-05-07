from fastapi import FastAPI

from .k8s import watch_events, list_resources

app = FastAPI()

@app.get("/hello")
def hello():
    return {"Hello": "World"}

@app.get("/watch")
def watch():
    watch_events()
    return None


@app.get("/resources")
def query_resources():
    return list_resources()
