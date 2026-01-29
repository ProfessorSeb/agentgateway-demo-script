# 🛠️ AgentGateway Enterprise Demo - Setup Guide

## Prerequisites

### 1. Kubernetes Cluster
- Kubernetes 1.28+ recommended
- `kubectl` configured with cluster access
- Helm 3.x installed

### 2. AgentGateway Installation

```bash
# Add Solo.io Helm repo
helm repo add solo-io https://storage.googleapis.com/solo-io-enterprise-artifacts
helm repo update

# Install AgentGateway (Enterprise)
helm install agentgateway solo-io/agentgateway \
  --namespace agentgateway-system \
  --create-namespace \
  --set license.key=$AGENTGATEWAY_LICENSE
```

### 3. Configure AI Provider Backends

You need to create AgentgatewayBackend resources for each AI provider:

```yaml
# Example: Anthropic Backend
apiVersion: agentgateway.dev/v1alpha1
kind: AgentgatewayBackend
metadata:
  name: anthropic
  namespace: agentgateway-system
spec:
  type: ai
  ai:
    anthropic:
      authToken:
        secretRef:
          name: anthropic-api-key
          key: api-key
---
# Secret for Anthropic API key
apiVersion: v1
kind: Secret
metadata:
  name: anthropic-api-key
  namespace: agentgateway-system
type: Opaque
stringData:
  api-key: "sk-ant-your-api-key-here"
```

Repeat for OpenAI and xAI backends.

## 🚀 Deploy the Demo

### Step 1: Clone/Download Demo Files
```bash
cd ~/Documents/agentgateway-enterprise-demo
```

### Step 2: Deploy Gateway and Route
```bash
kubectl apply -f manifests/01-gateway.yaml
```

### Step 3: Patch Service to NodePort (for easy access)
```bash
kubectl patch svc multi-llm-gateway -n agentgateway-system \
  -p '{"spec": {"type": "NodePort", "ports": [{"port": 8090, "targetPort": 8090, "nodePort": 30890}]}}'
```

### Step 4: Deploy All Policies
```bash
kubectl apply -f manifests/
```

### Step 5: Verify Deployment
```bash
# Check gateway
kubectl get gateway -n agentgateway-system

# Check policies
kubectl get agentgatewaypolicies -n agentgateway-system -l demo=agentgateway

# Get node IP
kubectl get nodes -o wide
```

## 🧪 Test the Gateway

### Find Gateway Endpoint
```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
GATEWAY="http://${NODE_IP}:30890"
echo "Gateway: $GATEWAY"
```

### Test Anthropic
```bash
curl -X POST "$GATEWAY/anthropic/v1/messages" \
  -H "Content-Type: application/json" \
  -H "x-api-key: demo" \
  -H "anthropic-version: 2023-06-01" \
  -d '{"model":"claude-sonnet-4-20250514","max_tokens":100,"messages":[{"role":"user","content":"Hello!"}]}'
```

### Test OpenAI
```bash
curl -X POST "$GATEWAY/openai/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer demo" \
  -d '{"model":"gpt-4o","max_tokens":100,"messages":[{"role":"user","content":"Hello!"}]}'
```

## 🎬 Run the Demo Script

```bash
chmod +x scripts/agentgateway-demo.sh
./scripts/agentgateway-demo.sh
```

## 🧹 Cleanup

```bash
# Remove all demo resources
kubectl delete -f manifests/

# Or remove specific categories
kubectl delete agentgatewaypolicies -n agentgateway-system -l demo=agentgateway
kubectl delete gateway multi-llm-gateway -n agentgateway-system
kubectl delete httproute multi-llm-route -n agentgateway-system
```

## 📊 Monitoring

### View Policy Status
```bash
kubectl get agentgatewaypolicies -n agentgateway-system -l demo=agentgateway
```

### View Gateway Logs
```bash
kubectl logs -n agentgateway-system deployment/multi-llm-gateway -f
```

### View Request Metrics
```bash
kubectl logs -n agentgateway-system deployment/multi-llm-gateway | grep "gen_ai.usage"
```

## 🔧 Customization

### Adjust Rate Limits
Edit `manifests/02-rate-limiting.yaml`:
- Change `requests: 10` to your desired requests/minute
- Change `tokens: 50000` to your desired tokens/hour

### Add Custom Prompt Guards
Edit `manifests/04-jailbreak-prevention.yaml`:
- Add new regex patterns to the `matches` array

### Modify Elicitation Prompts
Edit `manifests/08-elicitation.yaml`:
- Customize system prompts in the `prepend` sections
- Add domain-specific personas

## 📚 Resources

- [AgentGateway Documentation](https://docs.solo.io/agentgateway)
- [Solo.io](https://solo.io)
- [Gateway API Spec](https://gateway-api.sigs.k8s.io/)
