<script>
  import { auth } from "../stores/auth";
  import { writable } from 'svelte/store';
  import { onDestroy } from "svelte";
  import { format } from "date-fns";

  let user;
  const userData = {
    firstName: "John",
    lastName: "Doe",
    email: "john.doe@example.com",
    profilePicture: "/images/profile.png",
    skills: [
      { name: "Python", level: 3 },
      { name: "Java", level: 2 },
      { name: "Golang", level: 2 }
    ],
    educations: [
      {
        institution_name: "University of Example",
        degree: "B.Sc. Computer Science",
        start_date: "2015-09-01",
        end_date: "2019-06-30"
      }
    ],
    experiences: [
      {
        company_name: "Example Corp",
        role: "Software Engineer",
        start_date: "2019-07-01",
        end_date: "2023-08-31"
      }
    ],
    accountCreatedAt: "2023-01-01T10:00:00Z",
    lastLoginAt: "2023-05-15T14:30:00Z",
  };

  auth.setUser(userData);
  const unsubscribe = auth.subscribe((value) => {
    user = value.user;
  });

  onDestroy(() => {
    unsubscribe();
  });


  function formatDate(dateString) {
    return format(new Date(dateString), "PPPpp");
  }

  const skills = writable([...userData.skills]);
  const educations = writable([...userData.educations]);
  const experiences = writable([...userData.experiences]);


  let skillError = "";
  let educationError = "";
  let experienceError = "";


  let newSkillName = "";
  let newSkillLevel = 1;

  // New Education Inputs
  let newEducationInstitution = "";
  let newEducationDegree = "";
  let newEducationStartDate = "";
  let newEducationEndDate = "";


  let newExperienceCompany = "";
  let newExperienceRole = "";
  let newExperienceStartDate = "";
  let newExperienceEndDate = "";

  function addSkill() {
    if (!newSkillName.trim()) {
      skillError = "Skill name is required.";
      return;
    }
    if (!(newSkillLevel >= 1 && newSkillLevel <= 5)) {
      skillError = "Skill level must be between 1 and 5.";
      return;
    }
    skills.update(current => [...current, { name: newSkillName.trim(), level: newSkillLevel }]);

    newSkillName = "";
    newSkillLevel = 1;
    skillError = "";
  }

  function removeSkill(index) {
    skills.update(current => current.filter((_, i) => i !== index));
  }

  function addEducation() {
    if (
      !newEducationInstitution.trim() ||
      !newEducationDegree.trim() ||
      !newEducationStartDate ||
      !newEducationEndDate
    ) {
      educationError = "All education fields are required.";
      return;
    }
    educations.update(current => [
      ...current,
      {
        institution_name: newEducationInstitution.trim(),
        degree: newEducationDegree.trim(),
        start_date: newEducationStartDate,
        end_date: newEducationEndDate
      }
    ]);

    newEducationInstitution = "";
    newEducationDegree = "";
    newEducationStartDate = "";
    newEducationEndDate = "";
    educationError = "";
  }

  function removeEducation(index) {
    educations.update(current => current.filter((_, i) => i !== index));
  }


  function addExperience() {
    if (
      !newExperienceCompany.trim() ||
      !newExperienceRole.trim() ||
      !newExperienceStartDate ||
      !newExperienceEndDate
    ) {
      experienceError = "All experience fields are required.";
      return;
    }
    experiences.update(current => [
      ...current,
      {
        company_name: newExperienceCompany.trim(),
        role: newExperienceRole.trim(),
        start_date: newExperienceStartDate,
        end_date: newExperienceEndDate
      }
    ]);
    newExperienceCompany = "";
    newExperienceRole = "";
    newExperienceStartDate = "";
    newExperienceEndDate = "";
    experienceError = "";
  }

  function removeExperience(index) {
    experiences.update(current => current.filter((_, i) => i !== index));
  }
</script>

