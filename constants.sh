readonly INGRESS=true
readonly DASHBOARD=true
readonly PROMETHEUS=true

readonly K8S_DASHBOARD_URL="http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:dashboard-kubernetes-dashboard:https/proxy/#/login"
readonly K8S_DASHBOARD_NAMESPACE="kubernetes-dashboard"

readonly PROMETHEUS_DASHBOARD_URL="http://localhost:9090/targets"
readonly PROMETHEUS_NAMESPACE="monitoring"

readonly TIMEOUT_READINESS="1h"