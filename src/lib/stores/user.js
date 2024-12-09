// src/stores/user.js
import { writable, get } from 'svelte/store';
import { browser } from '$app/environment';

const template = {
  userId: '',
  displayName: '',
  profilePicture: '',
  profile: '',
  email: '',
  firstName: '',
  lastName: '',
  jwt: '',
  refreshToken: '',
  role: ''
};

// Initialize the writable store with the template
const user = writable(template);

// Only execute the following block in the browser
if (browser) {
  // Attempt to retrieve the user from localStorage
  const storedUser = localStorage.getItem('user');
  if (storedUser) {
    try {
      user.set(JSON.parse(storedUser));
    } catch (e) {
      console.error('Failed to parse user from localStorage:', e);
      // Optionally reset to template if parsing fails
      user.set(template);
      localStorage.removeItem('user');
    }
  }

  // Subscribe to store changes and update localStorage accordingly
  user.subscribe((value) => {
    // Avoid storing empty template to localStorage
    if (value && value.jwt) {
      localStorage.setItem('user', JSON.stringify(value));
    } else {
      localStorage.removeItem('user');
    }
  });
}

// Function to reset the user store to its default template
const resetUser = () => user.set(template);

/**
 * Verifies if the user is authenticated based on the presence of a JWT.
 * 
 * @returns {boolean} - Returns `true` if the user is authenticated, `false` otherwise.
 */
function verifyUser() {
  if (!browser) {
    // During SSR, assume the user is not authenticated
    return false;
  }

  const currentUser = get(user);

  if (!currentUser || !currentUser.jwt) {
    // If no user or JWT is found, reset the store and clear localStorage
    resetUser();
    localStorage.removeItem('user');
    console.warn('User is not logged in. Resetting user store and clearing localStorage.');
    return false;
  }

  // User is authenticated
  return true;
}

export { user, resetUser, verifyUser };
