FROM python:3

WORKDIR /app
ADD requirements.txt .
RUN pip install -r requirements.txt
ADD emit-logs.py .

ENTRYPOINT [ "/app/emit-logs.py" ]
