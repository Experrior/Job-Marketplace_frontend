// src/stores/user.js
import { writable } from 'svelte/store';
import { browser } from '$app/environment';

const template = {
  displayName: '',
  photoURL: 'icons/user.svg',
  email: '',
  uid: '',
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

export { user, resetUser };
