// src/routes/data/+server.js
export async function GET() {
    const apiUrl = process.env.VITE_GATEWAY_URL; // e.g. "http://your-endpoint-ip:port"
  
    // You can now use apiUrl in your server requests
    const response = await fetch(`${apiUrl}/some/endpoint`);
    const data = await response.json();
  
    return new Response(JSON.stringify(data), { headers: { 'Content-Type': 'application/json' } });
  }
  