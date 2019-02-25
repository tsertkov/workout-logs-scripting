FROM python:3

WORKDIR /app
ADD requirements.txt .
RUN pip install -r requirements.txt
ADD stream-graph.py .

ENTRYPOINT [ "/app/stream-graph.py" ]
