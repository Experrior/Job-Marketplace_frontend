import { writable } from 'svelte/store';
import { browser } from '$app/environment';

const initialData = {
  jwt: '',
  username: '',
};

const storedData = browser ? JSON.parse(localStorage.getItem('user')) || initialData : initialData;

export const user = writable(storedData);

user.subscribe((value) => {
  if (browser) {
    localStorage.setItem('user', JSON.stringify(value));
  }
});
