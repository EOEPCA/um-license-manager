# Base container
FROM python:3.6

COPY src/requirements.txt /

RUN pip install -r requirements.txt

# Add requirements, code
COPY src/ /

# Declare and expose service listening port
# EXAMPLE PORT - PLEASE REPLACE WITH REAL ONES
EXPOSE 8081/tcp

# Declare entrypoint of that exposed service
ENTRYPOINT ["python3", "./main.py"]