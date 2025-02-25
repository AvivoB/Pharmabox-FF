import { useState, useEffect } from 'react';
import { collection, query, orderBy, limit, startAfter, getDocs } from 'firebase/firestore';
import { db } from '@/common/firebase';

const PAGE_SIZE = 10;

export const usePharmablabla = () => {
  const [data, setData] = useState<any[]>([]);
  const [lastDoc, setLastDoc] = useState<any>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [hasMore, setHasMore] = useState<boolean>(true);

  const fetchData = async () => {
    setLoading(true);
    const q = query(
      collection(db, 'pharmablabla'),
      orderBy('date_created'),
      limit(PAGE_SIZE),
      lastDoc ? startAfter(lastDoc) : undefined
    );

    const querySnapshot = await getDocs(q);
    const docs = querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

    setData(prevData => [...prevData, ...docs]);
    setLastDoc(querySnapshot.docs[querySnapshot.docs.length - 1]);
    setHasMore(querySnapshot.docs.length === PAGE_SIZE);
    setLoading(false);
  };

  useEffect(() => {
    fetchData();
    console.log('fetching data');
    console.log(data);
  }, []);

  return { data, loading, hasMore, fetchData };
};