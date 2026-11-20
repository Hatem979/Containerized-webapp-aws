
# =========================
# Stage 1: Builder
# =========================

FROM python:3.12-slim AS builder

WORKDIR /app

RUN python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt


# =========================
# Stage 2: Runtime
# =========================

FROM python:3.12-slim AS runtime

WORKDIR /app

RUN groupadd --system appgroup && \
    useradd --system \
    --gid appgroup \
    --home-dir /app \
    --shell /usr/sbin/nologin \
    appuser

COPY --from=builder /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY --chown=appuser:appgroup app.py .
COPY --chown=appuser:appgroup migrations/ ./migrations/

USER appuser

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--threads", "2", "--timeout", "60", "--worker-tmp-dir", "/tmp", "--no-control-socket", "app:app"]