# Proof of Concept: Denial of Service via Aggressive Crawling with wget

## Vulnerability Type
Denial of Service (DoS) / Resource Exhaustion

## Description
A web server can be pushed into a degraded or unstable state when subjected to aggressive crawling activity. In this PoC, the use of wget with recursive mirroring options generates a high volume of requests and asset fetches, which can consume CPU, memory, and connection resources. In a Node.js runtime, this behavior may also increase event loop pressure and reduce the ability of the application to serve legitimate traffic efficiently.

## Impact
- Increased server load and resource consumption
- Slower response times for legitimate users
- Potential partial service disruption under sustained load
- Higher memory and CPU pressure in Node.js-based services
- Reduced application throughput during attack simulation

## PoC
The following command demonstrates the behavior:

```bash
wget --mirror --page-requisites --adjust-extension --convert-links --no-parent -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0" https://target-web.com/
```

## Command Breakdown
- --mirror: enables recursive mirroring behavior
- --page-requisites: downloads supporting assets such as CSS, JavaScript, and images
- --adjust-extension: adjusts file extensions for downloaded content
- --convert-links: rewrites links to match local output
- --no-parent: prevents traversal outside the target scope
- -U: sets a custom User-Agent to mimic a browser client

## Reproduction Steps
1. Ensure wget is installed on the target system.
2. Execute the PoC command against an authorized test target.
3. Monitor CPU usage, memory consumption, and server logs.
4. Observe increased latency or degraded response behavior during execution.

## Automated Execution
```bash
chmod +x poc.sh
./poc.sh https://target-web.com/ ./output
```

## Mitigation
- Apply rate limiting and request throttling
- Use a WAF or reverse proxy to detect and block abusive crawlers
- Enable caching for static assets
- Monitor abnormal traffic patterns in real time
- Restrict unauthorized automated access through firewall policies or allowlists

## Notes
This PoC is intended only for authorized security testing and educational use in controlled environments.