<template>
<div class="login-container">
  <div class="profile-container">
    <h1>User Profile</h1>
    <form @submit.prevent="updateUserProfile">
      <div class="form-group">
        <label for="name">Name</label>
        <input v-model="user.name" type="text" id="name" required />
      </div>
      <div class="form-group">
        <label for="surname">Surname</label>
        <input v-model="user.surname" type="text" id="surname" required />
      </div>
      <div class="form-group">
        <label for="email">Email</label>
        <input v-model="user.email" type="email" id="email" required />
      </div>
      <div class="form-group">
        <label for="username">Username</label>
        <input v-model="user.username" type="text" id="username" required />
      </div>
      <div class="form-group">
        <label for="profilePicture">Profile Picture URL</label>
        <input v-model="user.profilePicture" type="text" id="profilePicture" />
      </div>
      <div class="form-group">
        <img :src="user.profilePicture" alt="Profile Picture" v-if="user.profilePicture" />
      </div>
      <button type="submit">Update Profile</button>
    </form>
  </div>
    </div>
</template>

<script>
import { db, auth } from "@/firebase";

export default {
  data() {
    return {
      user: {
        name: '',
        surname: '',
        email: '',
        username: '',
        profilePicture: ''
      }
    };
  },
  created() {
    this.getUserProfile();
  },
  methods: {
    getUserProfile() {
      const currentUser = auth.currentUser;
      if (currentUser) {
        db.collection('users').doc(currentUser.email).get().then(doc => {
          if (doc.exists) {
            this.user = doc.data();
          } else {
            console.error("No user data found!");
          }
        }).catch(error => {
          console.error("Error getting user profile: ", error);
        });
      }
    },
    updateUserProfile() {
      const currentUser = auth.currentUser;
      if (currentUser) {
        db.collection('users').doc(currentUser.email).update({
          name: this.user.name,
          surname: this.user.surname,
          email: this.user.email,
          username: this.user.username,
          profilePicture: this.user.profilePicture
        }).then(() => {
          console.log("User profile updated successfully");
          // Možete dodati preusmjeravanje nakon uspješnog ažuriranja
        }).catch(error => {
          console.error("Error updating user profile: ", error);
        });
      }
    }
  }
};
</script>

<style>
.profile-container {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background-color: #f9f9f9;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
}

.form-group input {
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
}

button {
  padding: 10px 15px;
  background-color: #007bff;
  border: none;
  color: white;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background-color: #0056b3;
}
</style>