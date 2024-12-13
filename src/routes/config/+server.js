export async function GET() {
    return new Response(JSON.stringify({ apiGateway: process.env.VITE_GATEWAY_URL }), {
      headers: { 'Content-Type': 'application/json' }
    });
  }
  