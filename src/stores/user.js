import { writable, get, readable } from 'svelte/store';
import { browser } from '$app/environment';

const template = {
  displayName: '',
  profilePicture: '',
  email: '',
  firstName: '',
  jwt: '',
  refreshToken: '',
  role: 'recruiter'
};

const user = writable(template);

if (browser) {

  const storedUser = localStorage.getItem('user');
  if (storedUser) {
    try {
      user.set(JSON.parse(storedUser));
    } catch (e) {
      console.error('Failed to parse user from localStorage:', e);
    }
  }

  user.subscribe((value) => {
    localStorage.setItem('user', JSON.stringify(value));
  });
}

const resetUser = () => user.set(template);



function verifyUser() {
  // if (!browser) return;

  let currentUser = get(user);

  const userExists = currentUser.jwt;

  if (!userExists) {
    resetUser();
    localStorage.removeItem('user');
    console.warn('User is not logged in. Resetting user store and clearing localStorage.');
    return false;
  }

  return true;
}

export { user, resetUser, verifyUser };
