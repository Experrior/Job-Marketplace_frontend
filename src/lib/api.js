// src/lib/api.js

import axios from 'axios';
import { get } from 'svelte/store';
import user from '$lib/stores/user'; // Adjust the path as necessary

// Centralized Gateway URL
// Option 1: Using Environment Variables
const gateway = import.meta.env.VITE_GATEWAY_URL || 'http://localhost:8080';

// Option 2: Hardcoded (Less Flexible)
// const gateway = 'http://localhost:8080';

/**
 * Creates a singleton Axios instance with default configurations.
 * Includes the base URL and sets up authorization headers.
 */
const apiInstance = axios.create({
    baseURL: gateway,
    headers: {
        'Content-Type': 'application/json',
    },
});

/**
 * Interceptor to attach the Authorization header to each request if the user is authenticated.
 */
apiInstance.interceptors.request.use(
    (config) => {
        const currentUser = get(user);
        if (currentUser && currentUser.jwt) {
            config.headers['Authorization'] = `Bearer ${currentUser.jwt}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

/**
 * Generic request function to interact with the API.
 *
 * @param {string} method - HTTP method ('get', 'post', 'put', 'delete', etc.).
 * @param {string} endpoint - API endpoint (relative to the base URL).
 * @param {object} [data] - Request payload for methods like POST and PUT.
 * @param {object} [params] - URL query parameters.
 * @param {object} [headers] - Additional headers.
 * @returns {Promise} - Resolves with the response data or rejects with an error.
 */
export async function request(method, endpoint, data = {}, params = {}, headers = {}) {
    try {
        const response = await apiInstance.request({
            method,
            url: endpoint,
            data,
            params,
            headers,
        });
        return response.data;
    } catch (error) {
        // Optional: Enhance error handling here
        console.error(`API request error [${method.toUpperCase()} ${endpoint}]:`, error);
        throw error;
    }
}

/**
 * Convenience functions for common HTTP methods.
 */

export function getRequest(endpoint, params = {}, headers = {}) {
    return request('get', endpoint, null, params, headers);
}

export function postRequest(endpoint, data = {}, headers = {}) {
    return request('post', endpoint, data, null, headers);
}

export function putRequest(endpoint, data = {}, headers = {}) {
    return request('put', endpoint, data, null, headers);
}

export function deleteRequest(endpoint, data = {}, headers = {}) {
    return request('delete', endpoint, data, null, headers);
}

/**
 * Example of the existing createAuthenticatedAxios function can be removed
 * since we're using a singleton instance with interceptors.
 *
 * If you still need it for specific use cases, you can adjust accordingly.
 */
