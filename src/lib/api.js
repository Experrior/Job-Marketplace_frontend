// src/lib/api.js
import axios from 'axios';

/**
 * Creates an Axios instance with JWT attached to headers if available.
 */
export function createAuthenticatedAxios() {
    const token = localStorage.getItem('jwt');

    const instance = axios.create({
        headers: {
            'Content-Type': 'application/json',
            ...(token && { 'Authorization': `Bearer ${token}` })
        }
    });

    return instance;
}