{#if user}
  <div class="personal-data-widget">
    {#if user.profilePicture}
      <img
        src={user.profilePicture}
        alt="{user.firstName} {user.lastName}"
        class="user-photo"
      />
    {:else}
      <div class="user-photo placeholder">
        <span>{user.firstName.charAt(0)}{user.lastName.charAt(0)}</span>
      </div>
    {/if}


    <div class="user-details">
      <h2>{user.firstName} {user.lastName}</h2>
      <p><strong>Email:</strong> {user.email}</p>
      <p>
        <strong>Account Created:</strong>
        {formatDate(user.accountCreatedAt)}
      </p>
      <p><strong>Last Login:</strong> {formatDate(user.lastLoginAt)}</p>
    </div>

    <div class="section">
      <h3>Skills</h3>
      {#each $skills as skill, index}
        <div class="list-item">
          <span>{skill.name} (Level {skill.level})</span>
          <button type="button" on:click={() => removeSkill(index)}>Remove</button>
        </div>
      {/each}

      <!-- Add New Skill Form -->
      <div class="add-form">
        <input
          type="text"
          placeholder="Skill Name"
          bind:value={newSkillName}
        />
        <select bind:value={newSkillLevel}>
          <option value="1">1 - Entry-level</option>
          <option value="2">2 - Junior</option>
          <option value="3">3 - Mid-level</option>
          <option value="4">4 - Senior</option>
          <option value="5">5 - Expert</option>
        </select>
        <button type="button" on:click={addSkill}>Add Skill</button>
        {#if skillError}
          <p class="error">{skillError}</p>
        {/if}
      </div>
    </div>

    <!-- Educations Section -->
    <div class="section">
      <h3>Educations</h3>
      {#each $educations as edu, index}
        <div class="list-item">
          <span>{edu.degree} at {edu.institution_name} ({edu.start_date} - {edu.end_date})</span>
          <button type="button" on:click={() => removeEducation(index)}>Remove</button>
        </div>
      {/each}

      <!-- Add New Education Form -->
      <div class="add-form">
        <input
          type="text"
          placeholder="Institution Name"
          bind:value={newEducationInstitution}
        />
        <input
          type="text"
          placeholder="Degree"
          bind:value={newEducationDegree}
        />
        <input
          type="date"
          bind:value={newEducationStartDate}
        />
        <input
          type="date"
          bind:value={newEducationEndDate}
        />
        <button type="button" on:click={addEducation}>Add Education</button>
        {#if educationError}
          <p class="error">{educationError}</p>
        {/if}
      </div>
    </div>

    <!-- Experiences Section -->
    <div class="section">
      <h3>Experiences</h3>
      {#each $experiences as exp, index}
        <div class="list-item">
          <span>{exp.role} at {exp.company_name} ({exp.start_date} - {exp.end_date})</span>
          <button type="button" on:click={() => removeExperience(index)}>Remove</button>
        </div>
      {/each}

      <!-- Add New Experience Form -->
      <div class="add-form">
        <input
          type="text"
          placeholder="Company Name"
          bind:value={newExperienceCompany}
        />
        <input
          type="text"
          placeholder="Role"
          bind:value={newExperienceRole}
        />
        <input
          type="date"
          bind:value={newExperienceStartDate}
        />
        <input
          type="date"
          bind:value={newExperienceEndDate}
        />
        <button type="button" on:click={addExperience}>Add Experience</button>
        {#if experienceError}
          <p class="error">{experienceError}</p>
        {/if}
      </div>
    </div>
  </div>
{:else}
  <p>Loading user data...</p>
{/if}

<style>
  .personal-data-widget {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 2rem;
    background-color: #f9f9f9;
    border-radius: 8px;
  }

  .user-photo {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    object-fit: cover;
    margin-bottom: 1.5rem;
    background-color: #ddd;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .user-photo.placeholder {
    background-color: #007bff;
    color: #fff;
    font-size: 2rem;
  }

  .user-details {
    width: 100%;
    max-width: 800px;
    text-align: center;
    margin-bottom: 2rem;
  }

  .user-details h2 {
    font-size: 1.75rem;
    margin-bottom: 0.5rem;
  }

  .user-details p {
    font-size: 1rem;
    margin: 0.25rem 0;
    color: #555;
  }

  .user-details p strong {
    color: #333;
  }

  .section {
    width: 100%;
    max-width: 800px;
    margin-top: 1.5rem;
  }

  .section h3 {
    font-size: 1.5rem;
    margin-bottom: 1rem;
    text-align: center;
  }

  .list-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: #fff;
    padding: 0.75rem 1rem;
    margin-bottom: 0.5rem;
    border: 1px solid #ddd;
    border-radius: 4px;
  }

  .list-item span {
    font-size: 1rem;
    color: #333;
  }

  .list-item button {
    padding: 0.25rem 0.5rem;
    border: none;
    background-color: #dc3545;
    color: white;
    border-radius: 4px;
    cursor: pointer;
  }

  .list-item button:hover {
    background-color: #c82333;
  }

  .add-form {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    margin-top: 1rem;
    background-color: #fff;
    padding: 1rem;
    border: 1px solid #ddd;
    border-radius: 4px;
  }

  .add-form input,
  .add-form select {
    padding: 0.5rem;
    border: 1px solid #ccc;
    border-radius: 4px;
    font-size: 1rem;
  }

  .add-form button {
    padding: 0.5rem;
    border: none;
    background-color: #007bff;
    color: white;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1rem;
    margin-top: 0.5rem;
  }

  .add-form button:hover {
    background-color: #0056b3;
  }

  .error {
    color: #dc3545;
    font-size: 0.9rem;
    margin-top: 0.25rem;
  }

  /* Responsive Design */
  @media (max-width: 600px) {
    .list-item {
      flex-direction: column;
      align-items: flex-start;
    }

    .list-item button {
      margin-top: 0.5rem;
    }

    .add-form {
      gap: 0.75rem;
    }
  }
</style>
