import { useState, useEffect } from 'react';
import { collection, query, orderBy, limit, startAfter, getDocs, getCountFromServer, where } from 'firebase/firestore';
import { db } from '@/common/firebase';
import { useUsers } from './useUsers';
import { useAuthState } from './auth/useAuth';
import { getUserById } from './useUsers';

const PAGE_SIZE = 10;

export const usePharmablabla = () => {
  const [data, setData] = useState<any[]>([]);
  const [lastDoc, setLastDoc] = useState<any>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [hasMore, setHasMore] = useState<boolean>(true);
  const [error, setError] = useState<Error | null>(null);
  const { getUserById, usersCache } = useUsers();
const { user, loadingAuth } = useAuthState();

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
      
      // Récupérer les informations utilisateur et les commentaires pour chaque post
      const docsWithUserPromises = docs.map(async (post) => {
        let userData = null;
        
        if (post.userId) {
          userData = await getUserById(post.userId);
        }
        
        // Récupérer le nombre de commentaires
        const commentsRef = collection(db, 'pharmablabla', post.id, 'comments');
        const commentsSnapshot = await getCountFromServer(commentsRef);
        const commentsCount = commentsSnapshot.data().count;
        
        // Récupérer les commentaires
        const commentsQuery = query(commentsRef, orderBy('timestamp', 'desc'));
        const commentsQuerySnapshot = await getDocs(commentsQuery);
        
        // Préparer les commentaires avec les données utilisateur
        const commentsWithUserPromises = commentsQuerySnapshot.docs.map(async (commentDoc) => {
          const commentData = {
            id: commentDoc.id,
            ...commentDoc.data()
          };
          
          if (commentData.fromId) {
            const commentUserData = await getUserById(commentData.fromId);
            return {
              ...commentData,
              user: commentUserData
            };
          }
          
          return commentData;
        });
        
        const commentsData = await Promise.all(commentsWithUserPromises);
        
        // Récupérer les likes depuis la collection principale "likes"
        const likesRef = collection(db, 'likes');
        const likesQuery = query(likesRef, where("document_id", "==", post.id));
        const likesSnapshot = await getDocs(likesQuery);
        const likesCount = likesSnapshot.size;
        const likesQuerySnapshot = await getDocs(likesQuery);
        
        const likesData = likesQuerySnapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data()
        }));
        
        return {
          ...post,
          user: userData,
          likes: likesCount.toString(), // Utilise le nombre de likes de la sous-collection
          likesData: likesData, // Ajoute les données complètes des likes
          comments: commentsCount.toString(),
          commentsData: commentsData,
          isLikedByMe: likesData.some(like => like?.liked_by === user.uid) // Vérifie si l'utilisateur actuel a déjà liké le post
        };
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