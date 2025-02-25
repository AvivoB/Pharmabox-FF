// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAuth } from 'firebase/auth';
import { getFirestore } from "firebase/firestore";

// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyA6laCV1zRCRRtmMcqkAMDw4BgiUKyafEk",
  authDomain: "pharmaff-dab40.firebaseapp.com",
  projectId: "pharmaff-dab40",
  storageBucket: "pharmaff-dab40.appspot.com",
  messagingSenderId: "402993811587",
  appId: "1:402993811587:web:c4fa029898bf120d2b0bb6",
  measurementId: "G-1FG0KGYDBP"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const db = getFirestore(app);