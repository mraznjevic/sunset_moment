<template>
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
        <sunset-moments-card v-for="card in filteredCards" :key="card.id" :info="card"/>
      </div>
      <div class="col-1">... ovo je 3. stupac!</div>
    </div>
  </div>
</template>

<script>
import SunsetMomentsCard from "@/components/SunsetMomentsCard.vue";
import store from '@/store';
import { db } from "@/firebase";

export default {
  name: "home",
  data() {
    return {
      cards: [],
      store: store,
      newImageUrl: "", // url nove slike
      newImageDescription: "", // opis nove slike
      imageReference: null,
    };
  },
  mounted() {
    this.getPosts();
  },
  methods: {
    getPosts() {
      console.log("firebase dohvat...");
      db.collection("posts")
        .orderBy("posted_at", "desc")
        .limit(10)
        .get()
        .then((query) => {
          this.cards = [];
          query.forEach((doc) => {
            const data = doc.data();
            this.cards.push({
              id: doc.id,
              time: data.posted_at,
              description: data.description,
              url: data.url,
            });
          });
        });
    },
    postNewImage() {
      const imageUrl = this.newImageUrl;
      const imageDescription = this.newImageDescription;
      
      db.collection("posts")
        .add({
          url: imageUrl,
          description: imageDescription,
          email: store.currentUser,
          posted_at: Date.now(),
        })
        .then((doc) => {
          console.log("Spremljeno", doc);
          this.newImageDescription = "";
          this.newImageUrl = "";
          this.getPosts();
        })
        .catch((e) => {
          console.error(e);
        });
    },
  },
  computed: {
    filteredCards() {
      let termin = this.store.searchTerm;
      return this.cards.filter((card) => card.description.indexOf(termin) >= 0);
    },
  },
  components: {
    SunsetMomentsCard,
  },
};
</script>
