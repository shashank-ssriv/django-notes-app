FROM python:3.9
RUN addgroup --system --gid 2002 admin && \
    adduser --system --uid 1001 admin
WORKDIR /app/backend

COPY requirements.txt /app/backend
RUN chown admin:admin -R /app/backend
USER admin
RUN pip install -r requirements.txt

COPY . /app/backend

EXPOSE 8000

CMD python /app/backend/manage.py runserver 0.0.0.0:8000
