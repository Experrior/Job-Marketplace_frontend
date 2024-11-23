export const isBrowser = typeof window !== 'undefined';

export const localStorageStore = (key, initialValue) => {
  const storedValue = isBrowser ? localStorage.getItem(key) : null;
  const data = storedValue ? JSON.parse(storedValue) : initialValue;

  const { subscribe, set, update } = writable(data);

  if (isBrowser) {
    subscribe((current) => {
      localStorage.setItem(key, JSON.stringify(current));
    });
  }

  return {
    subscribe,
    set,
    update,
  };
};
