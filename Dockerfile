FROM python:3.10-slim-bullseye
ENV PYTHONUNBUFFERED 1
WORKDIR /app
COPY install_packages.sh .
RUN chmod +x ./install_packages.sh && ./install_packages.sh
RUN addgroup --system log_user && adduser --system --group log_user
COPY main.py entrypoint.sh ./
# Don't forget to mount Docker volume to /log when starting container.
RUN chmod +x ./entrypoint.sh && mkdir -p /log && chown log_user /log
USER log_user
ENTRYPOINT ["./entrypoint.sh"]