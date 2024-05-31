<template>
  <div>
    <div class="login-container">
      <div class="row">
        <div class="col-1"></div>
        <div class="col-10">
          <form @submit.prevent="postNewImage" class="mb-5">
            <div class="form-group">
              <croppa
                :width="400"
                :height="400"
                placeholder="Učitaj sliku..."
                v-model="imageReference"
              ></croppa>
            </div>
            <div class="form-group">
              <label for="imageDescription">Description</label>
              <input
                v-model="newImageDescription"
                type="text"
                class="form-control ml-2"
                placeholder="Enter the image description"
                id="imageDescription"
              />
            </div>
            <button type="submit" class="btn btn-primary ml-2">Post image</button>
          </form>
          <sunset-moments-card
            v-for="card in filteredCards"
            :key="card.id"
            :info="card"
          />
        </div>
        <div class="col-1"></div>
      </div>
    </div>
    <div class="about">
      <h1>Pretraga</h1>
      <input v-model="pojam" /> <button @click="pretrazi()">Pretraga</button>
      <div v-for="user in rezultatiPretrage" :key="user.id">
        {{ user.username }}
        <button @click="zaprati(user.username)">+</button>
      </div>
    </div>
  </div>
</template>

<script>
import SunsetMomentsCard from "@/components/SunsetMomentsCard.vue";
import { db, storage } from "@/firebase";
import store from '@/store';
import firebase from 'firebase/app';

//cards = [
// {url: require("@/assets/images/sunset1.jpg"),description: "evening sunset",time: "few minutes ago...",},
// {url: require("@/assets/images/sunset2.jpg"),description: "nature sunset",time: "hour ago...",},
//{url: require("@/assets/images/sunset3.jpg"),description: "mountain sunset",time: "few hours ago...",},
// {url: require("@/assets/images/sunset4.jpg"),description: "relax moments",time: "9 hours ago...",},
//];


export default {
  data() {
    return {
      imageReference: null,
      newImageDescription: "",
      cards: [],
      followers: [],
      pojam: "",
      rezultatiPretrage: [],
    };
  },
  mounted() {
    this.getPosts();
    this.getFollowers();
  },
  methods: {
    postNewImage() {
      if (!this.imageReference || !this.newImageDescription) return;

      this.imageReference.generateBlob((blobData) => {
        const imageName = "posts/" + store.currentUser + "/" + Date.now() + ".png";

        storage.ref(imageName).put(blobData).then((result) => {
          result.ref.getDownloadURL().then((url) => {
            const imageDescription = this.newImageDescription;

            db.collection("posts").add({
              url: url,
              description: imageDescription,
              email: store.currentUser,
              posted_at: Date.now(),
            }).then(() => {
              console.log("Slika je uspješno objavljena");
              this.newImageDescription = "";
              this.imageReference.remove();
              this.getPosts(); // Osveži prikaz slika nakon dodavanja nove slike
            }).catch((error) => {
              console.error("Greška prilikom dodavanja slike:", error);
            });
          }).catch((error) => {
            console.error("Greška prilikom dobijanja URL-a slike:", error);
          });
        }).catch((error) => {
          console.error("Greška prilikom otpremanja slike:", error);
        });
      });
    },
    getPosts() {
      db.collection("posts").orderBy("posted_at", "desc").limit(10).get().then((querySnapshot) => {
        this.cards = [];
        querySnapshot.forEach((doc) => {
          const data = doc.data();
          this.cards.push({
            id: doc.id,
            time: data.posted_at,
            description: data.description,
            url: data.url,
          });
        });
      }).catch((error) => {
        console.error("Greška prilikom dobijanja postova:", error);
      });
    },
    getFollowers() {
      db.collection("users").doc(store.currentUser).get().then((doc) => {
        if (doc.exists) {
          const userData = doc.data();
          if (userData.followers && Array.isArray(userData.followers)) {
            this.followers = userData.followers;
          }
        }
      }).catch((error) => {
        console.error("Greška prilikom dobijanja pratilaca:", error);
      });
    },
    
    pretrazi() {
      console.log("Tražim " + this.pojam);

     this.rezultatiPretrage = [
        //{username:"anarakic@gmail.com"},
        //{username: "sanjababic@gmail.com"}
      ];

      db.collection('users').where("username", "==", this.pojam).get().then(snapshot => {
        snapshot.forEach(doc => {
          this.rezultatiPretrage.push({ ...doc.data(), id: doc.id });
        });
      }).catch(error => {
        console.error("Error fetching users:", error);
      });
      
    },
zaprati(username) {
      console.log("Želim pratiti", username);
      console.log("A ja jesam", store.currentUser);
      
      if (username === store.currentUser) {
        return;
      }

      // Dodavanje pratitelja
      db.collection('users').doc(store.currentUser).update({
        followers: firebase.firestore.FieldValue.arrayUnion(username)
      }).then(() => {
        console.log("Uspješno dodan pratitelj");
        this.getFollowers(); // Ažuriranje popisa pratitelja nakon dodavanja novog pratitelja
      }).catch(error => {
        console.error("Greška prilikom ažuriranja dokumenta: ", error);
      });
    }
  },
  computed: {
    filteredCards() {
      return this.cards;
    },
  },
  components: {
    SunsetMomentsCard,
  },
};
</script>
