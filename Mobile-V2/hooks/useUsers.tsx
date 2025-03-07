import { useCallback, useEffect, useState } from 'react';
import { collection, doc, getDoc, getDocs, limit, query, startAfter } from 'firebase/firestore';
import { db } from '@/common/firebase';

export const useUsers = () => {
  const [usersCache, setUsersCache] = useState<Record<string, any>>({});
  const [users, setUsers] = useState<any[]>([]);
  const [lastDoc, setLastDoc] = useState<any>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [hasMore, setHasMore] = useState<boolean>(true);
  const [error, setError] = useState<Error | null>(null);
  const pageSize = 10;

  // Fonction pour récupérer un utilisateur par ID (avec mise en cache)
  const getUserById = useCallback(async (userId: string) => {
    if (usersCache[userId]) return usersCache[userId];

    setLoading(true);
    setError(null);

    try {
      const userDocRef = doc(db, 'users', userId);
      const userDoc = await getDoc(userDocRef);

      if (!userDoc.exists()) {
        console.log("Aucun utilisateur trouvé avec l'ID:", userId);
        return null;
      }

      const userData = { id: userDoc.id, ...userDoc.data() };

      setUsersCache(prev => ({ ...prev, [userId]: userData }));
      return userData;
    } catch (err) {
      setError(err instanceof Error ? err : new Error(String(err)));
      console.error("Erreur lors de la récupération de l'utilisateur:", err);
      return null;
    } finally {
      setLoading(false);
    }
  }, [usersCache]);

  // Fonction pour récupérer une liste d'utilisateurs avec pagination
  const fetchUsers = useCallback(async () => {
    if (loading || !hasMore) return;

    setLoading(true);
    setError(null);

    try {
      let q = query(collection(db, 'users'), limit(pageSize));
      if (lastDoc) q = query(q, startAfter(lastDoc));

      const querySnapshot = await getDocs(q);
      if (querySnapshot.empty) {
        setHasMore(false);
        return;
      }

      const usersData = querySnapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data(),
      }));

      setUsers(prev => [...prev, ...usersData]);
      setLastDoc(querySnapshot.docs[querySnapshot.docs.length - 1]);
      setHasMore(querySnapshot.docs.length === pageSize);
    } catch (err) {
      setError(err instanceof Error ? err : new Error(String(err)));
      console.error("Erreur lors de la récupération des utilisateurs:", err);
    } finally {
      setLoading(false);
    }
  }, [lastDoc, loading, hasMore]);

  // Fonction pour rafraîchir la liste des utilisateurs
  const refreshUsers = useCallback(async () => {
    setUsers([]);
    setLastDoc(null);
    setHasMore(true);
    await fetchUsers();
  }, [fetchUsers]);

  // Fonction pour rechercher des utilisateurs par nom ou prénom
  const searchUsers = useCallback(async (searchTerm: string) => {
    if (!searchTerm.trim()) return refreshUsers();

    setLoading(true);
    setError(null);

    try {
      const searchTermLower = searchTerm.toLowerCase();
      const q = query(collection(db, 'users'), limit(100)); // TODO: Remplacer par une requête optimisée avec Firestore
      const querySnapshot = await getDocs(q);

      const matchingUsers = querySnapshot.docs
        .map(doc => ({ id: doc.id, ...doc.data() }))
        .filter(user =>
          user.nom?.toLowerCase().includes(searchTermLower) ||
          user.prenom?.toLowerCase().includes(searchTermLower)
        );

      setUsers(matchingUsers);
      setHasMore(false); // Désactiver la pagination pour la recherche
    } catch (err) {
      setError(err instanceof Error ? err : new Error(String(err)));
      console.error("Erreur lors de la recherche d'utilisateurs:", err);
    } finally {
      setLoading(false);
    }
  }, [refreshUsers]);

  // Chargement initial des utilisateurs au montage
  useEffect(() => {
    fetchUsers();
  }, [fetchUsers]);

  return {
    getUserById,
    users,
    loading,
    hasMore,
    error,
    fetchUsers,
    refreshUsers,
    searchUsers,
    usersCache,
  };
};
