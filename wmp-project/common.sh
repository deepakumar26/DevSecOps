set_permissions() {
  chown -R appuser:appuser /app
  chmod o-rwx /app -R
}

start_service() {
  local service_name=$1
  systemctl daemon-reload
  systemctl enable ${service_name}
  systemctl start ${service_name}
}