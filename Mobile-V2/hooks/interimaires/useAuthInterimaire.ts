import { useState, useEffect } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import axios from 'axios';
import api from '@/common/axios';

interface AuthInterimaireState {
  token: string | null;
  isLoading: boolean;
  error: string | null;
  isAuthenticated: boolean;
  currentPhone?: string | null;
}

export const useAuthInterimaire = () => {
  const [auth, setAuth] = useState<AuthInterimaireState>({
    token: null,
    isLoading: false,
    error: null,
    isAuthenticated: false,
    currentPhone: null,
  });

  useEffect(() => {
    const loadToken = async () => {
      try {
        const storedToken = await AsyncStorage.getItem('authToken');
        if (storedToken) {
          setAuth(prev => ({ ...prev, token: storedToken, isAuthenticated: true }));
        }
      } catch (error) {
        console.error('Erreur lors du chargement du token:', error);
      }
    };

    loadToken();
  }, []);

  const login = async (phone: string) => {
    setAuth(prev => ({ ...prev, isLoading: true, error: null }));

    try {
      const response = await api.post('/interimaires/login', { phone });
      AsyncStorage.setItem('phone', phone);
      return response.data;
    } catch (error) {
      setAuth({ token: null, isLoading: false, error: 'Erreur', isAuthenticated: false });
    }
  };


    const verifyOTP = async (otp: string) => {	
        setAuth(prev => ({ ...prev, isLoading: true, error: null }));	
        try {	
            const phone = await AsyncStorage.getItem('phone');
            const response = await api.post('/interimaires/verifyOTP', { phone: phone, otp });
            const { token } = response.data;
            await AsyncStorage.setItem('authToken', token);	
            setAuth({ token, isLoading: false, error: null, isAuthenticated: true });	
            return token;
        } catch (error) {	
            setAuth({ token: null, isLoading: false, error: 'Le code semble inccorect', isAuthenticated: false });	
        }
    };



  const logout = async () => {
    try {
      await AsyncStorage.removeItem('authToken');
      setAuth({ token: null, isLoading: false, error: null, isAuthenticated: false });
    } catch (error) {
      console.error('Erreur lors de la déconnexion:', error);
    }
  };

  return {
    token: auth.token,
    isLoading: auth.isLoading,
    error: auth.error,
    isAuthenticated: auth.isAuthenticated,
    login,
    verifyOTP,
    logout,
  };
};
