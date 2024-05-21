import firebase from 'firebase/app';
import 'firebase/auth';
import 'firebase/firestore';


const firebaseConfig = {
    apiKey: "AIzaSyBZX1PZ6b7sij6iallV-ltH4g-bun3pPpU",
    authDomain: "fipugram-9b333.firebaseapp.com",
    projectId: "fipugram-9b333",
    storageBucket: "fipugram-9b333.appspot.com",
    messagingSenderId: "792296263962",
    appId: "1:792296263962:web:67cc3f4bd703e11ca59ca3"
  };

  // Initialize Firebase
 firebase.initializeApp(firebaseConfig);

 let db = firebase.firestore();

 export { firebase, db };
