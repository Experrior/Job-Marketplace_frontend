// export async function handle({ event, resolve }) {
//     const response = await resolve(event, {
//         transformPageChunk: ({ html }) => html.replace(
//             '</head>',
//             `<meta http-equiv="Content-Security-Policy" content="style-src 'self' 'unsafe-inline';"> </head>`
//         )
//     });
//     return response;
// }
