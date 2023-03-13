# build stage
FROM python:3.10-slim-bullseye AS builder
LABEL stage=log_receiver_builder
WORKDIR /app
RUN pip install --upgrade pip && pip wheel --no-cache-dir --no-deps --wheel-dir /wheels

# work stage
FROM python:3.10-slim-bullseye
ENV PYTHONUNBUFFERED 1
WORKDIR /app
COPY --from=builder /wheels /wheels
COPY install_packages.sh .
RUN chmod +x ./install_packages.sh && ./install_packages.sh && pip install --no-cache /wheels/* && rm -Rfv /wheels
RUN addgroup --system log_user && adduser --system --group log_user
COPY main.py entrypoint.sh ./
# Don't forget to mount Docker volume for saving logs to /log when starting container.
RUN chmod +x ./entrypoint.sh && mkdir -p /log && chown api_user /log
USER log_user
ENTRYPOINT ["./entrypoint.sh"]