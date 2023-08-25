FROM python:3.9
RUN addgroup --system --gid 2002 admin && \
    adduser --system --uid 1001 admin
WORKDIR /app/backend

COPY requirements.txt /app/backend

RUN pip install -r requirements.txt

RUN chown admin:admin -R /app/backend
USER admin

COPY . /app/backend

EXPOSE 8000

CMD python /app/backend/manage.py runserver 0.0.0.0:8000
