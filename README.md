# Proof of Concept: Resource Exhaustion via Aggressive Crawling Against Next.js Image Optimization

## Vulnerability Type
Denial of Service (DoS) / Resource Exhaustion

## Description
A web server can be driven into a degraded state when aggressive crawling targets a content-heavy site with many image assets. In this scenario, a crawler such as wget or a custom script recursively accesses multiple pages and requests their images. If the application uses Next.js Image Optimization, each image request may trigger expensive on-demand processing, including resizing, format conversion, and cache population. A single request may be harmless if the response is cached, but a crawl that traverses many pages can force the server to repeatedly process a large number of images, resulting in high memory usage and CPU pressure.

## Impact
- Excessive CPU consumption during image optimization
- High memory usage in the image processing pipeline
- Increased latency for legitimate users
- Reduced throughput on the web server and application runtime
- Potential partial service disruption when many image requests are processed concurrently


## Affected Component
- Web server
- Next.js image optimization pipeline
- Image delivery and caching layer
- affected on the path /_next/images/

## Technical Details
The issue is triggered when a crawler or automated script traverses many content pages that reference multiple images. Each image request may require on-demand optimization, which is memory intensive and CPU intensive. If the cache is not sufficient to absorb the request burst, the server must perform expensive processing for a large number of assets in a short period. This behavior can degrade service quality and increase resource consumption significantly.

## PoC
The following command demonstrates the behavior by recursively crawling a site with many image-rich pages:

```bash
wget --mirror --page-requisites --adjust-extension --convert-links --no-parent -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0" https://target-web.com/
```

A custom script can also be used if the target contains many article pages and image-heavy content. The key idea is that one request to a single page is not enough to trigger a meaningful impact, but a traversal across many pages forces the server to optimize many images repeatedly.

## Why This Matters
If the target site contains many news articles or content pages, each page may include multiple images. When a crawler requests these pages repeatedly, the server must process every image for optimization. This becomes especially costly when the cache is not sufficient to absorb the burst, and the image optimizer must work on a large number of requests in a short time.

## Command Breakdown
- --mirror: enables recursive mirroring behavior
- --page-requisites: downloads supporting assets such as CSS, JavaScript, and images
- --adjust-extension: adjusts file extensions for downloaded content
- --convert-links: rewrites links to match local output
- --no-parent: prevents traversal outside the target scope
- -U: sets a custom User-Agent to mimic a browser client

## Reproduction Steps
1. Select a target site that contains many image-heavy pages.
2. Run the PoC command or a custom crawler against the target.
3. Monitor CPU usage, memory consumption, and server logs during execution.
4. Observe whether the server shows increased latency, slower rendering, higher resource usage when image optimization is triggered repeatedly, or if the web server goes down.

## Automated Execution
```bash
chmod +x poc.sh
./poc.sh https://target-web.com/ ./output
```

## Mitigation
- Apply rate limiting and request throttling
- Use a WAF or reverse proxy to detect abusive crawlers
- Cache optimized image responses aggressively
- Reduce the cost of image optimization for high-volume traffic
- Monitor abnormal request patterns and resource spikes in real time

## Notes
This PoC is intended only for authorized security testing.
