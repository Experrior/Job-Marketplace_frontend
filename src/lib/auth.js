import jwt from 'jsonwebtoken';

/**
 * Verifies a JWT token using the provided secret.
 * @param {string} token - The JWT token to verify.
 * @param {string} secret - The JWT secret key.
 * @returns {object} - The decoded user information.
 * @throws {Error} - If the token is invalid or expired.
 */
export function verifyJWT(token, secret) {
  return jwt.verify(token, secret);
}

/**
 * Generates a JWT token for a given user.
 * @param {object} payload - The payload to encode in the token.
 * @param {string} secret - The JWT secret key.
 * @param {object} options - JWT sign options (e.g., expiresIn).
 * @returns {string} - The signed JWT token.
 */
export function generateJWT(payload, secret, options = {}) {
  return jwt.sign(payload, secret, options);
}
