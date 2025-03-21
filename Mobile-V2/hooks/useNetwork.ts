import { useState, useEffect } from 'react';
import { collection, query, where, getDocs } from 'firebase/firestore';
import { db } from '../common/firebase';
import { useAuth, useAuthState } from './auth/useAuth';

export const useNetwork = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const {user} = useAuthState();

  useEffect(() => {
    const fetchNetworkUsers = async () => {
      if (!user) return;
      
      try {
        setLoading(true);
        const usersRef = collection(db, 'users');
        
        const q = query(usersRef, where('reseau', 'array-contains', user.id));
        const querySnapshot = await getDocs(q);

        const networkUsers = querySnapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data()
        }));
        
        setUsers(networkUsers);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchNetworkUsers();
  }, [user]);

  return { users, loading, error };
};