<script>
    import { onMount } from 'svelte';
    import jsPDF from 'jspdf';
    import 'jspdf-autotable';
  
    // Define the form data with default values
    let formData = {
      fullName: 'John Doe',
      email: 'johndoe@example.com',
      phone: '+1 234 567 890',
      address: '123 Main Street, Anytown, USA',
      linkedin: 'https://linkedin.com/in/johndoe',
      github: 'https://github.com/johndoe',
      summary: 'A passionate software developer with experience in building web applications.',
      experience: [
        {
          company: 'Tech Company',
          role: 'Frontend Developer',
          duration: 'Jan 2020 - Present',
          description: 'Developed and maintained the company website using Svelte and JavaScript.'
        },
        {
          company: 'Another Tech Company',
          role: 'Junior Developer',
          duration: 'Jun 2018 - Dec 2019',
          description: 'Assisted in developing internal tools using React and Node.js.'
        }
      ],
      education: [
        {
          institution: 'University of Technology',
          degree: 'Bachelor of Science in Computer Science',
          duration: '2014 - 2018',
          description: 'Graduated with honors.'
        }
      ],
      skills: 'JavaScript, Svelte, React, Node.js, CSS, HTML, Git'
    };
  
    // Function to generate PDF
    function generatePDF() {
      const doc = new jsPDF();
  
      // Define margins
      const leftMargin = 20;
      let y = 20;
      const lineWidth = 170;

          // Add Photo if available
    if (formData.photo) {
      // Add the image to the PDF
      // Position: Top right corner
      // Size: 35mm x 45mm
      doc.addImage(formData.photo, 'JPEG', leftMargin + lineWidth - 55, 15, 35, 45);
    }
  
      // Add Full Name
      doc.setFontSize(22);
      doc.setFont('helvetica', 'bold');
      doc.text(formData.fullName, leftMargin, y);
      y += 6;
  
      // Draw a horizontal line
      doc.setLineWidth(0.5);
      doc.line(leftMargin, y, leftMargin + 90, y);
      y += 10;
  
      // Contact Information
      doc.setFontSize(12);
      doc.setFont('helvetica', 'normal');
      doc.text(`Email: ${formData.email}`, leftMargin, y);
      y += 6;
      doc.text(`Phone: ${formData.phone}`, leftMargin, y);
      y += 6;
      doc.text(`Address: ${formData.address}`, leftMargin, y);
      y += 6;
      doc.text(`LinkedIn: ${formData.linkedin}`, leftMargin, y);
      y += 6;
      doc.text(`GitHub: ${formData.github}`, leftMargin, y);
      y += 10;
  
      // Draw a horizontal line
      doc.line(leftMargin, y, leftMargin + lineWidth, y);
      y += 10;
  
      // Summary
      doc.setFontSize(16);
      doc.setFont('helvetica', 'bold');
      doc.text('Professional Summary', leftMargin, y);
      y += 6;
      doc.setFontSize(12);
      doc.setFont('helvetica', 'normal');
      const summaryLines = doc.splitTextToSize(formData.summary, leftMargin + lineWidth);
      doc.text(summaryLines, leftMargin, y);
      y += summaryLines.length * 6 + 4;
  
      // Draw a horizontal line
      doc.line(leftMargin, y, leftMargin + lineWidth, y);
      y += 10;
  
      // Experience
      doc.setFontSize(16);
      doc.setFont('helvetica', 'bold');
      doc.text('Experience', leftMargin, y);
      y += 6;
      doc.setFontSize(12);
      doc.setFont('helvetica', 'normal');
      formData.experience.forEach(exp => {
        doc.setFont('helvetica', 'bold');
        doc.text(`${exp.role} at ${exp.company}`, leftMargin, y);
        y += 6;
        doc.setFont('helvetica', 'italic');
        doc.text(`${exp.duration}`, leftMargin + 120, y);
        y += 6;
        const expDescription = doc.splitTextToSize(exp.description, leftMargin + lineWidth);
        doc.text(expDescription, leftMargin, y);
        y += expDescription.length * 6 + 4;
  
        // Check for page overflow
        if (y > 270) {
          doc.addPage();
          y = 20;
        }
      });
  
      // Draw a horizontal line
      doc.line(leftMargin, y, leftMargin + lineWidth, y);
      y += 10;
  
      // Education
      doc.setFontSize(16);
      doc.setFont('helvetica', 'bold');
      doc.text('Education', leftMargin, y);
      y += 6;
      doc.setFontSize(12);
      doc.setFont('helvetica', 'normal');
      formData.education.forEach(edu => {


        doc.setFont('helvetica', 'bold');
        const eduTitle = `${edu.degree} - ${edu.institution}`;
        const maxEduTitleWidth = 100; // Maximum width for the title
        const eduTitleLines = doc.splitTextToSize(eduTitle, maxEduTitleWidth);
        doc.text(eduTitleLines, leftMargin, y);
        doc.setFont('helvetica', 'italic');
        doc.text(`${edu.duration}`, leftMargin + 120, y);
        y += eduTitleLines.length * 6; // Adjust y based on the number of lines
        const eduDescription = doc.splitTextToSize(edu.description, lineWidth);
        doc.text(eduDescription, leftMargin, y);
        y += eduDescription.length * 6 + 4;


        if (y > 270) {
          doc.addPage();
          y = 20;
        }
      });
  
      // Draw a horizontal line
      doc.line(leftMargin, y, leftMargin + lineWidth, y);
      y += 10;
  
      // Skills
      doc.setFontSize(16);
      doc.setFont('helvetica', 'bold');
      doc.text('Skills', leftMargin, y);
      y += 6;
      doc.setFontSize(12);
      doc.setFont('helvetica', 'normal');
      const skillsLines = doc.splitTextToSize(formData.skills, leftMargin + lineWidth);
      doc.text(skillsLines, leftMargin, y);
      y += skillsLines.length * 6 + 10;
  
      // Disclaimer
      doc.setFontSize(10);
      doc.setFont('helvetica', 'normal');
        doc.text(
        'I hereby give consent to the processing of my personal data for the purpose of conducting the recruitment process for the position I have applied for.',
        10,
        285,
        { maxWidth: 190 }
        );
    //   const disclaimer = "I hereby give consent to the processing of my personal data for the purpose of conducting the recruitment process for the position I have applied for.";
    //   doc.setFontSize(10);

    //   doc.text(disclaimer, leftMargin, 290, { maxWidth: lineWidth, align: 'center' });
  
      // Save the PDF
      doc.save('CV.pdf');
    }


    function handlePhotoUpload(event) {
  const file = event.target.files[0];
  if (file) {
    const reader = new FileReader();
    reader.onload = (e) => {
      formData.photo = e.target.result;
    };
    reader.readAsDataURL(file);
  } else {
    formData.photo = null;
  }
}
  </script>
  
  <style>
    .container {
      max-width: 800px;
      margin: 0 auto;
      padding: 2rem;
      font-family: Arial, sans-serif;
      background-color: #f9f9f9;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
  
    h1 {
      text-align: center;
      margin-bottom: 2rem;
      color: #333;
    }
  
    form {
      display: flex;
      flex-direction: column;
      gap: 1.5rem;
    }
  
    .section {
      background-color: #fff;
      padding: 1rem;
      border-radius: 6px;
      box-shadow: 0 0 5px rgba(0, 0, 0, 0.05);
    }
  
    .section h2 {
      margin-bottom: 0.5rem;
      color: #555;
    }
  
    label {
      font-weight: bold;
      display: block;
      margin-bottom: 0.25rem;
      color: #444;
    }
  
    input,
    textarea {
      width: 100%;
      padding: 0.5rem;
      font-size: 1rem;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
  
    input:focus,
    textarea:focus {
      border-color: #4CAF50;
      outline: none;
    }
  
    button {
      padding: 0.75rem;
      font-size: 1rem;
      background-color: #4CAF50;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }
  
    button:hover {
      background-color: #45a049;
    }
  
    /* Responsive Design */
    @media (max-width: 600px) {
      .container {
        padding: 1rem;
      }
    }
  </style>
  
  <div class="container">
    <h1>CV Builder</h1>
    <form on:submit|preventDefault={generatePDF}>
      <div class="section">
        <label for="fullName">Full Name</label>
        <input id="fullName" type="text" bind:value={formData.fullName} />
      </div>
  
      <div class="section">
        <label for="email">Email</label>
        <input id="email" type="email" bind:value={formData.email} />
      </div>

      <div class="section">
        <label for="photo">Upload Photo (Optional)</label>
        <input id="photo" type="file" accept="image/*" on:change={handlePhotoUpload} />
        {#if formData.photo}
          <div style="margin-top: 10px;">
            <img src="{formData.photo}" alt="User Photo" style="max-width: 100px; border: 1px solid #ccc; border-radius: 4px;" />
          </div>
        {/if}
      </div>
  
      <div class="section">
        <label for="phone">Phone</label>
        <input id="phone" type="text" bind:value={formData.phone} />
      </div>
  
      <div class="section">
        <label for="address">Address</label>
        <input id="address" type="text" bind:value={formData.address} />
      </div>
  
      <div class="section">
        <label for="linkedin">LinkedIn</label>
        <input id="linkedin" type="url" bind:value={formData.linkedin} />
      </div>
  
      <div class="section">
        <label for="github">GitHub</label>
        <input id="github" type="url" bind:value={formData.github} />
      </div>
  
      <div class="section">
        <label for="summary">Professional Summary</label>
        <textarea id="summary" rows="4" bind:value={formData.summary}></textarea>
      </div>
  
      <!-- Experience Section -->
      <div class="section">
        <h2>Experience</h2>
        {#each formData.experience as exp, index}
          <div>
            <label for={`company-${index}`}>Company</label>
            <input id={`company-${index}`} type="text" bind:value={exp.company} />
  
            <label for={`role-${index}`}>Role</label>
            <input id={`role-${index}`} type="text" bind:value={exp.role} />
  
            <label for={`duration-${index}`}>Duration</label>
            <input id={`duration-${index}`} type="text" bind:value={exp.duration} />
  
            <label for={`description-${index}`}>Description</label>
            <textarea id={`description-${index}`} rows="3" bind:value={exp.description}></textarea>
          </div>
        {/each}
      </div>
  
      <!-- Education Section -->
      <div class="section">
        <h2>Education</h2>
        {#each formData.education as edu, index}
          <div>
            <label for={`institution-${index}`}>Institution</label>
            <input id={`institution-${index}`} type="text" bind:value={edu.institution} />
  
            <label for={`degree-${index}`}>Degree</label>
            <input id={`degree-${index}`} type="text" bind:value={edu.degree} />
  
            <label for={`edu-duration-${index}`}>Duration</label>
            <input id={`edu-duration-${index}`} type="text" bind:value={edu.duration} />
  
            <label for={`edu-description-${index}`}>Description</label>
            <textarea id={`edu-description-${index}`} rows="3" bind:value={edu.description}></textarea>
          </div>
        {/each}
      </div>
  
      <div class="section">
        <label for="skills">Skills (comma separated)</label>
        <input id="skills" type="text" bind:value={formData.skills} />
      </div>
  
      <button type="submit">Generate PDF</button>
    </form>
  </div>
  