FROM python:3

WORKDIR /app
ADD requirements.txt .
RUN pip install -r requirements.txt
ADD stream-stats.py .

ENTRYPOINT [ "/app/stream-stats.py" ]
