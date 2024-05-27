<template>
  <div class="login-container">
   <div class="row">
    <div class="col-1"></div>
    <div class="col-10">
      <form @submit.prevent="postNewImage" class="form-inline mb-5">
 <div class="form-group">
 <label for="imageUrl">Image URL</label>
 <input
 v-model="newImageUrl"
type="text"
class="form-control ml-2"
placeholder="Enter the image URL"
id="imageUrl"
 />
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
 <button type="submit" class="btn btn-primary ml-2">Post
image</button>
 </form>
     <sunset-moments-card v-for="card in filteredCards"  :key="card.url" :info="card"/>
     <sunset-moments-card/>
    </div>
    <div class="col-1">... ovo je 3. stupac!</div>
  </div>
  </div>
</template>

<script>
// @ is an alias to /src
import SunsetMomentsCard from "@/components/SunsetMomentsCard.vue";
import store from '@/store';

let cards = [];

cards = [
 { url: require('@/assets/images/sunset1.jpg'), description: 'evening sunset', time: 'few minutes ago...'},
 { url: require('@/assets/images/sunset2.jpg'), description: 'nature sunset', time: 'hour ago...'},
 { url: require('@/assets/images/sunset3.jpg'), description: 'mountain sunset', time: 'few hours ago...'},
 { url: require('@/assets/images/sunset4.jpg'), description: 'relax moments', time: '9 hours ago...'},
];



export default {
  name: 'home',
  data: function(){
    return{
          cards:cards,
          store:store,
    };
  },


computed: {
    filteredCards() {
      let termin=this.store.searchTerm;
    return this.cards.filter(card => card.description.indexOf(termin)>=0);
    },
  },


  components: {
    SunsetMomentsCard: SunsetMomentsCard,
  },
};
</script>

