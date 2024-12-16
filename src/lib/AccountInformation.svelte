<script>
    import { settings } from '../stores/auth';
  
    // Local variables to hold individual settings
    let darkMode;
    let notifications;
    let autoUpdate;
    let soundEffects;
    let language;
  
    // Subscribe to the settings store
    const unsubscribe = settings.subscribe((value) => {
      darkMode = value.darkMode;
      notifications = value.notifications;
      autoUpdate = value.autoUpdate;
      soundEffects = value.soundEffects;
      language = value.language;
    });
  
    // Toggle a boolean setting
    function toggleSetting(settingName) {
      settings.update((currentSettings) => {
        return { ...currentSettings, [settingName]: !currentSettings[settingName] };
      });
    }
  
    // Change the language setting
    function changeLanguage(event) {
      const selectedLanguage = event.target.value;
      settings.update((currentSettings) => {
        return { ...currentSettings, language: selectedLanguage };
      });
    }
  </script>
  
  <div class="settings-widget">
    <h2>Settings</h2>
  
    <div class="setting-item">
      <span>Dark Mode</span>
      <button on:click={() => toggleSetting('darkMode')}>
        {darkMode ? 'On' : 'Off'}
      </button>
    </div>
  
    <div class="setting-item">
      <span>Notifications</span>
      <button on:click={() => toggleSetting('notifications')}>
        {notifications ? 'On' : 'Off'}
      </button>
    </div>
  
    <div class="setting-item">
      <span>Auto Update</span>
      <button on:click={() => toggleSetting('autoUpdate')}>
        {autoUpdate ? 'On' : 'Off'}
      </button>
    </div>
  
    <div class="setting-item">
      <span>Sound Effects</span>
      <button on:click={() => toggleSetting('soundEffects')}>
        {soundEffects ? 'On' : 'Off'}
      </button>
    </div>
  
    <div class="setting-item">
      <span>Language</span>
      <select on:change={changeLanguage} bind:value={language}>
        <option value="en">English</option>
        <option value="es">Spanish</option>
        <option value="fr">French</option>
        <!-- Add more languages as needed -->
      </select>
    </div>
  
    <!-- Add more settings as needed -->
  </div>
  
  <style>
    .settings-widget {
      padding: 1.5rem;
      background-color: #f9f9f9;
      border-radius: 8px;
      max-width: 400px;
      margin: 2rem auto;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
  
    .settings-widget h2 {
      margin-bottom: 1rem;
      text-align: center;
    }
  
    .setting-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 1rem;
    }
  
    .setting-item span {
      font-size: 1rem;
    }
  
    .setting-item button {
      padding: 0.5rem 1rem;
      border: none;
      background-color: #007bff;
      color: white;
      border-radius: 4px;
      cursor: pointer;
    }
  
    .setting-item button:hover {
      background-color: #0056b3;
    }
  
    .setting-item select {
      padding: 0.5rem;
      font-size: 1rem;
    }
  </style>
  