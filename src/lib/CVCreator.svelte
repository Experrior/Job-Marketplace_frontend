<script>
    import { writable } from 'svelte/store';
    import jsPDF from 'jspdf';
    import {user, verifyUser} from '$lib/stores/user'
    import axios from 'axios';
    import {
      isValidPhoneNumber,
    } from 'libphonenumber-js'

  let userProfile = $user.profile

   const AiOutlineLinkedin = 'data:image/png;base64,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'

   const AiOutlineMail = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAACXBIWXMAAHYcAAB2HAGnwnjqAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAD25JREFUeJztnXnQ1lUVxz/nBREEF0xxrSxUFHPJBVCMUFEoS80Mt3Q0E00dLc2WyXFpmfbUzKmxUXNX1MRdEQyD3MYFlzEdNUpF0XwFBQETOP1xfu/L48vzPPfe33N/y/Py+87cGYb3PPeee8/3d9dzzxVVJRZEpA+wF/BlYATwKWAjYAUwD3gReAi4DXhYYxZeoSFEZFvgp8Do5L9mAWep6vOoassJ6AucDMwB1DM9CxwBSAwdqtTQNqOABXXafz4wTFr9CEVkB+BqYPuUWcwEjlLV/7SkSIVVICKjgHuBdRqI3NwSAUTkIOBaYEDqTAzvAAeo6j9azKdCAg/jA8zraKGAI4CbaN34AOsDU0Vkjwh5rfbwND4AqQiQGP9KoE+a3zfAWsCtIrJFxDxXOyTGvwcP4wOzgocAETkcuIq4xq/F48Ceqro0o/x7LWqMv66H+LvAyKAeQEQmEv/L74ldgEsyzL9XQkR2Ae7Cz/jvARNU9YWQ5cThwDL8l3nLgBnA74E/YOt/398qcFzRS6iAttkOmAK8laQpwHYlWOrVS+8Co7p/m5HxHwSG1clnF+AZzzyWADsXbVyPthmR6FpP/xFlNr4XAVIY/w5gzSb5rY9tAvnkNQdYv2gjO9pnahP9p5bI+At6Gt9JAOCwmMavyXerAMXvAjqKNnSTuixsovvCMhu/KQGAg7Mwfk3+B2FnBD55n1O0oZvUo6nuZTZ+QwJg49r7Aca/G+ifoiK/8Mx/OfCFoo1dBgJg86h3PNttlTHfSQBgKPDfAOPfGfLl9yirDzDds5xOYIuiDV4kAWJ++XUJgO0Mzsz6y+9R5hDgVc/yZgMDijZ6EQQI/PK9jF+PAGfmafyackcCSz3LvbJoo+dNgKyM/xECAJsDiz0LSd3tN6nkyQHkK80mUdYESD6OqN1+IwJc5FnIfbGNX6PD1Z46LAF2Kdr4WRMga+N3EwDYhPq7WT3TbGCdDBtzIPC0Z4XnUIJNoqwIkIfxawlwlkchi4Gtc2jQttokyoIAeRm/lgBPeRT0vRwbNWST6NzeRIA8jZ+Ux9YeBc0D1sq5YX/u2QjLgS/2BgKQ4Wy/GQFO9Cjs7AIati02iWIRIMWXPzKG/h3ATrhxo4dMVKjqcmAi8G8P8fWBa5J7CW2HxJnjbvw9eSao6iMxyu4AdnTIvKqq/4xRWChUtRM7jv6fh/gewPHZahQfIjIS6+kGe4i/C4xX1Ydjld8BfMIh81SswtIgqezpnuJni8iaWeoTE4nx78X/yx8f68vvQgfmjdsMr8UsMA1U9WLgCg/RTYADM1YnCors9mvRgduvf0nsQlPiJMydzIWJWSvSKoru9mvRAXzokPHxL88cqroYOBJzUmmGvUVEclApFcrQ7deiA5jrkHHNEXKDqj4D3OwQG4wNBaVD2YwPRgDXGD9CRPpmqUQg7vOQ2TRzLQJRRuODEeB5h8y6mCdKWdDpIRPjvmI0lNX4YASY7iF3VNaKBGAzD5n3MtfCE2U2PhgB/obtpzfDYSLiWi7mhZEeMq55TZ4orfHBjlIXYDd5mmEd4JAc9PHBWMff56rq23ko4onSGh9WXg/32WT5RpaK+EBEtgQ+7hCblYcuEVGY8WElAW7Abrg0w5jEAEVirIfMA1krERGFGh8SAqjqIizaRzMIcEzWCjnweQ+ZGVkrEQmFGx+SCF0AIrIndiegGeYCn0yOanOHiLxC8yHgTWAT7apUDhCRNGWVwvgAtQ4JAryA2xnhkIIcL4Z66HZD2RxCCkgLsSghXl7T3RFCkq/mcg/OnOEhkwXGesi00/ifFQYB44GZIrKNS7hniJgrcR+2jCoomtdYD5kZGevQThgA/Mwl9BECqOrrwO0emRfRC7gmgG8BhXgulRijXQL1gkT9ziPjA0VkaLg+6ZCU5Vr/P5Dn5K8GruVzqbEKAVR1FuCanfYBvpOJRvUx1kNmRsY6NILPWUpRcEdebTCznYh7trmInK5mYXEJXfoML2h1Mgx/X/4802JgG6f+DSrVF7/I3+fl1Miu+AFvUmDUcWx4moyt74s2fNAysGGkUBE5Dbig7h9XYhEwVFXfcsilRrL9/KJDbLKqHpqVDr0ZzSKFXobdQGmGQcB346lTF2M9ZKr1f0o0JICqLsQvZOspIpKlC5Zr+QcVAVLDFSv4t1g33wwDgB/FUacuXGvZt4DnMiy/V6MpAZKx/SKPfI4XkU/HUWklRGQ9YAuH2AxtNJGp4IRPtPBf454LrIEFmYiNzbFDqmYo/kStjeEkgKrOx4YCF44WEddF01AM8pAp/OpaO8P3vYALsLG2GfoAF0e+lbPYQ2aDiOWtdvAigJrH0C89REdj17lj4U0PmXERy1vt4P1kjIgMwDZkXH75r2NbkFEOSUTkDWDjJiLLgN1UdXaM8lY3eD8Zo6pLgHM8RDcl7oTQ5abWF7hJRDaKWOZqg9BXwy7Hb9b9bR9vFE9M9pAZCjyQ8YZUr0SaV8NGYO//uMhzr6pOSKtYTXlrYkOPyx8AzCFkL1X1mTtUIMW7gar6KH6+g+NFpOU7har6AR6uTQm2Bf5WDQf+SPV0rIgMwTyI13OIvgt8RlVbWquLSAdwP37nAiS67a3m4lahCVK9HJpsEZ/tIbou8Mc0ZfQobwVwNLbC8MEwYFrVE7iR+vHoJGjE48AOHuLHqupfUhX00TJ3wm4zu3qeLlRzAgdafT18T+wo1tWTLMCGgpavbYvIrliUkIoEEZD69XDodiD1OS1cD7g8xjaxqj4G7I354flgW6olYkO01AMAJIEjZmNh3l04QVWjvAtc9QRx0DIBAERkd2zHzhWrdymwh6o+2XKhVu5ngWlYrGAfVKuDHmhpCOiCqj4EXOgh2h+YLCJRYg8mRBqH/3AwDLi/Gg5WIkoPAN07dk8Awz3Eo3rxVj1BekTpAaB7x+443AGnACaKyLcill31BCkRjQAAavFsffwGAM5PAibHKvtJYAJu97UuVJtFRBwCujO0DaLpwBgP8Zexs/z5EcvfDXvSvVodeCA6AQCSrvVJ7FlYF6ZjD0O7glaHlF9qEojIhtjp5mCsx5oXY5MsFTK8L7cvNh/wuc92SQbl7wbM9yxfsbsFG2XUFsOxcPc3YHGW6pX/DhYI+zAyepizrm6ZZg7nBRjgjN5Cgh4GnxdQfleaiz3m1afdCRDy8tdy4IB2JEEEgzdKM8n4NbRMCZA0zsbAG54VXgjsVAISvNRMjxqDT8Y8l2MZvF7qxOZImdgnk0lgTyRBpaZjO4EuvIY9iBh1UpRiYrgMuA1zROnEvKFHYk4pPpPbmFgB/AT4sZpvRDxk3QPUfDVfw/852BfIYEIG7IwZM8svNst0PzAkapvkRYDEAOcGVHY2MLgiwSrpFSK9GloEAQS4OqCyDwGDKhKskpYCp8Voi1zmALUQkf5YV7a750+mAV9SO2uIqUfonCAW5mIRzR5O/v0xYD/gK9gllxBcCpyiqktTa5NnD1DzBQ7BLwhVV5oC9M2oJ3g9QI806TWs1/smsFUTXXYEnk2R/+O0sFQshABJhbcD3g6o6HUZkeATwN8jG/wql8Eb6DIQuDZFmamXioURIKnwboSFVptCBtuk2KnoCdgEqxWDbxlJn1OxB7ND9FiO3d3saBsCJJUdA7wfUNGpwMCMdOkHfBXb4Km3ebUC+Fdi8ONiGbyBLqMTcoUS8i4CAnjmPgmsBxEZj2269PP8yYPA/moPXmWGxFdgCKbXEuBVjXTtPaD86/ELlVeLOdi7Dk84JYvuAWoYfxD2jrEv058ANixa7xzapQ+2f+J7stqVvJaKhVewR2WPCqzoc8BmReudU9scTLpQtH8G+rcFAZKKTgokwatkcIBUxoS5saVZKj5Gg6Vi4ZVqUNHDCZsFLwIOLFrvnNpmAHY9P5QEncDn2oIASUUPBj4IqOByMnAqKWsi3VLxfWB0WxAgqeQEwpaIisU3XqNo3XNqnzRLxU7s6b/yEyCp5BjCJz/TyOAksYwJ2Ai7Mh/SPg+QOARHvReQBVT179ilj86An+0DPBbz3kFZoebJvC8W0lc9fzYGcz4tfw9Qw/Th2C5cCNOXAicVrXuObRSyVHwGkFLsBPoiiU10CxD6buFk4HhVfS++VuWCiAwD/orfHc1RpR8CaqEWm2gf7GQwBBOxIWGn+FqVC6r6AtbF+7yhsH9bEQBAzfnhSFa6l/liK+AhETkxckDr0kFVO/F76X37thoCekJEDsfeNvLxNq7FPdiQ0KtDzYvIo9iReyO82HY9QC1U9TosXtAbgT+dADwrIsfG16pUeMzx903amgAAatFJPkv4C57rApeJyB29OE6AK1bD4rYnAHxkLfwD/AJU1GJ/4DkRmRRdseLhesFlcVvPAepBRMYB15Du9s5U4NRkJt3WEJFtsbV+s8BdM3tFD1ALVZ2GDQlp3hLcD3haRH4lImvH1Sw/JPGaLsUdte3RXkcAALXgT+OwKOOhQ0I/4EzgeRE5st2WjCLSD7gJv3sXdxa+fZnD9uhIbFMk9Py8Kz0CjCi6Hp517Qfc6lmvl4COwpXOqWEGAL/BbvymIcEyzAlji6Lr4jD+7QF1mqTaBsfBkRtpD+zmcdre4APgYmDTouvSovGfJIk+UrjyBTTWAOB8wr1sa9Ni7Ph1gxLUpx/mUu+r+yJgePfvi65AgQ03GruCnpYECryHxUHyvohRsPE/xC7arsyjaEMUTIIO7CWS/7ZIhKXAldh7iXkaf0qAjsuAr6+ST9FGKEPCYgxfSPpJYldajo3F49rB+BUBVm3YXbGgFK2QoCs9CBxC5FBvwNrYaWaI8Q9rmF/RjV62hEUxOYZ0N4XrpdeAnxLhIil2MSRk3tLU+BUBmjd2f+A04sX9W4FFBjkKWCtQl7WA72Orj2jGrwjg1/gDgR9ioVxjEEGx+MB/wvYlGg4R2HtH5xIei9DL+KoluR7eDhCR9YAzsF4h5kHRAuBRbKiYn+S9GfYcn89zuT2xHJvwXe8jXBEgEEmk7+9gsXwHF6xOTwQZHyoCpIaIDAKOxXqEoQWrAxbA4khVvSXkRxUBWkTyrvH+2GXNcQWp0QkcpPaOYxAqAkRE8nze6Vi0k9CYf2kxCzhaVeek+XFFgAwgIhsDhwLfwO9t5TRYgp1D/EZVQ51eulERIGMkF1QnYUEvYqwePgCuwCKHt/4Wc0WAfCAiA7GI6cdgJ5GhQ8QTwI3AZWpX5OLoVREgfyQvp+6F3XPcClvvb46dTn6I7Q3MBZ4GngLuV9WXs9Dl/6nhK80mC1AyAAAAAElFTkSuQmCC'

