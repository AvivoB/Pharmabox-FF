// useAuth.ts
import { useState, useEffect } from 'react';
import {
  User as FirebaseUser,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signOut,
  onAuthStateChanged,
  signInWithPopup,
  GoogleAuthProvider,
  OAuthProvider,
} from 'firebase/auth';
import { auth, db } from '@/common/firebase';
import { doc, getDoc } from 'firebase/firestore';

// Type étendu qui hérite de FirebaseUser et ajoute les propriétés de Firestore
export type User = FirebaseUser & {
  // Champs Firestore
  id?: string;
  nom?: string;
  prenom?: string;
  reseau?: string[];
  pharmacyId?: string;
  poste?: string;
  photoUrl?: string;
  aficher_email?: boolean;
  aficher_tel?: boolean;
  city?: string;
  country?: string;
  date_naissance?: string;
  displayName?: string;
  email?: string;
  experiences?: {
    annee_debut: string;
    annee_fin: string;
    nom_pharmacie: string;
  }[];
  isComplete?: boolean;
  isVerified?: boolean;
  isValid?: boolean;
  langues?: {
    name: string;
    niveau: string;
  }[];
  lgo: {image: string; name: string, niveau: string}[];
  presentation?: string;
  telephone?: string;

  firestoreDataLoaded?: boolean;
};

// État de l'utilisateur courant
export const useAuthState = () => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (firebaseUser) => {
      console.log('Auth state changed:', firebaseUser?.uid);
      
      // Si l'utilisateur est connecté, récupérer ses données supplémentaires
      if (firebaseUser) {
        try {
          const userDocRef = doc(db, 'users', firebaseUser.uid);
          const userDoc = await getDoc(userDocRef);
          
          if (userDoc.exists()) {
            const firestoreData = userDoc.data();
            
            // Créer un utilisateur étendu qui combine FirebaseUser et les données Firestore
            // D'abord, on clone l'objet FirebaseUser
            const extendedUser = Object.assign({}, firebaseUser) as User;
            
            // Puis on ajoute les données Firestore à l'objet User
            Object.keys(firestoreData).forEach(key => {
              extendedUser[key] = firestoreData[key];
            });
            
            // Ajouter l'ID et marquer que les données Firestore sont chargées
            extendedUser.id = userDoc.id;
            extendedUser.firestoreDataLoaded = true;
            
            setUser(extendedUser);
            // console.log('User data loaded from Firestore:', firestoreData);
          } else {
            console.log('User document does not exist in Firestore for uid:', firebaseUser.uid);
            // Utiliser uniquement les données Firebase Auth si aucune donnée Firestore n'existe
            setUser(Object.assign({}, firebaseUser, { firestoreDataLoaded: false }) as User);
          }
        } catch (error) {
          console.error('Error fetching user data from Firestore:', error);
          // En cas d'erreur, utiliser uniquement les données Firebase Auth
          setUser(Object.assign({}, firebaseUser, { firestoreDataLoaded: false }) as User);
        }
      } else {
        // Aucun utilisateur authentifié
        setUser(null);
      }
      
      setLoading(false);
    });
    
    return () => unsubscribe();
  }, []);

  return { user, loading };
};

// Connexion avec Email
export const signInWithEmail = async (email: string, password: string) => {
 signInWithEmailAndPassword(auth, email, password).then((userCredential) => {
    const user = userCredential.user;
    console.log(user);
  }).catch((error) => {
   console.log(error);
 });
  
};

// Inscription avec Email
export const signUpWithEmail = async (email: string, password: string) => {
  await createUserWithEmailAndPassword(auth, email, password);
};

// Connexion avec Google
export const signInWithGoogle = async () => {
  const provider = new GoogleAuthProvider();
  await signInWithPopup(auth, provider);
};

// Connexion avec Apple
export const signInWithApple = async () => {
  const provider = new OAuthProvider('apple.com');
  provider.addScope('email');
  provider.addScope('name');
  await signInWithPopup(auth, provider);
};

// Déconnexion
export const logout = async () => {
  await signOut(auth);
};

// Export par défaut pour simplifier l'importation
export const useAuth = useAuthState;
