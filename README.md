# 🚀 AgentGateway Enterprise Demo

This demo showcases Solo.io's AgentGateway enterprise AI gateway capabilities including multi-provider routing, rate limiting, PII protection, prompt injection prevention, and prompt elicitation.

## 📁 Folder Structure

```
agentgateway-enterprise-demo/
├── README.md                    # This file
├── manifests/
│   ├── 01-gateway.yaml          # Gateway and HTTPRoute definitions
│   ├── 02-rate-limiting.yaml    # Rate limiting policies
│   ├── 03-pii-protection.yaml   # PII detection and blocking
│   ├── 04-jailbreak-prevention.yaml  # Prompt injection blocking
│   ├── 05-credential-protection.yaml # API key leak prevention
│   ├── 06-response-filtering.yaml    # Response masking
│   ├── 07-reliability.yaml      # Timeouts and CORS
│   └── 08-elicitation.yaml      # Prompt enrichment policies
├── scripts/
│   └── agentgateway-demo.sh     # Interactive demo script
└── docs/
    └── SETUP.md                 # Setup instructions
```

## 🚀 Quick Start

### Prerequisites
- Kubernetes cluster with AgentGateway installed
- `kubectl` configured with cluster access
- AgentGateway backends configured (anthropic, openai, xai)

### Deploy All Policies
```bash
kubectl apply -f manifests/
```

### Run Interactive Demo
```bash
./scripts/agentgateway-demo.sh
```

## 🎯 Demo Capabilities

| Category | Policy | Description |
|----------|--------|-------------|
| 🔀 Routing | multi-llm-gateway | Unified routing to Anthropic, OpenAI, xAI |
| ⏱️ Rate Limiting | request-rate-limiter | 10 requests/min with burst |
| ⏱️ Rate Limiting | token-usage-limiter | 50k tokens/hour |
| 🔐 PII Protection | block-ssn-numbers | Block Social Security Numbers |
| 🔐 PII Protection | block-credit-cards | Block credit card numbers |
| 🔐 PII Protection | block-phone-numbers | Block phone numbers |
| 🔐 PII Protection | block-canadian-sin | Block Canadian SIN |
| 🛡️ Security | block-jailbreak-* | Block prompt injection attempts |
| 🔑 Credentials | block-openai-api-keys | Block leaked API keys |
| 🔑 Credentials | block-github-tokens | Block GitHub PATs |
| 🔑 Credentials | block-slack-tokens | Block Slack tokens |
| 📝 Elicitation | elicit-security-context | Auto-add security rules |
| 📝 Elicitation | elicit-k8s-devops-expert | Auto-add expert persona |
| 📝 Elicitation | elicit-chain-of-thought | Auto-add reasoning prompts |

## 🌐 Gateway Endpoints

After deployment, the gateway is available at:

- **NodePort**: `http://<node-ip>:30890`
- **Paths**:
  - `/anthropic` → Claude (Anthropic)
  - `/openai` → GPT (OpenAI)
  - `/xai` → Grok (xAI)
  - `/grok` → Grok (alias)

## 📊 Verify Deployment

```bash
# Check gateway
kubectl get gateway -n agentgateway-system

# Check policies
kubectl get agentgatewaypolicies -n agentgateway-system -l demo=agentgateway

# Check service
kubectl get svc multi-llm-gateway -n agentgateway-system
```

## 🧹 Cleanup

```bash
kubectl delete -f manifests/
```

## 📚 Resources

- [AgentGateway Docs](https://docs.solo.io/agentgateway)
- [Solo.io](https://solo.io)
