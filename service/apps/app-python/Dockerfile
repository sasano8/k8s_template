FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9

RUN pip install fastapi uvicorn kubernetes nats-py[nkeys]


COPY ./ /app

EXPOSE 80
CMD ["uvicorn", "asgi:app", "--host", "0.0.0.0", "--port", "80"]
