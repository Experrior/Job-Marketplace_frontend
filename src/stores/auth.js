import { writable } from 'svelte/store';


const defaultSettings = {
  darkMode: false,
  notifications: true,
  autoUpdate: false,
  soundEffects: true,
  language: 'en', // Additional setting example
  // Add more settings as needed
};

// Initialize the settings store with default values
export const settings = writable(defaultSettings);
function createAuthStore() {
  const { subscribe, set, update } = writable({
    token: null,
    user: null,
    role: null,
    userId: null,
  });

  return {
    subscribe,
    setToken: (token) => {
      update((auth) => ({ ...auth, token }));
    },
    setUser: (user) => {
      update((auth) => ({ ...auth, user }));
    },
    setUserId: (userId) => {
      update((auth) => ({ ...auth, userId }));
    },
    setRole: (role) => {
        update((auth) => ({ ...auth, role }));
      },
    clearAuth: () => {
      set({ token: null, user: null, role:null });
    }
  };
}

export const auth = createAuthStore();
