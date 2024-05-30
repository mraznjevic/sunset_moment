import firebase from 'firebase/app';
import 'firebase/auth';
import 'firebase/firestore';
import 'firebase/storage'; 


const firebaseConfig = {
  apiKey: "AIzaSyDcoOIW_zmtPUnXHOnGZFd9xxQ84iscLOk",
  authDomain: "sunset-moments.firebaseapp.com",
  projectId: "sunset-moments",
  storageBucket: "sunset-moments.appspot.com",
  messagingSenderId: "95011226195",
  appId: "1:95011226195:web:293573c57230440bb67ca6"
};

// Initialize Firebase
if (!firebase.apps.length) {
    firebase.initializeApp(firebaseConfig);
  }
  
  let db = firebase.firestore();
  let storage = firebase.storage();
  
  export { firebase, db, storage };
 