const BsTelephoneInbound = 'data:image/png;base64,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'

let fullName = ''; 
let email = '';
let experiences = [];

let educations =  [];
    let skills =  [];
  // Default values for testing
  if (userProfile) {
    console.log("user profie:e", userProfile)
    fullName = userProfile.firstName +' '+ userProfile.lastName;

    email = userProfile.email;
    experiences = userProfile.experiences;
    educations = userProfile.educations;
    skills = userProfile.skills;
  }else{
    console.log("failed to load userProfile")
    fullName = "John doe"
    email = 'john.doe@example.com';
    experiences = [
    {
      company: 'Tech Corp',
      role: 'Software Engineer',
      startDate: '2018-01-01',
      endDate: 'Now',
      description: 'Developed web applications using modern frameworks.',
    },
    ];
    educations = [
      {
        institution: 'University of Technology',
        degree: 'B.Sc. Computer Science',
        startDate: '2014-09-01',
        endDate: '2017-06-30',
        description: 'Focused on software engineering and data structures.',
      },
    ];
    skills = [
      { name: 'JavaScript', value: 5 },
      { name: 'Svelte', value: 4 },
    { name: 'React', value: 4 },
    { name: 'Node.js', value: 4 },
  ];
  }
  let phone = '+1234567890';
  let linkedin = 'https://www.linkedin.com/in/johndoe/';
  let summary = 'Experienced professional with a background in software development.';
  let address = "Wroclaw, Burzowa 90/2a"
  let resumeName = '';


  // New skill template
  let newSkill = { skillName: '', proficiencyLevel: 1 };
  

    const MAX_FULL_NAME_LENGTH = 50;
    const MAX_EMAIL_LENGTH = 100;
    const MAX_PHONE_LENGTH = 20;
    const MAX_OVERVIEW_LENGTH = 500; 
    const MAX_COMPANY_NAME_LENGTH = 50;
    const MAX_ROLE_LENGTH = 50;
    const MAX_INSTITUTION_NAME_LENGTH = 50;
    const MAX_DEGREE_LENGTH = 50;
    const MAX_DESCRIPTION_LENGTH = 200;
    const MAX_EXPERIENCES = 4; 
    const MAX_EDUCATIONS = 3; 
    const MAX_LINK_LENGTH = 160;
    const MAX_ADDRESS_LENGHT = 80;
    const MAX_RESUME_NAME_LENGTH = 60
    const MAX_SKILLS = 10;


    const skillOptions = [1, 2, 3, 4, 5];
    let newExperience = { company: '', role: '', startDate: '', endDate: '', description: '' };
    let newEducation = { institution: '', degree: '', startDate: '', endDate: '', description: '' };
  
    let errors = {};
    let userImage = null;

    function handleImageUpload(event) {
    const file = event.target.files[0];
    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
        userImage = e.target.result;
        };
        reader.readAsDataURL(file);
    }
    }

    function validateEmail(email) {
      const regex = /^\S+@\S+\.\S+$/;
      return regex.test(email);
    }
  
    function validatePhone(phone) {
      return isValidPhoneNumber(phone)
    }


    function validateDates(startDate, endDate) {
        if (!startDate) return false;
        if (endDate === 'Now') return true;
        return new Date(startDate) <= new Date(endDate);
        
    }
  
    function addExperience() {
      errors = {};
  
      if (experiences.length >= MAX_EXPERIENCES) {
        errors.experienceLimit = `You can add up to ${MAX_EXPERIENCES} experiences.`;
        return;
      }
  
        if (!newExperience.current && !newExperience.endDate) {
        errors.endDate = 'End Date is required.';
        }

        if (newExperience.current) {
        newExperience.endDate = 'Now';
        }

        if (!validateDates(newExperience.startDate, newExperience.endDate)) {
        errors.date = 'Start Date should be before End Date.';
        }
      
      // Validate inputs
      if (!newExperience.company) errors.company = 'Company is required.';
      if (newExperience.company.length > MAX_COMPANY_NAME_LENGTH) errors.company = `Company name cannot exceed ${MAX_COMPANY_NAME_LENGTH} characters.`;
  
      if (!newExperience.role) errors.role = 'Role is required.';
      if (newExperience.role.length > MAX_ROLE_LENGTH) errors.role = `Role cannot exceed ${MAX_ROLE_LENGTH} characters.`;
  
      if (!newExperience.startDate) errors.startDate = 'Start Date is required.';
      if (!newExperience.endDate) errors.endDate = 'End Date is required.';
      if (!validateDates(newExperience.startDate, newExperience.endDate)) errors.date = 'Start Date should be before End Date.';
  
      if (newExperience.description.length > MAX_DESCRIPTION_LENGTH) errors.expDescription = `Description cannot exceed ${MAX_DESCRIPTION_LENGTH} characters.`;
  
      if (Object.keys(errors).length === 0) {
        experiences = [...experiences, { ...newExperience }];
        newExperience = { company: '', role: '', startDate: '', endDate: '', description: '' };
      }
    }
  
    function addEducation() {
      errors = {};
  
      if (educations.length >= MAX_EDUCATIONS) {
        errors.educationLimit = `You can add up to ${MAX_EDUCATIONS} educations.`;
        return;
      }
  
      if (!newEducation.institution) errors.institution = 'Institution is required.';
      if (newEducation.institution.length > MAX_INSTITUTION_NAME_LENGTH) errors.institution = `Institution name cannot exceed ${MAX_INSTITUTION_NAME_LENGTH} characters.`;
  
      if (!newEducation.degree) errors.degree = 'Degree is required.';
      if (newEducation.degree.length > MAX_DEGREE_LENGTH) errors.degree = `Degree cannot exceed ${MAX_DEGREE_LENGTH} characters.`;
  
      if (!newEducation.startDate) errors.eduStartDate = 'Start Date is required.';
      if (!newEducation.endDate) errors.eduEndDate = 'End Date is required.';
      if (!validateDates(newEducation.startDate, newEducation.endDate)) errors.eduDate = 'Start Date should be before End Date.';
  
      if (newEducation.description.length > MAX_DESCRIPTION_LENGTH) errors.eduDescription = `Description cannot exceed ${MAX_DESCRIPTION_LENGTH} characters.`;
  
      if (Object.keys(errors).length === 0) {
        educations = [...educations, { ...newEducation }];
        newEducation = { institution: '', degree: '', startDate: '', endDate: '', description: '' };
      }
    }
  
      // Function to add a new skill
  function addSkill() {
    if (skills.length >= MAX_SKILLS) {
      errors.skillLimit = `You can add up to ${MAX_SKILLS} skills.`;
      return;
    }

    errors = {};

    // Validate skill name
    if (!newSkill.skillName.trim()) {
      errors.skillName = 'Skill name is required.';
    } else if (newSkill.skillName.length > 30) {
      errors.skillName = 'Skill name cannot exceed 30 characters.';
    }

    // Validate proficiency value
    if (!skillOptions.includes(newSkill.proficiencyLevel)) {
      errors.skillValue = 'Skill value must be between 1 and 5.';
    }

    // If no errors, add the skill
    if (Object.keys(errors).length === 0) {
      skills = [...skills, { ...newSkill }];
      newSkill = { skillName: '', proficiencyLevel: 1 }; // Reset the newSkill object
    }
  }

  // Function to remove a skill by index
  function removeSkill(index) {
    skills = skills.filter((_, i) => i !== index);
    if (errors.skillLimit) {
      delete errors.skillLimit;
    }
  }


  async function  generatePDF2() {
    if (! verifyPDFheight()){
        alert('page is too long')
    }
    errors = {};
      if (linkedin.length > MAX_LINK_LENGTH) errors.linkedin = `LinkedIn link cannot exceed ${MAX_LINK_LENGTH} characters.`;

      // Validate personal information
      if (!fullName) errors.fullName = 'Full Name is required.';
      if (fullName.length > MAX_FULL_NAME_LENGTH) errors.fullName = `Full Name cannot exceed ${MAX_FULL_NAME_LENGTH} characters.`;
  
      if (!email || !validateEmail(email)) errors.email = 'Valid Email is required.';
      if (email.length > MAX_EMAIL_LENGTH) errors.email = `Email cannot exceed ${MAX_EMAIL_LENGTH} characters.`;
  
      if (!phone || !validatePhone(phone)) errors.phone = 'Valid Phone Number is required.';
      if (phone.length > MAX_PHONE_LENGTH) errors.phone = `Phone number cannot exceed ${MAX_PHONE_LENGTH} characters.`;
  
      if (summary.length > MAX_OVERVIEW_LENGTH) errors.summary = `Summary cannot exceed ${MAX_OVERVIEW_LENGTH} characters.`;
      if (Object.keys(errors).length !== 0){
        return
      }
        
      const doc = new jsPDF();
  
      const leftMargin = 20;
      let y = 20;
      const lineWidth = 170;

    if (userImage) {
      doc.addImage(userImage, 'JPEG', leftMargin + lineWidth - 55, 8, 35, 45);
    }
  

      doc.setFontSize(22);
      doc.setFont('helvetica', 'bold');
      doc.text(fullName, leftMargin, y);
      y += 6;
  
      doc.setLineWidth(0.5);
      doc.line(leftMargin, y, leftMargin + 90, y);
      y += 10;

      doc.setFontSize(12);
      doc.setFont('helvetica', 'normal');
      doc.text(`Email: ${email}`, leftMargin, y);
      y += 6;
      doc.text(`Phone: ${phone}`, leftMargin, y);
      if (address){
      y += 6;
      doc.text(`Address: ${address}`, leftMargin, y);
      }
      y += 6;
      doc.text(`LinkedIn: ${linkedin}`, leftMargin, y);
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
      const summaryLines = doc.splitTextToSize(summary, lineWidth);
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
      experiences.forEach(exp => {

        const maxEduTitleWidth = 140;
        const eduTitle = `${exp.role} at ${exp.company}`
        const eduTitleLines = doc.splitTextToSize(eduTitle, maxEduTitleWidth);
        doc.setFont('helvetica', 'bold')
        doc.text(eduTitleLines, leftMargin, y);
        doc.setFont('helvetica', 'italic');
        doc.text(`${exp.startDate} - ${exp.endDate}`, leftMargin + 120, y);
        y += eduTitleLines.length * 6;
        const expDescription = doc.splitTextToSize(exp.description, lineWidth);
        doc.setFont('helvetica', 'normal');
        doc.text(expDescription, leftMargin, y);
        y += expDescription.length * 6 + 4;

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
      educations.forEach(edu => {



        const eduTitle = `${edu.degree} - ${edu.institution}`;
        const maxEduTitleWidth = 140; // Maximum width for the title
        const eduTitleLines = doc.splitTextToSize(eduTitle, maxEduTitleWidth);
        doc.setFont('helvetica', 'bold');
        doc.text(eduTitleLines, leftMargin, y);
        doc.setFont('helvetica', 'italic');
        doc.text(`${edu.startDate} - ${edu.endDate}`, leftMargin + 120, y);
        y += eduTitleLines.length * 6; // Adjust y based on the number of lines
        const eduDescription = doc.splitTextToSize(edu.description, lineWidth);
        doc.setFont('helvetica', 'normal');
        doc.text(eduDescription, leftMargin, y);
        y += eduDescription.length * 6 + 4;

      });
  
      // Draw a horizontal line
      doc.line(leftMargin, y, leftMargin + lineWidth, y);
      y += 10;
  
      // Skills

      // doc.setFontSize(16);
      // doc.setFont('helvetica', 'bold');
      // doc.text('Skills', leftMargin, y);
      // y += 6;
      // doc.setFontSize(12);
      // doc.setFont('helvetica', 'normal');
      // const skillsLines = doc.splitTextToSize(skills, leftMargin + lineWidth);
      // doc.text(skillsLines, leftMargin, y);
      // y += skillsLines.length * 6 + 10;
   // Skills Section in PDF
   if (skills.length > 0) {
      doc.setFontSize(16);
      doc.setFont('helvetica', 'bold');
      doc.text('Skills', 20, y);
      y += 8;
      doc.setFontSize(12);
      doc.setFont('helvetica', 'normal');
      skills.forEach(skill => {
        doc.text(`${skill.skillName}`, 20, y);
        // Add proficiency level as filled and empty circles (stars)
        for (let i = 0; i < 5; i++) {
          if (i < skill.proficiencyLevel) {
            doc.setFillColor(255, 215, 0); // Gold color for filled stars
            doc.circle(80 + i * 5, y - 2, 2, 'F');
          } else {
            doc.setFillColor(200, 200, 200); // Grey color for empty stars
            doc.circle(80 + i * 5, y - 2, 2, 'F');
          }
        }
        y += 6;

      });
    }


      // Disclaimer
      doc.setFontSize(10);
      doc.setFont('helvetica', 'normal');
        doc.text(
        'I hereby give consent to the processing of my personal data for the purpose of conducting the recruitment process for the position I have applied for.',
        10,
        285,
        { maxWidth: 190 }
        );



        //send it to db

           // Generate the PDF as a Blob
       const pdfBlob = doc.output('blob');

        // Create a FormData object and append the PDF Blob
        const formData = new FormData();
        console.log("KAOSODASDIABSD")
    console.log()
    console.log($user.jwt)
        formData.append('resume', pdfBlob, `${resumeName}.pdf`); // 'file' is the key, 'CV.pdf' is the filename
      try {
        const response = await axios.post('http://localhost:8080/user-service/resume', formData, {
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': `Bearer ${localStorage.getItem('jwt')}`
            },
          }
      );

        // Handle successful response
        console.log('PDF uploaded successfully:', response.data);
        // You can provide user feedback here, e.g., a success message

        } catch (error) {
        // Handle errors
        console.error('Error uploading PDF:', error);
        // You can provide user feedback here, e.g., an error message
        }
      doc.save(`${resumeName}.pdf`);
    }

  function  verifyPDFheight() {
  errors = {};
    if (linkedin.length > MAX_LINK_LENGTH) errors.linkedin = `LinkedIn link cannot exceed ${MAX_LINK_LENGTH} characters.`;

    // Validate personal information
    if (!fullName) errors.fullName = 'Full Name is required.';
    if (fullName.length > MAX_FULL_NAME_LENGTH) errors.fullName = `Full Name cannot exceed ${MAX_FULL_NAME_LENGTH} characters.`;

    if (!email || !validateEmail(email)) errors.email = 'Valid Email is required.';
    if (email.length > MAX_EMAIL_LENGTH) errors.email = `Email cannot exceed ${MAX_EMAIL_LENGTH} characters.`;

    if (!phone || !validatePhone(phone)) errors.phone = 'Valid Phone Number is required.';
    if (phone.length > MAX_PHONE_LENGTH) errors.phone = `Phone number cannot exceed ${MAX_PHONE_LENGTH} characters.`;

    if (summary.length > MAX_OVERVIEW_LENGTH) errors.summary = `Summary cannot exceed ${MAX_OVERVIEW_LENGTH} characters.`;
    if (Object.keys(errors).length !== 0){
      return
    }
      
    const doc = new jsPDF();
    // console.log("testDOC",doc.getPageIngefo(), doc.getPageHeight())

    const leftMargin = 20;
    let y = 20;
    const lineWidth = 170;

  if (userImage) {
    doc.addImage(userImage, 'JPEG', leftMargin + lineWidth - 55, 8, 35, 45);
  }


    doc.setFontSize(22);
    doc.setFont('helvetica', 'bold');
    doc.text(fullName, leftMargin, y);
    y += 6;

    doc.setLineWidth(0.5);
    doc.line(leftMargin, y, leftMargin + 90, y);
    y += 10;

    doc.setFontSize(12);
    doc.setFont('helvetica', 'normal');
    doc.text(`Email: ${email}`, leftMargin, y);
    y += 6;
    doc.text(`Phone: ${phone}`, leftMargin, y);
    if (address){
    y += 6;
    doc.text(`Address: ${address}`, leftMargin, y);
    }
    y += 6;
    doc.text(`LinkedIn: ${linkedin}`, leftMargin, y);
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
    const summaryLines = doc.splitTextToSize(summary, lineWidth);
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
    experiences.forEach(exp => {

      const maxEduTitleWidth = 140;
      const eduTitle = `${exp.role} at ${exp.company}`
      const eduTitleLines = doc.splitTextToSize(eduTitle, maxEduTitleWidth);
      doc.setFont('helvetica', 'bold')
      doc.text(eduTitleLines, leftMargin, y);
      doc.setFont('helvetica', 'italic');
      doc.text(`${exp.startDate} - ${exp.endDate}`, leftMargin + 120, y);
      y += eduTitleLines.length * 6;
      const expDescription = doc.splitTextToSize(exp.description, lineWidth);
      doc.setFont('helvetica', 'normal');
      doc.text(expDescription, leftMargin, y);
      y += expDescription.length * 6 + 4;

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
    educations.forEach(edu => {



      const eduTitle = `${edu.degree} - ${edu.institution}`;
      const maxEduTitleWidth = 140; // Maximum width for the title
      const eduTitleLines = doc.splitTextToSize(eduTitle, maxEduTitleWidth);
      doc.setFont('helvetica', 'bold');
      doc.text(eduTitleLines, leftMargin, y);
      doc.setFont('helvetica', 'italic');
      doc.text(`${edu.startDate} - ${edu.endDate}`, leftMargin + 120, y);
      y += eduTitleLines.length * 6; // Adjust y based on the number of lines
      const eduDescription = doc.splitTextToSize(edu.description, lineWidth);
      doc.setFont('helvetica', 'normal');
      doc.text(eduDescription, leftMargin, y);
      y += eduDescription.length * 6 + 4;

    });

    // Draw a horizontal line
    doc.line(leftMargin, y, leftMargin + lineWidth, y);
    y += 10;

  if (skills.length > 0) {
    doc.setFontSize(16);
    doc.setFont('helvetica', 'bold');
    doc.text('Skills', 20, y);
    y += 8;
    doc.setFontSize(12);
    doc.setFont('helvetica', 'normal');
    skills.forEach(skill => {
      doc.text(`${skill.skillName}`, 20, y);
      // Add proficiency level as filled and empty circles (stars)
      for (let i = 0; i < 5; i++) {
        if (i < skill.proficiencyLevel) {
          doc.setFillColor(255, 215, 0); // Gold color for filled stars
          doc.circle(80 + i * 5, y - 2, 2, 'F');
        } else {
          doc.setFillColor(200, 200, 200); // Grey color for empty stars
          doc.circle(80 + i * 5, y - 2, 2, 'F');
        }
      }
      y += 6;

    });
  }


    doc.setFontSize(10);
    doc.setFont('helvetica', 'normal');
    doc.text(
      'I hereby give consent to the processing of my personal data for the purpose of conducting the recruitment process for the position I have applied for.',
      10,
      285,
      { maxWidth: 190 }
    );
    alert(y)
    if (y > 275){
      return false
    }

    return true
    
  }

    function removeExperience(index) {
    experiences = experiences.filter((_, i) => i !== index);
    if (errors.experienceLimit) {
      delete errors.experienceLimit;
    }
  }

  function removeEducation(index) {
    educations = educations.filter((_, i) => i !== index);
    if (errors.educationLimit) {
      delete errors.educationLimit;
    }
  }

  </script>
  
  <div class="cv-generator-container">
    <h2>CV Generator</h2>
    <form on:submit|preventDefault={generatePDF2}>
      <!-- Personal Information -->
      <section class="section">
        <div class="section">
          <label for="resumeName">Name this resume</label>
          <input id="resumeName" type="text" bind:value={resumeName} required minlength=1 maxlength={MAX_RESUME_NAME_LENGTH} />
        </div>
        <h3>Personal Information</h3>
        <div class="form-group">
          <label>Full Name *</label>
          <input type="text" bind:value={fullName} required maxlength={MAX_FULL_NAME_LENGTH} />
          {#if errors.fullName}
            <p class="error-message">{errors.fullName}</p>
          {/if}
        </div>
        <div class="section">
          <label for="address">Address</label>
          <input id="address" type="text" bind:value={address} maxlength={MAX_ADDRESS_LENGHT} />
        </div>

        <div class="form-group">
            <label>LinkedIn Profile (optional)</label>
            <input type="text" bind:value={linkedin} maxlength={MAX_LINK_LENGTH} />
            {#if errors.linkedin}
              <p class="error-message">{errors.linkedin}</p>
            {/if}
          </div>
          
        <div class="form-group">
          <label>Email *</label>
          <input type="email" bind:value={email} required maxlength={MAX_EMAIL_LENGTH} />
          {#if errors.email}
            <p class="error-message">{errors.email}</p>
          {/if}
        </div>
        <div class="form-group">
          <label>Phone *</label>
          <input type="tel" bind:value={phone} required maxlength={MAX_PHONE_LENGTH} />
          {#if errors.phone}
            <p class="error-message">{errors.phone}</p>
          {/if}
        </div>
        <div class="form-group">
          <label>Summary (max {MAX_OVERVIEW_LENGTH} characters)</label>
          <textarea bind:value={summary} rows="3" maxlength={MAX_OVERVIEW_LENGTH}></textarea>
          {#if errors.summary}
            <p class="error-message">{errors.summary}</p>
          {/if}
        </div>
        <div class="form-group">
            <label>Upload userImage</label>
            <input type="file" accept="image/*" on:change={handleImageUpload} />
        </div>
      </section>
  
      <!-- Experiences -->
      <section class="section">
        <h3>Experiences (up to {MAX_EXPERIENCES})</h3>
        {#if experiences.length > 0}
          {#each experiences as exp, index}
            <div class="item">
              <strong>{exp.role}</strong> at {exp.company} ({exp.startDate} - {exp.endDate})
              <p>{exp.description}</p>
              <button type="button" class="btn btn-danger btn-sm" on:click={() => removeExperience(index)}>Remove</button>
            </div>
          {/each}
        {/if}
        {#if errors.experienceLimit}
          <p class="error-message">{errors.experienceLimit}</p>
        {/if}
        <div class="form-row">
          <div class="form-group">
            <label>Company *</label>
            <input type="text" bind:value={newExperience.company} maxlength={MAX_COMPANY_NAME_LENGTH} />
            {#if errors.company}
              <p class="error-message">{errors.company}</p>
            {/if}
          </div>
          <div class="form-group">
            <label>Role *</label>
            <input type="text" bind:value={newExperience.role} maxlength={MAX_ROLE_LENGTH} />
            {#if errors.role}
              <p class="error-message">{errors.role}</p>
            {/if}
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label>Start Date *</label>
            <input type="date" bind:value={newExperience.startDate} />
            {#if errors.startDate}
              <p class="error-message">{errors.startDate}</p>
            {/if}
          </div>
          <div class="form-group">

            <label>End Date *</label>

            <input type="date" bind:value={newExperience.endDate} />
            {#if errors.endDate}
              <p class="error-message">{errors.endDate}</p>
            {/if}
            {#if errors.date}
              <p class="error-message">{errors.date}</p>
            {/if}
            <label>
                <input type="checkbox" bind:checked={newExperience.current} />
                Currently Working Here
              </label>
          </div>
        </div>
        <div class="form-group">
          <label>Description (max {MAX_DESCRIPTION_LENGTH} characters)</label>
          <textarea bind:value={newExperience.description} rows="2" maxlength={MAX_DESCRIPTION_LENGTH}></textarea>
          {#if errors.expDescription}
            <p class="error-message">{errors.expDescription}</p>
          {/if}
        </div>
        <button type="button" class="btn add-btn" on:click={addExperience}>Add Experience</button>
      </section>
  
      <!-- Educations -->
      <section class="section">
        <h3>Educations (up to {MAX_EDUCATIONS})</h3>
        {#if educations.length > 0}
          {#each educations as edu, index}
            <div class="item">
              <strong>{edu.degree}</strong> at {edu.institution} ({edu.startDate} - {edu.endDate})
              <p>{edu.description}</p>
              <button type="button" class="btn btn-danger btn-sm" on:click={() => removeEducation(index)}>Remove</button>
            </div>
          {/each}
        {/if}
        {#if errors.educationLimit}
          <p class="error-message">{errors.educationLimit}</p>
        {/if}
        <div class="form-row">
          <div class="form-group">
            <label>Institution *</label>
            <input type="text" bind:value={newEducation.institution} maxlength={MAX_INSTITUTION_NAME_LENGTH} />
            {#if errors.institution}
              <p class="error-message">{errors.institution}</p>
            {/if}
          </div>
          <div class="form-group">
            <label>Degree *</label>
            <input type="text" bind:value={newEducation.degree} maxlength={MAX_DEGREE_LENGTH} />
            {#if errors.degree}
              <p class="error-message">{errors.degree}</p>
            {/if}
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label>Start Date *</label>
            <input type="date" bind:value={newEducation.startDate} />
            {#if errors.eduStartDate}
              <p class="error-message">{errors.eduStartDate}</p>
            {/if}
          </div>
          <div class="form-group">
            <label>End Date *</label>
            <input type="date" bind:value={newEducation.endDate} />
            {#if errors.eduEndDate}
              <p class="error-message">{errors.eduEndDate}</p>
            {/if}
            {#if errors.eduDate}
              <p class="error-message">{errors.eduDate}</p>
            {/if}
          </div>
        </div>
        <div class="form-group">
          <label>Description (max {MAX_DESCRIPTION_LENGTH} characters)</label>
          <textarea bind:value={newEducation.description} rows="2" maxlength={MAX_DESCRIPTION_LENGTH}></textarea>
          {#if errors.eduDescription}
            <p class="error-message">{errors.eduDescription}</p>
          {/if}
        </div>
        <button type="button" class="btn add-btn" on:click={addEducation}>Add Education</button>
      </section>


      <!-- Skills Section -->
  <section class="section">
    <h3>Skills (up to {MAX_SKILLS})</h3>
    {#if skills.length > 0}
      <ul>
        {#each skills as skill, index}
          <li>
            {skill.skillName} - Level {skill.proficiencyLevel}
            <button type="button" on:click={() => removeSkill(index)} style="margin-left: 10px; background-color: #dc3545;">Remove</button>
          </li>
        {/each}
      </ul>
    {/if}
    {#if errors.skillLimit}
      <p class="error-message">{errors.skillLimit}</p>
    {/if}
    <div class="form-row">
      <div class="form-group">
        <label>Skill Name *</label>
        <input type="text" bind:value={newSkill.skillName} maxlength="30" />
        {#if errors.skillName}
          <p class="error-message">{errors.skillName}</p>
        {/if}
      </div>
      <div class="form-group">
        <label>Proficiency Level *</label>
        <select bind:value={newSkill.proficiencyLevel}>
          {#each skillOptions as option}
            <option value={option}>{option}</option>
          {/each}
        </select>
        {#if errors.skillValue}
          <p class="error-message">{errors.skillValue}</p>
        {/if}
      </div>
    </div>
    <button type="button" class="btn add-btn" on:click={addSkill}>Add Skill</button>
  </section>
  
      <!-- Submit Button -->
      <button type="submit" class="generate-btn">Generate PDF</button>
      {#if errors.pageLimit}
        <p class="error-message">{errors.pageLimit}</p>
      {/if}
    </form>
  </div>
  
  <style>



    .cv-generator-container {
      max-width: 800px;
      margin: 0 auto;
    }
  
    h2 {
      text-align: center;
      margin-bottom: 2rem;
    }
  
    .section {
      margin-bottom: 2rem;
    }
  
    h3 {
      margin-bottom: 1rem;
      color: #333;
      border-bottom: 1px solid #ddd;
      padding-bottom: 0.5rem;
    }
  
    .form-group {
      margin-bottom: 1rem;
    }
  
    label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: bold;
    }
  
    input[type="text"],
    input[type="email"],
    input[type="tel"],
    input[type="date"],
    textarea {
      width: 100%;
      padding: 0.5rem;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
  
    .form-row {
      display: flex;
      flex-wrap: wrap;
      gap: 1rem;
    }
  
    .form-row .form-group {
      flex: 1;
    }
  
    textarea {
      resize: vertical;
      margin-bottom: 1rem;
    }
  
    .item {
      background-color: #f9f9f9;
      padding: 1rem;
      border-radius: 5px;
      margin-bottom: 0.5rem;
    }
  
    .item strong {
      font-size: 1.1rem;
      color: #007bff;
    }
  
    .generate-btn,
    .add-btn {
      background-color: #28a745;
      color: #fff;
      padding: 0.75rem 1.5rem;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 1rem;
      margin-top: 1rem;
    }
  
    .generate-btn {
      display: block;
      margin: 0 auto;
    }
  
    .error-message {
      color: #dc3545;
      font-size: 0.9rem;
      margin-top: 0.25rem;
    }



    .section ul {
    list-style-type: none;
    padding-left: 0;
  }

  .section ul li {
    margin-bottom: 0.5rem;
    display: flex;
    align-items: center;
  }

  .section ul li button {
    margin-left: auto;
    background-color: #dc3545;
    color: #fff;
    border: none;
    padding: 0.25rem 0.5rem;
    border-radius: 3px;
    cursor: pointer;
  }

  .section ul li button:hover {
    background-color: #c82333;
  }

  /* Responsive adjustments */
  @media (max-width: 600px) {
    .form-row {
      flex-direction: column;
    }
  }














  </style>
  