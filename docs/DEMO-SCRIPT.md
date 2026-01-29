# 🎤 AgentGateway Enterprise Demo - Voice Script

*Read this script while running the interactive demo. Pause at each section for the demo to execute.*

---

## 🎬 INTRO (Before starting the demo)

> "Hey everyone, today I'm going to walk you through Solo.io's AgentGateway - an enterprise AI gateway that solves critical challenges when deploying AI in production.
>
> As organizations adopt AI, they face serious challenges: How do you route to multiple AI providers? How do you prevent sensitive data from leaking? How do you stop prompt injection attacks? And how do you control costs?
>
> AgentGateway solves all of this at the infrastructure layer - no code changes required.
>
> Let me show you."

*[Press any key to start Demo 1]*

---

## 🔀 DEMO 1: Multi-Provider Routing

> "First up - multi-provider routing.
>
> Most enterprises don't use just one AI provider. They use Anthropic for some use cases, OpenAI for others, maybe Grok for specific workloads.
>
> The problem? Each provider has different APIs, different authentication, different formats. It's a mess to manage.
>
> AgentGateway gives you a single unified endpoint. You just change the path - slash anthropic for Claude, slash openai for GPT, slash xai for Grok.
>
> Watch - I'm sending a request to Claude through the gateway..."

*[Wait for response]*

> "Boom. Single gateway, multiple providers. Your developers don't need to worry about provider-specific code."

*[Press any key]*

---

## 💬 DEMO 2: Prompt Elicitation

> "This next one is really powerful - prompt elicitation, or what I call automatic context enrichment.
>
> Here's the problem: Every team needs to add security context, compliance rules, or expert personas to their prompts. Usually that means every developer has to remember to add it, or you build it into your application code.
>
> With AgentGateway, we inject this automatically at the gateway level. No code changes.
>
> We've configured five elicitation policies: security context, compliance rules, a Kubernetes expert persona, chain-of-thought reasoning, and formatting guidelines.
>
> Watch what happens when I ask a simple Kubernetes question..."

*[Wait for response]*

> "Notice how the response includes step-by-step reasoning, expert-level detail, and proper formatting - all automatically injected. The user just asked a simple question, but the gateway enriched it with expert context."

*[Press any key]*

---

## 🛡️ DEMO 3: Security Context

> "Now let's test those security guardrails.
>
> The problem: LLMs can be tricked into providing harmful content if you don't have proper controls.
>
> Our security context policy automatically instructs the model to decline harmful requests - things like hacking tutorials, malicious code, illegal activities.
>
> Let me try asking something I shouldn't..."

*[Wait for response]*

> "Perfect. The request was declined, with an explanation of why it's harmful and suggestions for legitimate alternatives. That security context was injected automatically by the gateway."

*[Press any key]*

---

## 🔐 DEMO 4: PII Protection

> "Here's a big one for compliance - PII data protection.
>
> Developers accidentally paste sensitive data into prompts all the time. Social security numbers, credit cards, phone numbers - this data then gets sent to external AI providers.
>
> AgentGateway detects these patterns and blocks them BEFORE they leave your network.
>
> We're protecting SSNs, credit cards, phone numbers, and Canadian SINs.
>
> Let me try sending a credit card number..."

*[Wait for response]*

> "The gateway caught it. That credit card never left our network. Never reached the AI provider. That's compliance at the infrastructure layer."

*[Press any key]*

---

## 🛡️ DEMO 5: Prompt Injection Prevention

> "Now for security teams - prompt injection prevention.
>
> Prompt injection is when attackers try to manipulate AI systems by embedding malicious instructions. Classic examples are 'ignore previous instructions' or 'DAN mode' jailbreaks.
>
> AgentGateway has regex patterns that detect these attack vectors and block them.
>
> Let me try a classic jailbreak..."

*[Wait for response]*

> "Caught and handled. Either blocked at the gateway, or the enriched security context helped the model recognize the attack.
>
> This protects your AI systems from adversarial users trying to bypass safety controls."

*[Press any key]*

---

## 🔑 DEMO 6: Credential Protection

> "This one's for security and DevOps teams - credential leak protection.
>
> Developers copy-paste code into AI prompts all the time. Sometimes that code contains API keys, tokens, secrets.
>
> AgentGateway detects patterns for OpenAI keys, GitHub tokens, Slack tokens, and blocks them from being sent to external providers.
>
> Let me try sending an OpenAI API key pattern..."

*[Wait for response]*

> "Blocked. That API key never left our infrastructure. We're protecting developers from accidentally exposing credentials."

*[Press any key]*

---

## ⏱️ DEMO 7: Rate Limiting

> "Finally - cost control with rate limiting.
>
> Without rate limits, a single runaway script or malicious user can burn through your entire AI budget in hours.
>
> AgentGateway provides TWO types of rate limiting:
>
> First, request-based - we're limiting to 10 requests per minute with a burst of 5.
>
> Second, and this is unique - token-based rate limiting. We're limiting to 50,000 tokens per hour. This directly controls your LLM costs.
>
> Together, these prevent both API abuse and runaway token consumption."

*[Press any key]*

---

## 🎯 SUMMARY

> "So let's recap what we just saw:
>
> ✅ Multi-provider routing - one gateway for Anthropic, OpenAI, and xAI
>
> ✅ Prompt elicitation - automatic context enrichment without code changes
>
> ✅ Security guardrails - built-in protection against harmful requests
>
> ✅ PII protection - block sensitive data before it leaves your network
>
> ✅ Prompt injection prevention - stop jailbreaks and manipulation
>
> ✅ Credential protection - prevent API key leaks
>
> ✅ Rate limiting - control costs with request and token limits
>
> All of this is configured with simple Kubernetes policies. No application code changes. Deploy it once, protect everything.
>
> We have 21 policies running on this gateway right now, and adding more is just another YAML file.
>
> That's AgentGateway - enterprise AI security at the infrastructure layer.
>
> Questions?"

---

## 📝 QUICK REFERENCE

**Gateway Endpoint:** `http://172.16.10.162:30890`

**Paths:**
- `/anthropic` → Claude
- `/openai` → GPT
- `/xai` or `/grok` → Grok

**Policy Count:** 21 active policies

**Categories:**
- Rate Limiting (2)
- PII Protection (4)
- Jailbreak Prevention (3)
- Credential Protection (3)
- Response Filtering (2)
- Reliability (2)
- Elicitation (5)

---

## 💡 TIPS FOR PRESENTING

1. **Pause after each demo** - Let the response fully display before speaking
2. **Point at the screen** - Highlight the relevant parts of each response
3. **Emphasize "no code changes"** - This is a key differentiator
4. **Use the problems** - Each demo solves a real pain point
5. **End with questions** - Engage the audience

---

*Script version: 1.0 | Last updated: 2026-01-28*
