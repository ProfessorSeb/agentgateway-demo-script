#!/bin/bash
#
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║        🔧🛡️ MCP Security Demo - AgentGateway Enterprise 🛡️🔧              ║
# ║              Secure AI Tool Access with MCP Policies                       ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

# Gateway endpoint for MCP
MCP_GATEWAY="http://172.16.10.161:30799"

print_header() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}${BOLD}  $1${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${YELLOW}┌─────────────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${YELLOW}│${NC} ${WHITE}$1${NC}"
    echo -e "${YELLOW}└─────────────────────────────────────────────────────────────────────────┘${NC}"
}

print_problem() {
    echo -e "${RED}${BOLD}🚨 PROBLEM:${NC} $1"
}

print_solution() {
    echo -e "${GREEN}${BOLD}✨ SOLUTION:${NC} $1"
}

print_info() {
    echo -e "${BLUE}💡 $1${NC}"
}

wait_for_key() {
    echo ""
    echo -e "${YELLOW}👆 Press any key to continue...${NC}"
    read -n 1 -s
}

# Demo intro
clear
print_header "🔧🛡️ MCP Security Demo - AgentGateway Enterprise"

echo -e "${WHITE}MCP (Model Context Protocol) allows AI agents to use external tools.${NC}"
echo -e "${WHITE}This demo shows how AgentGateway secures MCP tool access.${NC}"
echo ""
echo -e "  ${CYAN}🔧${NC} MCP Endpoints Configured:"
echo -e "      • ${GREEN}/mcp/github${NC}    → GitHub operations"
echo -e "      • ${GREEN}/mcp/fortigate${NC} → Network security (Fortigate)"
echo -e "      • ${GREEN}/mcp/solo-docs${NC} → Documentation search"
echo ""
echo -e "${WHITE}🌐 MCP Gateway:${NC} ${CYAN}$MCP_GATEWAY${NC}"
echo ""
wait_for_key

# ═══════════════════════════════════════════════════════════════════════════
# DEMO 1: MCP Overview
# ═══════════════════════════════════════════════════════════════════════════
clear
print_header "🔧 Demo 1: What is MCP?"

print_section "📖 Model Context Protocol (MCP)"
echo ""
echo -e "  ${WHITE}MCP is a standard protocol for AI agents to:${NC}"
echo -e "    ${GREEN}•${NC} 🔍 Discover available tools"
echo -e "    ${GREEN}•${NC} 📞 Call tools with parameters"
echo -e "    ${GREEN}•${NC} 📊 Receive structured responses"
echo ""
echo -e "  ${WHITE}Example MCP tools:${NC}"
echo -e "    ${CYAN}•${NC} get_repository - Fetch repo details from GitHub"
echo -e "    ${CYAN}•${NC} search_issues - Search GitHub issues"
echo -e "    ${CYAN}•${NC} get_firewall_rules - Read Fortigate rules"
echo -e "    ${CYAN}•${NC} delete_firewall_rule - ⚠️ DANGEROUS operation"
echo ""

print_problem "Without controls, AI agents could call ANY tool - including destructive ones! 😱"
echo ""
print_solution "AgentGateway applies authorization policies to MCP tools using CEL expressions 🛡️"

wait_for_key

# ═══════════════════════════════════════════════════════════════════════════
# DEMO 2: List Available Tools
# ═══════════════════════════════════════════════════════════════════════════
clear
print_header "🔍 Demo 2: Listing MCP Tools"

print_info "Calling tools/list on GitHub MCP server..."
echo ""
echo -e "${CYAN}📤 REQUEST:${NC}"
echo 'POST /mcp/github'
echo '{"jsonrpc":"2.0","method":"tools/list","id":1}'
echo ""
echo -e "${GREEN}📥 RESPONSE:${NC}"
curl -s -X POST "$MCP_GATEWAY/mcp/github" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","method":"tools/list","id":1}' 2>&1 | sed 's/^data: //' | jq -r '.result.tools[]?.name // "No tools returned (auth may be filtering)"' 2>/dev/null || echo "(Response received)"

echo ""
echo -e "${GREEN}${BOLD}🔍 Result:${NC} Tool list returned - policies may filter which tools are visible!"

wait_for_key

