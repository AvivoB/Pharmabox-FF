import { useState, useEffect } from 'react';
import { collection, query, orderBy, limit, startAfter, getDocs } from 'firebase/firestore';
import { db } from '@/common/firebase';
import { useUsers } from './useUsers';

const PAGE_SIZE = 10;

export const usePharmablabla = () => {
  const [data, setData] = useState<any[]>([]);
  const [lastDoc, setLastDoc] = useState<any>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [hasMore, setHasMore] = useState<boolean>(true);
  const [error, setError] = useState<Error | null>(null);
  const { getUserById, usersCache } = useUsers();

  const fetchData = async () => {
    if (loading) return;
    
    setLoading(true);
    
    try {
      let q;
      
      if (lastDoc) {
        q = query(
          collection(db, 'pharmablabla'),
          orderBy('date_created', 'desc'),
          startAfter(lastDoc),
          limit(PAGE_SIZE)
        );
      } else {
        q = query(
          collection(db, 'pharmablabla'),
          orderBy('date_created', 'desc'),
          limit(PAGE_SIZE)
        );
      }
      
      const querySnapshot = await getDocs(q);

      const docs = querySnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data()
      }));
      
      // Récupérer les informations utilisateur pour chaque post
      const docsWithUserPromises = docs.map(async (post) => {
        if (post.userId) {
          const userData = await getUserById(post.userId);
          return {
            ...post,
            user: userData,
            likes: '0',
            comments: '0'
          };
        }
        return post;
      });
      
      const docsWithUsers = await Promise.all(docsWithUserPromises);
      
      setData((prev) => [...prev, ...docsWithUsers]);
      
      if (querySnapshot.docs.length < PAGE_SIZE) {
        setHasMore(false);
      } else {
        setLastDoc(querySnapshot.docs[querySnapshot.docs.length - 1]);
      }
    } catch (err) {
      setError(err instanceof Error ? err : new Error(String(err)));
      console.error("Error fetching pharmablabla data:", err);
    } finally {
      setLoading(false);
    }
  };

  // Charger les premières données au montage du composant
  useEffect(() => {
    fetchData();
  }, []);

  // Fonction pour rafraîchir les données depuis le début
  const refreshData = async () => {
    setData([]);
    setLastDoc(null);
    setHasMore(true);
    await fetchData();
  };

  return { 
    data, 
    loading, 
    hasMore, 
    error, 
    fetchData,
    refreshData 
  };
};