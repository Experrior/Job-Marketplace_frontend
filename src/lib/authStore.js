// src/authStore.js
import { writable } from 'svelte/store';

// Create writable stores for accessToken and refreshToken
export const accessToken = writable(null);
export const refreshToken = writable(null);