# ═══════════════════════════════════════════════════════════════════════════
# DEMO 3: MCP Authorization Policies
# ═══════════════════════════════════════════════════════════════════════════
clear
print_header "🛡️ Demo 3: MCP Authorization Policies"

print_section "📋 Active MCP Security Policies"
echo ""
kubectl get agentgatewaypolicies -n agentgateway-system -l category=mcp-security 2>/dev/null || echo "(kubectl not available)"
echo ""

print_section "🔐 Policy Details"
echo ""
echo -e "  ${GREEN}23-mcp-github-allow-read-tools${NC}"
echo -e "     ✅ Allows: get_*, list_*, search_*"
echo -e "     ❌ Blocks: create_*, delete_*, update_*"
echo ""
echo -e "  ${GREEN}24-mcp-fortigate-block-dangerous${NC}"
echo -e "     ❌ Blocks: delete, reset, reboot, shutdown"
echo -e "     ✅ Allows: All other operations"
echo ""
echo -e "  ${GREEN}25-mcp-route-rate-limit${NC}"
echo -e "     ⏱️ 30 requests/minute with burst of 10"
echo ""
echo -e "  ${GREEN}26-mcp-route-timeout${NC}"
echo -e "     ⏱️ 60 second timeout for tool calls"

wait_for_key

# ═══════════════════════════════════════════════════════════════════════════
# DEMO 4: CEL Expressions
# ═══════════════════════════════════════════════════════════════════════════
clear
print_header "📝 Demo 4: CEL-Based Tool Authorization"

print_section "🧮 Common Expression Language (CEL)"
echo ""
echo -e "  ${WHITE}AgentGateway uses CEL to define tool access rules:${NC}"
echo ""
echo -e "  ${CYAN}Allow read-only GitHub tools:${NC}"
echo -e "  ${WHITE}tool.name.startsWith('get_') || tool.name.startsWith('list_')${NC}"
echo ""
echo -e "  ${CYAN}Block destructive Fortigate tools:${NC}"
echo -e "  ${WHITE}tool.name.contains('delete') || tool.name.contains('reboot')${NC}"
echo ""
echo -e "  ${CYAN}Allow tools only for specific users:${NC}"
echo -e "  ${WHITE}claims.role == 'admin' && tool.name.startsWith('admin_')${NC}"
echo ""
echo -e "  ${CYAN}Block tools with dangerous parameters:${NC}"
echo -e "  ${WHITE}!tool.parameters.contains('force=true')${NC}"
echo ""

print_info "CEL gives you fine-grained control over which tools AI agents can use! 🎯"

wait_for_key

# ═══════════════════════════════════════════════════════════════════════════
# Summary
# ═══════════════════════════════════════════════════════════════════════════
clear
print_header "🎯 MCP Security Demo Summary 🏆"

echo -e "${WHITE}${BOLD}✨ What We Covered:${NC}"
echo ""
echo -e "  ${GREEN}✅${NC} ${BOLD}🔧 MCP Overview${NC}"
echo -e "     AI agents use MCP to discover and call external tools"
echo ""
echo -e "  ${GREEN}✅${NC} ${BOLD}🛡️ Tool Authorization${NC}"
echo -e "     CEL expressions control which tools are accessible"
echo ""
echo -e "  ${GREEN}✅${NC} ${BOLD}🚫 Dangerous Tool Blocking${NC}"
echo -e "     Block destructive operations (delete, reboot, etc.)"
echo ""
echo -e "  ${GREEN}✅${NC} ${BOLD}⏱️ Rate Limiting${NC}"
echo -e "     Prevent tool abuse with request limits"
echo ""
echo -e "  ${GREEN}✅${NC} ${BOLD}📊 Fine-Grained Control${NC}"
echo -e "     User/role-based access, parameter filtering"
echo ""

print_section "🔧 MCP Endpoints"
echo -e "  ${CYAN}$MCP_GATEWAY/mcp/github${NC}    - GitHub tools"
echo -e "  ${CYAN}$MCP_GATEWAY/mcp/fortigate${NC} - Fortigate tools"
echo -e "  ${CYAN}$MCP_GATEWAY/mcp/solo-docs${NC} - Documentation tools"
echo ""

echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}🙏 MCP Security Demo Complete! 🚀${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════════════════${NC}"
echo ""
