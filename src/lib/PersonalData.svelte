<script>
  import { writable } from "svelte/store";
  import { onDestroy, onMount } from "svelte";
  import { format } from "date-fns";
  import {user, verifyUser} from '$lib/stores/user'
  import { auth } from "../stores/auth";
  import ProfilePicture from './ProfilePicture.svelte';

  const API_URL = "http://localhost:8080/user-service/graphql";

  const skills = writable([]);
  const educations = writable([]);
  const experiences = writable([]);

  let userProfile = null;
  let newSkillName = "", newSkillLevel = "1";
  let newEducationInstitution = "", newEducationDegree = "", newEducationStartDate = "2023-01", newEducationEndDate = "2023-12";
  let newExperienceCompany = "", newExperienceRole = "", newExperienceStartDate = "2023-01", newExperienceEndDate = "2023-12";


  // Utility function to call GraphQL API
  async function callGraphQL(query, variables = {}) {
    verifyUser()
    try {
      console.log("Calling GraphQL API:", query, variables);
      const response = await fetch(API_URL, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${$user.jwt}`,
        },
        body: JSON.stringify({ query, variables }),
      });
      const data = await response.json();
      if (data.errors) {
        console.error("GraphQL errors:", data.errors);
        return null;
      }
      return data.data;
    } catch (error) {
      console.error("Error calling GraphQL API:", error);
      return null;
    }
  }

  async function fetchUserProfile() {
    const query = `
      query {
        currentUserProfile {
          profileId
          user {
            firstName
            lastName
            email
          }
          skills {
            skillId
            skillName
            proficiencyLevel
          }
          educations {
            educationId
            institutionName
            degree
            startDate
            endDate
          }
          experiences {
            experienceId
            companyName
            role
            startDate
            endDate
          }
          profilePictureUrl
          createdAt
        }
      }
    `;
    const data = await callGraphQL(query);
    if (data && data.currentUserProfile) {
      const profile = data.currentUserProfile;
      return {
        firstName: profile.user.firstName,
        lastName: profile.user.lastName,
        email: profile.user.email,
        profilePicture: profile.profilePictureUrl,
        skills: profile.skills.map(skill => ({
          skillId: skill.skillId,
          skillName: skill.skillName,
          proficiencyLevel: skill.proficiencyLevel,
        })),
        educations: profile.educations.map(education => ({
          educationId: education.educationId,
          institutionName: education.institutionName,
          degree: education.degree,
          startDate: education.startDate,
          endDate: education.endDate,
        })),
        experiences: profile.experiences.map(experience => ({
          experienceId: experience.experienceId,
          companyName: experience.companyName,
          role: experience.role,
          startDate: experience.startDate,
          endDate: experience.endDate,
        })),
        accountCreatedAt: profile.createdAt,
      };
    }
  }

  onMount(async () => {
    userProfile = await fetchUserProfile();
    console.log("User Profile:", userProfile);
    if (userProfile) {
      auth.setUser(userProfile);
      skills.set(userProfile.skills || []);
      educations.set(userProfile.educations || []);
      experiences.set(userProfile.experiences || []);
    }
  });

  onDestroy(() => {
    userProfile = null;
  });

  // Skill API integration
  async function addSkill() {
    if(!validateSkill()) {
      return;
    }

    const mutation = `
      mutation {
        addSkill(skillRequest: { skillName: "${newSkillName}", proficiencyLevel: "${newSkillLevel}" }) {
          skillId
          skillName
          proficiencyLevel
        }
      }
    `;
    const variables = { skillName: newSkillName, proficiencyLevel: newSkillLevel };
    const data = await callGraphQL(mutation, variables);
    if (data && data.addSkill) {
        skills.update(current => [...current, data.addSkill]);
    }

    newSkillName = "";
    newSkillLevel = "1";
  }

  async function removeSkill(skillId) {
    const mutation = `
      mutation {
        deleteSkillById(skillId: "${skillId}") {
          skillId
        }
      }
    `;
    const data = await callGraphQL(mutation, { skillId });
    if (data && data.deleteSkillById) {
      skills.update(current => current.filter(skill => skill.skillId !== skillId));
    }
  }

  // Education API integration
  async function addEducation() {
    if(!validateEducation()) {
      return;
    }

    const mutation = `
      mutation {
        addEducation(educationRequest: {
          institutionName: "${newEducationInstitution}",
          degree: "${newEducationDegree}",
          startDate: "${newEducationStartDate}",
          endDate: "${newEducationEndDate}"
        }) {
          educationId
          institutionName
          degree
          startDate
          endDate
        }
      }
    `;
    const data = await callGraphQL(mutation, { newEducationInstitution, newEducationDegree, newEducationStartDate, newEducationEndDate });
    if (data && data.addEducation) {
      educations.update(current => [...current, data.addEducation]);
    }

    newEducationInstitution = "";
    newEducationDegree = "";
    newEducationStartDate = "";
    newEducationEndDate = "";
  }

  async function removeEducation(educationId) {
    const mutation = `
      mutation{
        deleteEducationById(educationId: "${educationId}") {
          success
          message
        }
      }
    `;
    const data = await callGraphQL(mutation, { educationId });
    if (data && data.deleteEducationById) {
      educations.update(current => current.filter(edu => edu.educationId !== educationId));
    }
  }

  // Experience API integration
  async function addExperience() {
    if(!validateExperience()) {
      return;
    }

    const mutation = `
      mutation {
        addExperience(experienceRequest: {
          companyName: "${newExperienceCompany}",
          role: "${newExperienceRole}",
          startDate: "${newExperienceStartDate}",
          endDate: "${newExperienceEndDate}"
        }) {
          experienceId
          companyName
          role
          startDate
          endDate
        }
      }
    `;
    const data = await callGraphQL(mutation, { newExperienceCompany, newExperienceRole, newExperienceStartDate, newExperienceEndDate });
    if (data && data.addExperience) {
      experiences.update(current => [...current, data.addExperience]);
    }
    newExperienceCompany = "";
    newExperienceRole = "";
    newExperienceStartDate = "";
    newExperienceEndDate = "";
  }

  async function removeExperience(experienceId) {
    const mutation = `
      mutation {
        deleteExperienceById(experienceId: "${experienceId}") {
            success
            message
        }
      }
    `;
    const data = await callGraphQL(mutation, { experienceId });
    if (data && data.deleteExperienceById) {
      experiences.update(current => current.filter(exp => exp.experienceId !== experienceId));
    }
  }

  function formatDate(dateString) {
    return format(new Date(dateString), "PPPpp");
  }

  // Form Handling Variables
  let skillError = "", educationError = "", experienceError = "";

  function validateSkill() {
    if (!newSkillName.trim()) {
      skillError = "Skill name is required.";
      return false;
    }
    if (!newSkillLevel) {
      skillError = "Skill level is required.";
      return false;
    }
    skillError = "";
    return true;
  }

  function validateEducation() {
    if (!newEducationInstitution.trim()) {
      educationError = "Institution name is required.";
      return false;
    }
    if (!newEducationDegree.trim()) {
      educationError = "Degree is required.";
      return false;
    }
    if (!newEducationStartDate) {
      educationError = "Start date is required.";
      return false;
    }
    if (!newEducationEndDate) {
      educationError = "End date is required.";
      return false;
    }
    if (newEducationStartDate > newEducationEndDate) {
      educationError = "End date cannot be before start date.";
      return false;
    }
    educationError = "";
    return true;
  }

  function validateExperience() {
    if (!newExperienceCompany.trim()) {
      experienceError = "Company name is required.";
      return false;
    }
    if (!newExperienceRole.trim()) {
      experienceError = "Role is required.";
      return false;
    }
    if (!newExperienceStartDate) {
      experienceError = "Start date is required.";
      return false;
    }
    if (!newExperienceEndDate) {
      experienceError = "End date is required.";
      return false;
    }
    if (newExperienceStartDate > newExperienceEndDate) {
      experienceError = "End date cannot be before start date.";
      return false;
    }
    experienceError = "";
    return true;
  }
</script>



{#if userProfile}
  <div class="personal-data-widget">
    <ProfilePicture
            profilePicture={userProfile.profilePicture}
            firstName={userProfile.firstName}
            lastName={userProfile.lastName}
    />

    <div class="user-details">
      <h2>{userProfile.firstName} {userProfile.lastName}</h2>
      <p><strong>Email:</strong> {userProfile.email}</p>
      <p>
        <strong>Account Created:</strong>
        {formatDate(userProfile.accountCreatedAt)}
      </p>
    </div>

    <div class="section">
      <h3>Skills</h3>
      {#each $skills as skill}
        <div class="list-item">
          <span>{skill.skillName} (Level {skill.proficiencyLevel})</span>
          <button type="button" on:click={() => removeSkill(skill.skillId)}>Remove</button>
        </div>
      {/each}

      <div class="add-form">
        <input
                type="text"
                placeholder="Skill Name"
                bind:value={newSkillName}
        />
        <select bind:value={newSkillLevel}>
          <option value="" disabled selected hidden>Select Level</option>
          <option value="1">1 -> Beginner</option>
          <option value="2">2 -> Junior</option>
          <option value="3">3 -> Mid-level</option>
          <option value="4">4 -> Senior</option>
          <option value="5">5 -> Expert</option>
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
      {#each $educations as edu}
        <div class="list-item">
          <span>{edu.degree} at {edu.institutionName} ({edu.startDate} - {edu.endDate})</span>
          <button type="button" on:click={() => removeEducation(edu.educationId)}>Remove</button>
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
          type="month"
          bind:value={newEducationStartDate}
        />
        <input
          type="month"
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
      {#each $experiences as exp}
        <div class="list-item">
          <span>{exp.role} at {exp.companyName} ({exp.startDate} - {exp.endDate})</span>
          <button type="button" on:click={() => removeExperience(exp.experienceId)}>Remove</button>
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
          type="month"
          bind:value={newExperienceStartDate}
        />
        <input
          type="month"
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
