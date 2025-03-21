import { collection, getDocs } from 'firebase/firestore';
import { useState, useEffect } from 'react';
import { db } from '../common/firebase';

export interface Pharmacie {
  id: string;
  nom: string;
  image?: string;
  situation_geographique: {
    data: {
      latitude: number;
      longitude: number;
    }
  }
}

export const usePharmacies = () => {
  const [pharmacies, setPharmacies] = useState<Pharmacie[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchPharmacies = async () => {
    try {
      setLoading(true);
      const pharmaciesRef = collection(db, 'pharmacies');
      const snapshot = await getDocs(pharmaciesRef);
      const pharmaciesData = snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      })) as Pharmacie[];
      
      setPharmacies(pharmaciesData);
      setError(null);
    } catch (err) {
      setError("Erreur lors du chargement des pharmacies");
      console.error("Erreur:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchPharmacies();
  }, []);

  return { pharmacies, loading, error, refetch: fetchPharmacies };
};