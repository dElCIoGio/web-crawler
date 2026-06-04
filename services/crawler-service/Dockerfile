FROM python:3.12-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY services/crawler-service/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY services/crawler-service/src ./src
COPY services/crawler-service/main.py ./

# INSTALL PACKAGES
ARG OPENAPI_PYTHON_CLIENTS=""

COPY packages/clients/python /opt/generated-clients/python

RUN set -eux; \
    for client in $OPENAPI_PYTHON_CLIENTS; do \
        client_path="/opt/generated-clients/python/${client}-client"; \
        test -d "$client_path"; \
        pip install --no-cache-dir "$client_path"; \
    done

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001"]
