<template>
  <div>
    <!-- Pretraživač za slike po opisu -->
    <div class="login-container">
    <div class="about space-at-bottom">
      <h1>Pretraži slike</h1>
      <input v-model="opisSlike" /> <button @click="pretraziSlikePoOpisu()">Pretraži</button>
      <div v-if="rezultatiPretrageSlika.length === 0">
        <p>Nema rezultata za traženi opis slike.</p>
      </div>
      <div v-else>
        <div v-for="slika in rezultatiPretrageSlika" :key="slika.id">
          <img :src="slika.url" :alt="slika.description" style="max-width: 500px; max-height: 700px;">
          <p>{{ slika.description }}</p>
        </div>
      </div>
    </div>
    </div>
    

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
            @add-comment="addCommentToDatabase"
          />
        </div>
        <div class="col-1"></div>
      </div>

<!-- Pretraživač za korisnike -->
      <div class="about space-at-bottom">
        <h1>Pretraži druge korisnike</h1>
        <input v-model="pojam" /> 
        <button @click="pretrazi()">Pretraži</button>
        <div v-for="user in rezultatiPretrage" :key="user.id">
          {{ user.username }}
          <!-- Dodani dio za prikaz znaka "+" ili "-" -->
          <button @click="zapratiOtprati(user.username)">
            {{ isPracen(user.username) ? '-' : '+' }}
          </button>
        </div>
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
      opisSlike: "",
      rezultatiPretrage: [],
      rezultatiPretrageSlika: []
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
              comments: [],
            }).then(() => {
              console.log("Slika je uspješno objavljena");
              this.newImageDescription = "";
              this.imageReference.remove();
              this.getPosts(); // Osvježi prikaz slika nakon dodavanja nove slike
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
            comments: data.comments || [] // Učitavamo komentare
          });
        });
        
      }).catch((error) => {
        console.error("Greška prilikom dobijanja postova:", error);
      });
    },
      // Metoda za pretraživanje slika po opisu
      pretraziSlikePoOpisu() {
      console.log("Pretražujem slike po opisu: " + this.opisSlike);

      this.rezultatiPretrageSlika = [];
        
      db.collection("posts").where("description", "==", this.opisSlike).get().then(snapshot => {
        snapshot.forEach(doc => {
          this.rezultatiPretrageSlika.push({ ...doc.data(), id: doc.id });
        });
      }).catch(error => {
        console.error("Greška prilikom pretraživanja slika po opisu:", error);
      });
    },
    // Metoda za dodavanje komentara
    addCommentToDatabase(postId, commentText) {
      db.collection("posts").doc(postId).update({
        comments: firebase.firestore.FieldValue.arrayUnion({
          user: store.currentUser,
          text: commentText,
          timestamp: Date.now()
        })
      }).then(() => {
        console.log("Komentar uspješno dodan");
        this.getPosts(); // Osvježiti prikaz slike ili komentara nakon dodavanja komentara
      }).catch((error) => {
        console.error("Greška prilikom dodavanja komentara:", error);
      });
    },

    // Metoda za prikazivanje komentara
    getComments(postId) {
      db.collection("posts").doc(postId).get().then((doc) => {
        if (doc.exists) {
          const postData = doc.data();
          const comments = postData.comments || [];
          console.log("Comments:", comments);
          // logika za prikazivanje komentara na sučelju
        } else {
          console.error("Ne postoji slika s ID-om:", postId);
        }
      }).catch((error) => {
        console.error("Greška prilikom dobijanja komentara:", error);
      });
    },

    // Metoda za provjeru je li korisnik već praćen
    isPracen(username) {
      return this.followers.includes(username);
    },
    
    // Metoda za praćenje ili otpraćenje korisnika
    zapratiOtprati(username) {
      console.log("Želim pratiti/otpratiti", username);
      console.log("A ja jesam", store.currentUser);

      if (username === store.currentUser) {
        return;
      }

      if (this.isPracen(username)) {
        // Ako je korisnik već praćen, otprati ga
        this.otprati(username);
      } else {
        // Inače, zaprati ga
        this.zaprati(username);
      }
    },

    // Metoda za praćenje korisnika
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
    },

    // Metoda za otpraćivanje korisnika
    otprati(username) {
      console.log("Želim otpratiti", username);
      console.log("A ja jesam", store.currentUser);

      if (username === store.currentUser) {
        return;
      }

      // Uklanjanje pratitelja
      db.collection('users').doc(store.currentUser).update({
        followers: firebase.firestore.FieldValue.arrayRemove(username)
      }).then(() => {
        console.log("Uspješno uklonjen pratitelj");
        this.getFollowers(); // Ažuriranje popisa pratitelja nakon uklanjanja pratitelja
      }).catch(error => {
        console.error("Greška prilikom ažuriranja dokumenta: ", error);
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
        console.error("Greška prilikom dobijanja pratioca:", error);
      });
    },
    
    pretrazi() {
      console.log("Tražim " + this.pojam);

      this.rezultatiPretrage = [];

      db.collection('users').where("username", "==", this.pojam).get().then(snapshot => {
        snapshot.forEach(doc => {
          this.rezultatiPretrage.push({ ...doc.data(), id: doc.id });
        });
      }).catch(error => {
        console.error("Error fetching users:", error);
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

<style>
/* Stilizacija za login-container */
.login-container {
  margin-top: 20px;
}

/* Stilizacija za formu */
.form-group {
  margin-bottom: 20px;
}

/* Stilizacija za input polje */
.form-control {
  width: 100%;
  max-width: 100%;
  padding: 10px;
  box-sizing: border-box;
}

/* Stilizacija za opis slike */
#imageDescription {
  width: 500%;
}

/* Stilizacija za dugme */
.btn-primary {
  background-color: #007bff;
  border-color: #007bff;
}

.btn-primary:hover {
  background-color: #0056b3;
  border-color: #0056b3;
}

/* Stilizacija za pretraživanje korisnika */
.about {
  margin-top: 50px;
}

.about h1 {
  margin-bottom: 20px;
}

.about input {
  margin-bottom: 10px;
}

.about button {
  background-color: #007bff;
  border-color: #007bff;
  color: #fff;
  padding: 5px 15px;
  border-radius: 5px;
}

.about button:hover {
  background-color: #0056b3;
  border-color: #0056b3;
}

/* Prostor između dodaj korisnika i dna stranice */
.space-at-bottom {
  margin-bottom: 120px; /* Promijeni vrijednost prema potrebi */
}
</style>